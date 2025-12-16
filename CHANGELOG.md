# Changelog - SmartBin Monitor

## Version 1.2.0 - API Integration

### 🔌 API Integration
- Integrated with SmartBin REST API
- Real-time data fetching from server
- Auto-refresh every 30 seconds
- Connection status indicator (Live/Offline)
- Fallback to cached data when offline
- HTTP client for API communication

### 🛠️ Technical Changes
- Added `ApiService` for API calls
- Added `ApiConstants` for configuration
- Updated `BinModel` with API response mapping
- Updated `BinRepository` with API integration
- Added `ConnectionProvider` for status monitoring
- Added internet permissions for Android
- Caching system with Hive for offline support

### 📡 API Endpoints
- GET `/bins_extended/` - Fetch all bins with fill data
- GET `/bins/{id}` - Get single bin details
- GET `/measurements/` - Get measurements history
- GET `/measurements/{id}/latest` - Get latest measurement
- GET `/health` - Health check endpoint

### 🎯 Features
- Real-time bin monitoring from API
- Automatic fallback to dummy data if API unavailable
- Connection status badge (green for online, orange for offline)
- Seamless offline/online transitions
- Data caching for better performance

---

## Version 1.1.2 - UI Simplification

### 🎨 UI Changes
- Removed AppBar with "SmartBin Monitor" title and icon
- Made "Overview" the main header directly in the body
- Cleaner, more spacious layout with better focus on content
- Adjusted top padding for better visual balance

---

## Version 1.1.1 - Animation Refinement

### 🔧 Improvements
- Removed rolling/counting number animations from overview dashboard
- Replaced with instant display for better readability
- Kept smooth fade-in animations for cards
- Improved user experience with cleaner transitions

---

## Version 1.1.0 - Enhanced UI & Dark Mode

### ✨ New Features

#### 🌓 Dark Mode Support
- Implemented full dark mode/light mode toggle
- System theme detection support
- Smooth theme transitions
- Dark mode optimized colors for all screens
- Theme settings in Settings screen with 3 options:
  - Light Mode
  - Dark Mode  
  - System Default

#### 🎨 Enhanced Animations
- **Home Screen**:
  - Fade-in and slide-up animations for all elements
  - Staggered animation for stats cards
  - Animated bin list items with delay
  - Pulsing "Live" indicator with gradient
  - Smooth refresh animations

- **Stats Cards**:
  - Scale and rotate entrance animations
  - Animated number counting effect
  - Gradient backgrounds with shadows
  - Elastic bounce effect on load

- **Bin List Items**:
  - Hover effects with scale and glow
  - Animated progress bars with gradients
  - Smooth icon rotations
  - Enhanced shadows on hover
  - Gradient borders on interaction

- **Analytics Screen**:
  - Fade and slide animations for charts
  - Animated stat cards with counting numbers
  - Smooth transitions between data

- **Bin Detail Screen**:
  - Animated progress indicators
  - Counting number animations
  - Smooth card entrance effects
  - Enhanced info cards with gradients

- **Bottom Navigation**:
  - Icon scale animations on selection
  - Smooth page transitions with fade
  - Rounded top corners
  - Enhanced shadows

### 🎯 UI Improvements

#### Dashboard Enhancements
- Modern gradient backgrounds
- Enhanced card designs with shadows
- Better spacing and typography
- Improved color schemes for dark mode
- Icon containers with gradients
- Better visual hierarchy

#### Settings Screen
- Redesigned with icon headers
- Visual theme selector with radio-style options
- Better organized sections
- Enhanced card layouts

#### Charts & Visualizations
- Dark mode support for all charts
- Better grid lines and borders
- Enhanced tooltips
- Improved color contrasts

### 🔧 Technical Improvements
- Added ThemeMode to AppSettings model
- Persistent theme preference storage
- Optimized animation controllers
- Better state management for themes
- Improved widget composition

### 📱 Compatibility
- Fully responsive design
- Smooth 60fps animations
- Optimized for both light and dark themes
- Cross-platform support (Android, iOS, Web)

---

## Version 1.0.0 - Initial Release

### Features
- Real-time bin monitoring
- Analytics dashboard with charts
- Notification system
- Onboarding flow
- Local data persistence with Hive
- 5 dummy bins with history data
