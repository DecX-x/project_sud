# SmartBin API Integration Guide

## Overview
Aplikasi SmartBin Monitor telah terintegrasi dengan REST API untuk mendapatkan data real-time dari server.

## API Configuration

### Base URL
```
https://sud-api-jy24z.ondigitalocean.app
```

### API Key
```
832gx73f3i493fg9v2nnn
```

### Headers
```dart
{
  'X-API-Key': '832gx73f3i493fg9v2nnn',
  'Content-Type': 'application/json',
}
```

## API Endpoints

### 1. Health Check
```
GET /health
```
Mengecek status server.

**Response:**
```json
{
  "status": "healthy"
}
```

### 2. Get All Bins (Extended)
```
GET /bins_extended/
```
Mendapatkan semua bin dengan data fill level terbaru.

**Response:**
```json
[
  {
    "id": 1,
    "name": "Bin A",
    "location": "Building A",
    "height_cm": 50.0,
    "fill_percent": 75.5,
    "distance_cm": 12.25,
    "last_measurement_time": "2024-01-15T10:30:00"
  }
]
```

### 3. Get Single Bin
```
GET /bins/{id}
```
Mendapatkan detail bin berdasarkan ID.

### 4. Get Measurements
```
GET /measurements/?bin_id={id}&limit={limit}
```
Mendapatkan history measurements untuk bin tertentu.

**Query Parameters:**
- `bin_id` (optional): Filter by bin ID
- `limit` (optional): Limit jumlah data (default: 100)

**Response:**
```json
[
  {
    "id": 1,
    "bin_id": 1,
    "fill_percent": 75.5,
    "distance_cm": 12.25,
    "timestamp": "2024-01-15T10:30:00"
  }
]
```

### 5. Get Latest Measurement
```
GET /measurements/{bin_id}/latest
```
Mendapatkan measurement terbaru untuk bin tertentu.

## How It Works

### 1. Data Fetching
- Aplikasi fetch data dari API setiap 30 detik
- Data di-cache ke Hive untuk offline support
- Jika API gagal, aplikasi menggunakan cached data

### 2. Connection Status
- Badge "Live" (hijau) = Connected to API
- Badge "Offline" (orange) = Using cached data
- Status di-check setiap 30 detik

### 3. Offline Support
- Data ter-cache di local storage (Hive)
- Aplikasi tetap berfungsi tanpa internet
- Auto-sync ketika koneksi kembali

## File Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart      # API configuration
│   ├── services/
│   │   └── api_service.dart        # API calls
│   └── providers/
│       └── connection_provider.dart # Connection status
├── data/
│   ├── models/
│   │   └── bin_model.dart          # Data model with API mapping
│   └── repositories/
│       └── bin_repository.dart     # Data layer with API integration
```

## Configuration

Untuk mengubah API URL atau API Key, edit file:
```dart
lib/core/constants/api_constants.dart
```

```dart
class ApiConstants {
  static const String baseUrl = 'YOUR_API_URL';
  static const String apiKey = 'YOUR_API_KEY';
  
  // ...
}
```

## Testing

### Test API Connection
1. Pastikan device/emulator memiliki koneksi internet
2. Jalankan aplikasi
3. Lihat badge di pojok kanan atas:
   - Hijau "Live" = API connected
   - Orange "Offline" = Using cache

### Test Offline Mode
1. Jalankan aplikasi dengan internet
2. Matikan internet/wifi
3. Pull to refresh
4. Aplikasi akan menampilkan cached data
5. Badge berubah menjadi "Offline"

## Error Handling

### API Errors
- Connection timeout → Fallback to cache
- Invalid API key → Fallback to cache
- Server error → Fallback to cache
- No internet → Use cache

### Fallback Strategy
1. Try fetch from API
2. If fails, use cached data
3. If no cache, use dummy data
4. Show connection status to user

## Dependencies

```yaml
dependencies:
  http: ^1.2.2              # HTTP client
  hive: ^2.2.3              # Local cache
  hive_flutter: ^1.1.0      # Hive Flutter support
  flutter_riverpod: ^3.0.3  # State management
```

## Permissions

### Android
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

### iOS
No additional permissions needed for HTTP requests.

## Future Improvements

- [ ] Add retry mechanism with exponential backoff
- [ ] Implement WebSocket for real-time updates
- [ ] Add push notifications for bin alerts
- [ ] Implement data sync queue for offline actions
- [ ] Add analytics for API performance
- [ ] Implement request caching with TTL
