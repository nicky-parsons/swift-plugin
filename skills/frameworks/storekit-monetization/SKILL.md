---
name: storekit-monetization
description: Implement in-app purchases, subscriptions, and monetization using StoreKit 2 API with Product, Transaction, purchase validation, subscription management, and App Store Server API integration. Use when adding paid features, consumables, non-consumables, auto-renewable subscriptions, or handling purchase restoration.
version: 1.0.0
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
---

# StoreKit Monetization

## What This Skill Does

Comprehensive guidance on implementing in-app purchases and subscriptions using StoreKit 2 (iOS 15+). Covers product loading, purchasing, transaction validation, subscription management, and App Store Server API integration.

## When to Activate

- Implementing in-app purchases
- Adding subscription features
- Validating purchase receipts
- Managing subscription status
- Restoring previous purchases
- Handling refunds and cancellations
- Testing purchases in sandbox

## Core Concepts

### Product Types

**Consumable**: Used once (coins, lives, boosts)
**Non-Consumable**: Permanent (premium features, remove ads)
**Auto-Renewable Subscription**: Recurring payment (monthly/yearly premium)
**Non-Renewing Subscription**: Fixed duration, manual renewal

### StoreKit 2 Benefits

- Modern async/await API
- Simplified transaction handling
- Automatic receipt validation
- Better subscription management
- Type-safe product identifiers

## Implementation Patterns

### Loading Products

```swift
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var products: [Product] = []
    @Published var purchasedProductIDs = Set<String>()

    private let productIDs = [
        "com.app.premium.monthly",
        "com.app.premium.yearly",
        "com.app.coins.small",
        "com.app.removeads"
    ]

    init() {
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }

            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
}
```

### Purchasing Products

```swift
extension StoreManager {
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)

            // Deliver content
            await updatePurchasedProducts()

            // Finish transaction
            await transaction.finish()

            return transaction

        case .userCancelled:
            return nil

        case .pending:
            return nil

        @unknown default:
            return nil
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

enum StoreError: Error {
    case failedVerification
}
```

### SwiftUI Purchase View

```swift
struct StoreView: View {
    @StateObject private var store = StoreManager()

    var body: some View {
        List {
            Section("Subscriptions") {
                ForEach(store.products.filter { $0.type == .autoRenewable }) { product in
                    ProductRow(product: product, isPurchased: store.purchasedProductIDs.contains(product.id))
                }
            }

            Section("One-Time Purchases") {
                ForEach(store.products.filter { $0.type == .nonConsumable }) { product in
                    ProductRow(product: product, isPurchased: store.purchasedProductIDs.contains(product.id))
                }
            }
        }
        .navigationTitle("Store")
    }
}

struct ProductRow: View {
    let product: Product
    let isPurchased: Bool
    @StateObject private var store = StoreManager()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.displayName)
                    .font(.headline)
                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isPurchased {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Button(product.displayPrice) {
                    Task {
                        try? await store.purchase(product)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
    }
}
```

### Subscription Status

```swift
extension StoreManager {
    func checkSubscriptionStatus(for productID: String) async -> SubscriptionStatus {
        guard let product = products.first(where: { $0.id == productID }) else {
            return .notSubscribed
        }

        guard let statuses = try? await product.subscription?.status else {
            return .notSubscribed
        }

        for status in statuses {
            switch status.state {
            case .subscribed:
                return .active
            case .expired:
                return .expired
            case .inGracePeriod:
                return .gracePeriod
            case .inBillingRetryPeriod:
                return .billingRetry
            case .revoked:
                return .revoked
            default:
                break
            }
        }

        return .notSubscribed
    }
}

enum SubscriptionStatus {
    case notSubscribed
    case active
    case expired
    case gracePeriod
    case billingRetry
    case revoked
}
```

### Restore Purchases

```swift
extension StoreManager {
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }
}

// In UI
Button("Restore Purchases") {
    Task {
        await store.restorePurchases()
    }
}
```

### Transaction Listener

```swift
@MainActor
class TransactionObserver {
    var updates: Task<Void, Never>?

    init() {
        updates = observeTransactionUpdates()
    }

    deinit {
        updates?.cancel()
    }

    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                guard case .verified(let transaction) = verificationResult else { continue }

                // Deliver content
                await handleTransaction(transaction)

                // Finish transaction
                await transaction.finish()
            }
        }
    }

    private func handleTransaction(_ transaction: Transaction) async {
        // Update purchased products
        // Deliver content
        print("Transaction updated: \(transaction.productID)")
    }
}
```

### Promotional Offers

```swift
extension StoreManager {
    func purchaseWithOffer(product: Product, offerID: String) async throws {
        guard let subscription = product.subscription else { return }
        guard let offer = subscription.promotionalOffers.first(where: { $0.id == offerID }) else { return }

        let result = try await product.purchase(options: [.promotionalOffer(offerID: offer.id, keyID: "YOUR_KEY_ID", nonce: UUID(), signature: Data(), timestamp: Int(Date().timeIntervalSince1970))])

        // Handle result...
    }
}
```

## Best Practices

1. **Use StoreKit 2** - Modern API with better safety and simplicity
2. **Validate transactions** - Check `.verified` before delivering content
3. **Finish transactions** - Call `transaction.finish()` after delivery
4. **Listen for updates** - Observe `Transaction.updates` for background purchases
5. **Test thoroughly** - Use sandbox environment before production
6. **Handle errors gracefully** - User cancellation, network issues, etc.
7. **Provide restore option** - Required by App Store guidelines
8. **Cache product info** - Don't fetch on every view
9. **Handle refunds** - Check `transaction.revocationDate`
10. **Follow guidelines** - App Store Review Guidelines for IAP

## Common Pitfalls

1. **Not finishing transactions**
   - ❌ Forgetting `transaction.finish()`
   - ✅ Always finish after content delivery

2. **Hardcoding product IDs**
   - ❌ Strings scattered in code
   - ✅ Centralized constants

3. **Not handling refunds**
   - ❌ Ignoring `revocationDate`
   - ✅ Check and remove access

4. **Poor error handling**
   - ❌ Crashes on network errors
   - ✅ Graceful degradation

5. **Not testing sandbox**
   - ❌ Only testing in production
   - ✅ Test all scenarios in sandbox

6. **Blocking UI during purchase**
   - ❌ Synchronous purchase flow
   - ✅ Async with loading indicator

7. **Not providing restore**
   - ❌ No restore purchases button
   - ✅ Easily accessible restore option

8. **Forgetting transaction listener**
   - ❌ Missing background purchases
   - ✅ Observe Transaction.updates

## Related Skills

- `swiftui-essentials` - Building store UI
- `networking-patterns` - App Store Server API
- `testing-fundamentals` - Testing purchases
- `deployment-essentials` - App Store setup

