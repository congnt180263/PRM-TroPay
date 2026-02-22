# TroPay Flutter - Quick Start Guide

## ⚡ Bắt đầu nhanh

### 1. Cài đặt dependencies (đã xong ✅)
```bash
flutter pub get
```

### 2. Cấu hình Backend URL

Mở `lib/core/constants/api_config.dart` và đổi `baseUrl`:

```dart
// Android Emulator (mặc định)
static const String baseUrl = 'http://10.0.2.2:3000/api';

// Physical Device (thay YOUR_IP)
static const String baseUrl = 'http://192.168.1.XXX:3000/api';
```

**Tìm IP máy:**
```powershell
ipconfig
```

### 3. Chạy Backend
```powershell
cd C:\Users\DELL\Desktop\TroPay_BE\PRM-TroPay-BE
npm run dev
```

### 4. Chạy Flutter App
```bash
flutter run
```

## 📖 Tài liệu đầy đủ

- [FLUTTER_AUTH_INTEGRATION.md](./FLUTTER_AUTH_INTEGRATION.md) - Hướng dẫn chi tiết tích hợp Auth

## 🎯 Test Flow

1. Mở app → Chọn "Đăng ký ngay"
2. Chọn role → Điền form → Đăng ký
3. Login với email và password vừa tạo
4. Xem console logs để theo dõi API calls

## ✅ Tính năng

- ✅ Login/Register với JWT
- ✅ Auto token refresh (15 phút)
- ✅ Secure storage (encrypted)
- ✅ Logout
- ✅ Change password
- ✅ Forgot/Reset password

## 🐛 Lỗi thường gặp

**Connection refused:**
- Kiểm tra backend đang chạy
- Kiểm tra URL trong `api_config.dart`
- Android Emulator dùng `10.0.2.2`, Physical Device dùng IP máy

**Email already exists:**
- Email đã được đăng ký
- Dùng email khác hoặc clear database

---

Good luck! 🚀
