# OHO User App

A Flutter-based grocery delivery application with comprehensive features for users to browse products, manage orders, and track deliveries.

## Features

- ✅ Universal APK support for all Android architectures
- ✅ Fixed date selection functionality in checkout
- ✅ Comprehensive order management system
- ✅ Real-time order tracking
- ✅ Wallet integration
- ✅ Coupon system
- ✅ Multiple payment gateways (Razorpay, PhonePe, COD)
- ✅ Address management
- ✅ Product search and filtering
- ✅ Wishlist functionality
- ✅ User reviews and ratings

## Recent Fixes

- Fixed APK installation compatibility issues by removing architecture restrictions
- Enhanced date picker with proper error handling and null safety
- Improved date validation logic for better user experience
- Ready for Google Play Store deployment (AAB format available)

## Getting Started

1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Configure your API endpoints in `lib/General/AppConstant.dart`
4. Run `flutter run` to start the application

## Build for Production

- Debug APK: `flutter build apk --debug`
- Release APK: `flutter build apk --release`
- App Bundle (for Play Store): `flutter build appbundle --release`

## Project Structure

- `lib/grocery/` - Main grocery app functionality
- `lib/Auth/` - Authentication screens and logic
- `lib/model/` - Data models
- `lib/screen/` - UI screens
- `assets/` - Images, fonts, and other assets

## Contributing

Please ensure all commits follow the established code style and include proper testing.
