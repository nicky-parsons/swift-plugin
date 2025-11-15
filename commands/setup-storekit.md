---
description: Set up in-app purchases and subscriptions infrastructure with StoreKit 2
---

You are setting up in-app purchases infrastructure. Please:

1. **Ask the user about their monetization needs:**
   - Type of purchases: Consumable, Non-consumable, Subscriptions
   - Product IDs they want to implement
   - Features to unlock with purchases
   - Subscription tiers (if applicable)

2. **Create the complete infrastructure:**

   **Store Manager:**
   - Product loading from App Store
   - Purchase handling with proper verification
   - Transaction processing
   - Purchase restoration
   - Subscription status checking
   - Error handling

   **SwiftUI Integration:**
   - Store view with product listings
   - Purchase buttons with loading states
   - Subscription status display
   - Restore purchases button

   **Configuration:**
   - Product ID constants
   - StoreKit configuration file (if testing)

3. **Include best practices:**
   - Transaction verification
   - Proper `transaction.finish()` calls
   - Background transaction observer
   - Handle all purchase states (success, cancelled, pending)
   - Refund handling
   - Offline capability

4. **Provide setup instructions for:**
   - App Store Connect configuration
   - Product creation in App Store Connect
   - StoreKit configuration file for testing
   - Sandbox testing setup
   - Production checklist

5. **Generate:**
   - Complete StoreManager class
   - SwiftUI store view
   - Product model/constants
   - Testing guide
   - App Store Connect checklist

Activate the `storekit-monetization` skill for complete implementation.
