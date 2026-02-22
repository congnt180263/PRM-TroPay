# Flutter Auth Integration Guide

## 🎯 Tổng quan

Flutter app đã được tích hợp đầy đủ với Backend JWT Authentication API. Tài liệu này hướng dẫn cách sử dụng và test.

## ✅ Đã hoàn thành

### 1. Dependencies đã thêm
- `dio: ^5.4.0` - HTTP client với interceptor
- `flutter_secure_storage: ^9.0.0` - Lưu trữ tokens an toàn

### 2. Cấu trúc code đã tạo

```
lib/
├── core/
│   ├── constants/
│   │   └── api_config.dart              # API endpoints & configuration
│   └── services/
│       ├── secure_storage_service.dart  # Secure token storage
│       └── http_client_service.dart     # HTTP client with auto token refresh
│
└── features/
    └── auth/
        ├── data/
        │   ├── models/
        │   │   ├── api_response.dart    # Generic API response wrapper
        │   │   └── auth_models.dart     # Login, Register, Profile models
        │   └── services/
        │       └── auth_service.dart    # All API calls to backend
        └── presentation/
            ├── providers/
            │   └── auth_provider.dart   # State management (Updated)
            └── pages/
                ├── login_page.dart      # Login UI (Updated)
                └── register_page.dart   # Register UI (Updated)
```

### 3. Tính năng đã implement

✅ **Login** - Đăng nhập với email & password  
✅ **Register** - Đăng ký tài khoản mới  
✅ **Auto Token Refresh** - Tự động làm mới access token khi hết hạn  
✅ **Secure Storage** - Lưu tokens an toàn với encryption  
✅ **Logout** - Đăng xuất và clear tokens  
✅ **Get Profile** - Lấy thông tin user  
✅ **Change Password** - Đổi mật khẩu  
✅ **Forgot Password** - Yêu cầu reset password  
✅ **Reset Password** - Reset password với token  
✅ **Error Handling** - Xử lý lỗi toàn diện  

## 🚀 Cách chạy

### Bước 1: Cài đặt dependencies

```bash
cd C:\Users\DELL\Desktop\Flutter-TroPay\PRM-TroPay\tropay_app
flutter pub get
```

### Bước 2: Cấu hình Backend URL

Mở file `lib/core/constants/api_config.dart` và cập nhật `baseUrl`:

```dart
// Cho Android Emulator
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Cho iOS Simulator  
static const String baseUrl = 'http://localhost:3000/api';

// Cho Physical Device (thay YOUR_IP bằng IP máy bạn)
static const String baseUrl = 'http://192.168.1.XXX:3000/api';
```

**Tìm IP máy:**
```powershell
ipconfig
# Tìm IPv4 Address trong kết quả
```

### Bước 3: Chạy Backend Server

```powershell
cd C:\Users\DELL\Desktop\TroPay_BE\PRM-TroPay-BE
npm run dev
```

Backend sẽ chạy tại `http://localhost:3000`

### Bước 4: Chạy Flutter App

```bash
# Android
flutter run

# iOS (cần Mac)
flutter run -d ios

# Chrome (web)
flutter run -d chrome
```

## 📱 Cách sử dụng

### 1. Login

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

final success = await authProvider.login(
  email: 'test@example.com',
  password: 'password123',
);

if (success) {
  // Đăng nhập thành công
  print('User: ${authProvider.currentUser?.fullName}');
} else {
  // Đăng nhập thất bại  
  print('Error: ${authProvider.errorMessage}');
}
```

### 2. Register

```dart
final success = await authProvider.register(
  fullName: 'Nguyen Van A',
  email: 'nguyenvana@example.com',
  password: 'password123',
  phoneNumber: '0901234567', // Optional
);
```

### 3. Logout

```dart
await authProvider.logout();
// Tokens đã bị xóa, user đã bị logout
```

### 4. Check Authentication Status

```dart
if (authProvider.isAuthenticated) {
  // User đã đăng nhập
  print('Logged in as: ${authProvider.currentUser?.email}');
} else {
  // User chưa đăng nhập
}
```

### 5. Get Profile

```dart
await authProvider.refreshProfile();
// Profile data được update trong authProvider.currentUser
```

### 6. Change Password

```dart
final success = await authProvider.changePassword(
  currentPassword: 'oldpassword',
  newPassword: 'newpassword',
);
```

### 7. Forgot Password

```dart
final success = await authProvider.forgotPassword(
  email: 'test@example.com',
);
// Reset token sẽ được trả về (trong development mode)
```

## 🔍 Testing

### Test với Flutter App

1. **Register User Mới:**
   - Mở app
   - Click "Đăng ký ngay"
   - Chọn role (Owner hoặc Tenant)
   - Điền form và submit
   - Kiểm tra console logs để xem request/response

2. **Login:**
   - Nhập email và password vừa đăng ký
   - Click "Đăng nhập"
   - Nếu thành công, navigate tới home screen

3. **Auto Token Refresh:**
   - Access token có hiệu lực 15 phút
   - Sau 15 phút, bất kỳ API call nào sẽ tự động refresh token
   - Kiểm tra console logs để thấy "🔄 Refreshing token..."

### Test với Postman

Import collection từ backend:
`C:\Users\DELL\Desktop\TroPay_BE\PRM-TroPay-BE\TroPay_Auth_API.postman_collection.json`

## 🐛 Troubleshooting

### Lỗi: Connection refused / Network error

**Nguyên nhân:** Flutter app không kết nối được backend

**Giải pháp:**
1. Kiểm tra backend đang chạy: `http://localhost:3000/health`
2. Kiểm tra URL trong `api_config.dart` đúng chưa
3. Với Android Emulator, phải dùng `10.0.2.2` thay vì `localhost`
4. Với Physical Device, phải dùng IP máy (cùng WiFi)

### Lỗi: Invalid email or password

**Nguyên nhân:** Email hoặc password sai, hoặc user chưa được tạo

**Giải pháp:**
1. Kiểm tra user đã được đăng ký chưa
2. Kiểm tra password đúng chưa (min 6 characters)
3. Xem logs trong console để thấy error message chi tiết

### Lỗi: flutter_secure_storage not found

**Nguyên nhân:** Dependencies chưa được install

**Giải pháp:**
```bash
flutter pub get
flutter clean
flutter pub get
```

### Lỗi: Token expired / Unauthorized

**Nguyên nhân:** Access token hết hạn và refresh token cũng hết hạn

**Giải pháp:**
- Logout và login lại
- Refresh token có hiệu lực 7 ngày, sau đó cần login lại

## 🔐 Security Notes

### Development
- ✅ Tokens được lưu trong Secure Storage (encrypted)
- ✅ Auto token refresh
- ✅ Debug logs hiển thị requests (chỉ debug mode)

### Production
- ⚠️ Set `kDebugMode = false`
- ⚠️ Disable debug logs
- ⚠️ Sử dụng HTTPS cho backend
- ⚠️ Validate SSL certificates
- ⚠️ Implement certificate pinning (optional)

## 📊 State Management Flow

```
User opens app
    ↓
AuthProvider._loadUser()
    ↓
Check SecureStorage for tokens
    ↓
If tokens exist → Get fresh profile from API
    ↓
Update currentUser in AuthProvider
    ↓
UI rebuilds with authenticated state
```

## 🌐 API Endpoints được sử dụng

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/auth/register` | POST | Đăng ký user mới |
| `/auth/login` | POST | Đăng nhập |
| `/auth/profile` | GET | Lấy thông tin profile |
| `/auth/refresh-token` | POST | Làm mới access token |
| `/auth/logout` | POST | Đăng xuất |
| `/auth/change-password` | POST | Đổi mật khẩu |
| `/auth/forgot-password` | POST | Yêu cầu reset password |
| `/auth/reset-password` | POST | Reset password |

## 📝 Data Models

### UserData (từ backend)
```dart
{
  "id": "string",
  "email": "string",
  "fullName": "string",
  "role": "string" // user, owner, admin, merchant, support
}
```

### LoginResponse
```dart
{
  "accessToken": "string",
  "refreshToken": "string",
  "user": UserData
}
```

## 🔧 Customization

### Thay đổi timeout

Mở `lib/core/constants/api_config.dart`:

```dart
static const Duration connectTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
```

### Thay đổi token expiration

Backend configuration trong `.env`:
```env
JWT_EXPIRE=15m          # Access token
JWT_REFRESH_EXPIRE=7d   # Refresh token
```

### Thêm custom headers

Mở `lib/core/services/http_client_service.dart`:

```dart
options.headers['Custom-Header'] = 'value';
```

## 📚 References

- Backend API Documentation: `C:\Users\DELL\Desktop\TroPay_BE\PRM-TroPay-BE\AUTH_API.md`
- Backend Setup Guide: `C:\Users\DELL\Desktop\TroPay_BE\PRM-TroPay-BE\SETUP_GUIDE.md`
- Postman Collection: `C:\Users\DELL\Desktop\TroPay_BE\PRM-TroPay-BE\TroPay_Auth_API.postman_collection.json`

## ✨ Next Steps

1. ✅ Test login/register flows
2. ✅ Test token refresh mechanism
3. ⬜ Implement forgot password UI
4. ⬜ Add biometric authentication (optional)
5. ⬜ Add social login (Google, Facebook) (optional)
6. ⬜ Implement role-based navigation
7. ⬜ Add profile edit functionality

## 💡 Tips

1. **Console Logs:** Kiểm tra console để debug, tất cả requests đều được log
2. **Error Messages:** Error messages từ backend được hiển thị trong `authProvider.errorMessage`
3. **Loading State:** Use `authProvider.isLoading` để hiển thị loading indicators
4. **Token Expiry:** Access token: 15 phút, Refresh token: 7 ngày
5. **Auto Refresh:** HTTP client tự động refresh token khi nhận 401 Unauthorized

---

**Created:** February 22, 2026  
**Author:** GitHub Copilot  
**Project:** TroPay Flutter App
