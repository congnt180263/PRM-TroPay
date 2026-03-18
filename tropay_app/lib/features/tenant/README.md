# Tenant Feature - TroPay Flutter App

## 📱 Tổng quan

Tenant Feature là module quản lý đầy đủ các chức năng dành cho người thuê trọ trong ứng dụng TroPay, được xây dựng với Flutter và kiến trúc Clean Architecture.

## 🏗️ Cấu trúc thư mục

```
lib/features/tenant/
├── data/
│   └── models/
│       ├── invoice_model.dart      # Model hóa đơn
│       ├── incident_model.dart     # Model sự cố
│       ├── service_model.dart      # Model dịch vụ
│       └── contract_model.dart     # Model hợp đồng
└── presentation/
    ├── pages/
    │   ├── tenant_main_page.dart           # Main navigation với bottom tabs
    │   ├── tenant_dashboard_page.dart      # Dashboard/Trang chủ
    │   ├── invoice_overview_page.dart      # Danh sách hóa đơn
    │   ├── service_management_page.dart    # Quản lý dịch vụ
    │   ├── incident_management_page.dart   # Quản lý sự cố
    │   ├── contract_page.dart              # Hợp đồng
    │   └── profile_page.dart               # Hồ sơ cá nhân
    └── providers/
        └── tenant_provider.dart            # State management
```

## ✨ Các tính năng chính

### 1. 🏠 Dashboard (Trang chủ)
- Hiển thị thông tin tổng quan phòng
- Tổng tiền chưa thanh toán
- Số lượng sự cố đang chờ xử lý
- Hóa đơn gần đây
- Sự cố đang xử lý
- Các thao tác nhanh

### 2. 💰 Quản lý Hóa đơn
- Xem danh sách hóa đơn (Chưa thanh toán / Đã thanh toán)
- Chi tiết hóa đơn với breakdown chi phí:
  - Tiền phòng
  - Tiền điện
  - Tiền nước
  - Dịch vụ
- Thanh toán online (MoMo integration ready)
- Lọc theo trạng thái
- Pull-to-refresh

### 3. 🛠️ Quản lý Dịch vụ
- **Dịch vụ hiện tại:**
  - Xem danh sách dịch vụ đang sử dụng
  - Giá và đơn vị tính
  - Trạng thái hoạt động
- **Lịch sử:**
  - Lịch sử sử dụng dịch vụ
  - Chi phí theo từng tháng

### 4. ⚠️ Quản lý Sự cố
- Xem danh sách sự cố
- Lọc theo trạng thái:
  - Chờ xử lý
  - Đang xử lý
  - Đã giải quyết
  - Đã từ chối
- Báo cáo sự cố mới với:
  - Tiêu đề
  - Mô tả chi tiết
  - Danh mục (Điện, Nước, Nội thất, Khác)
  - Mức độ ưu tiên (Thấp, Trung bình, Cao, Khẩn cấp)
- Xem chi tiết sự cố và phản hồi từ chủ nhà

### 5. 📄 Hợp đồng thuê
- Xem thông tin hợp đồng hiện tại
- Chi tiết:
  - Thông tin phòng và người thuê
  - Giá thuê và tiền cọc
  - Ngày bắt đầu và kết thúc
  - Số ngày còn lại
  - Điều khoản hợp đồng
- Tải xuống file hợp đồng (ready)

### 6. 👤 Hồ sơ cá nhân
- Xem thông tin cá nhân
- Chỉnh sửa hồ sơ
- Đổi mật khẩu
- Cài đặt thông báo
- Trợ giúp & Hỗ trợ
- Về ứng dụng
- Đăng xuất

## 🎨 UI/UX Highlights

- **Bottom Navigation Bar:** 6 tabs điều hướng chính
- **Material Design 3:** Sử dụng Material 3 components
- **Responsive:** Tối ưu cho các kích thước màn hình
- **Dark Mode Ready:** Hỗ trợ chế độ sáng/tối
- **Pull-to-Refresh:** Refresh dữ liệu trên tất cả các màn hình
- **Status Colors:**
  - 🟢 Xanh: Đã hoàn thành, Hoạt động
  - 🟡 Vàng: Chờ xử lý, Cảnh báo
  - 🔵 Xanh dương: Đang xử lý
  - 🔴 Đỏ: Quá hạn, Khẩn cấp, Lỗi

## 📊 Data Models

### InvoiceModel
```dart
- id, roomNumber, month
- totalAmount, electricCost, waterCost, roomCost, serviceCost
- status (paid/unpaid/overdue)
- dueDate, paidDate
```

### IncidentModel
```dart
- id, title, description
- category (electrical/plumbing/furniture/other)
- status (pending/in_progress/resolved/rejected)
- priority (low/medium/high/urgent)
- createdAt, resolvedAt, response
```

### ServiceModel
```dart
- id, name, description
- price, unit (month/kwh/m3/fixed)
- isActive
```

### ContractModel
```dart
- id, roomNumber
- ownerName, tenantName
- rentPrice, deposit
- startDate, endDate
- status (active/expired/terminated)
- terms[], documentUrl
```

## 🔧 State Management

Sử dụng **Provider** để quản lý state:

### TenantProvider

**Responsibilities:**
- Quản lý toàn bộ dữ liệu tenant
- Load và cache data
- Handle business logic
- Notify UI về changes

**Main Methods:**
- `initialize()` - Load tất cả dữ liệu ban đầu
- `loadDashboardData()` - Load thông tin dashboard
- `loadInvoices()` - Load danh sách hóa đơn
- `loadIncidents()` - Load danh sách sự cố
- `loadServices()` - Load dịch vụ
- `loadContract()` - Load hợp đồng
- `reportIncident()` - Báo cáo sự cố mới
- `payInvoice()` - Thanh toán hóa đơn
- `refreshAll()` - Refresh toàn bộ dữ liệu

## 🚀 Cách sử dụng

### 1. Import Provider vào app.dart

```dart
import 'package:tropay_app/features/tenant/presentation/providers/tenant_provider.dart';

MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => TenantProvider()),
  ],
  // ...
)
```

### 2. Navigate to Tenant Home

```dart
Navigator.pushNamed(context, AppRouter.tenantHome);
```

### 3. Access Provider trong Widget

```dart
// Read data
final provider = context.watch<TenantProvider>();
final invoices = provider.invoices;

// Call methods
context.read<TenantProvider>().loadInvoices();
```

## 🔄 Data Flow

```
UI (Widget) 
  ↓ User Action
Provider (TenantProvider)
  ↓ API Call (TODO)
API Service
  ↓ Response
Provider (Update State)
  ↓ notifyListeners()
UI (Rebuild)
```

## 📝 TODO - Next Steps

### API Integration
- [ ] Kết nối với backend API
- [ ] Implement authentication token
- [ ] Handle error states
- [ ] Add loading states
- [ ] Implement retry logic

### Payment Integration
- [x] Tích hợp MoMo payment gateway
- [x] Handle payment callbacks / IPN cập nhật trạng thái
- [x] Update invoice status after payment

### Additional Features
- [ ] Push notifications cho sự cố mới
- [ ] Real-time updates với WebSocket
- [ ] Upload hình ảnh khi báo cáo sự cố
- [ ] Export hóa đơn PDF
- [ ] Lịch sử thanh toán
- [ ] Feedback/Rating system

### UI Improvements
- [ ] Skeleton loading
- [ ] Animation transitions
- [ ] Empty state illustrations
- [ ] Error state designs
- [ ] Haptic feedback

## 🎯 Design Patterns

- **Clean Architecture:** Separation of concerns
- **Provider Pattern:** State management
- **Repository Pattern:** Data layer (ready for implementation)
- **MVVM:** Model-View-ViewModel structure

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/tenant/tenant_provider_test.dart

# Run with coverage
flutter test --coverage
```

## 📱 Screenshots

*(Screenshots sẽ được thêm sau khi UI hoàn thiện)*

- Dashboard
- Invoice List
- Invoice Detail
- Service Management
- Incident List
- Report Incident
- Contract View
- Profile

## 🤝 Contributing

Khi thêm features mới:

1. Tạo model trong `data/models/`
2. Thêm methods vào `TenantProvider`
3. Tạo UI page trong `presentation/pages/`
4. Update navigation nếu cần
5. Write tests
6. Update documentation

## 📄 License

MIT License - TroPay Team

---

**Developed with ❤️ by TroPay Development Team**

Last Updated: January 2026
