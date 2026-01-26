# Owner Feature - TroPay App

Giao diện quản lý dành cho chủ trọ trong ứng dụng TroPay.

## 📁 Cấu trúc thư mục

```
lib/features/owner/
├── data/
│   └── models/
│       ├── room_model.dart              # Model phòng trọ
│       ├── dashboard_stats_model.dart   # Model thống kê dashboard
│       └── feedback_model.dart          # Model phản hồi
└── presentation/
    ├── providers/
    │   └── owner_provider.dart          # State management
    └── pages/
        ├── owner_main_page.dart         # Navigation chính (5 tabs)
        ├── owner_dashboard_page.dart    # Dashboard tổng quan
        ├── owner_services_page.dart     # Quản lý dịch vụ
        ├── owner_incidents_page.dart    # Quản lý sự cố
        ├── owner_invoices_page.dart     # Quản lý hóa đơn
        ├── owner_profile_page.dart      # Hồ sơ chủ trọ
        └── owner_room_management_page.dart  # Quản lý phòng
```

## 🎯 Các tính năng chính

### 1. Dashboard (owner_dashboard_page.dart)
- ✅ Thống kê tổng quan: Tổng phòng, người thuê, doanh thu tháng, sự cố chờ, HĐ chưa thu
- ✅ Tỷ lệ lấp đầy phòng với biểu đồ tiến trình
- ✅ Biểu đồ doanh thu 6 tháng gần đây
- ✅ Thao tác nhanh: Thêm phòng, Tạo hóa đơn, Quản lý phòng, Báo cáo
- ✅ Hoạt động gần đây: Thanh toán, sự cố mới, hợp đồng mới
- ✅ Welcome card với thông tin chủ trọ
- ✅ Pull to refresh

### 2. Quản lý dịch vụ (owner_services_page.dart)
- ✅ Hiển thị danh sách dịch vụ với icon và màu sắc riêng
- ✅ Thêm dịch vụ mới (tên, mô tả, đơn giá, đơn vị)
- ✅ Chỉnh sửa dịch vụ
- ✅ Xóa dịch vụ (với xác nhận)
- ✅ Tạm dừng/Kích hoạt dịch vụ
- ✅ Hiển thị trạng thái: Đang hoạt động/Tạm dừng
- ✅ Icons tự động theo loại dịch vụ (điện, nước, wifi, vệ sinh, bảo vệ)

### 3. Quản lý sự cố (owner_incidents_page.dart)
- ✅ Tabs: Tất cả, Chờ xử lý, Đang xử lý, Đã xử lý
- ✅ Hiển thị thông tin: Tiêu đề, phòng, danh mục, mô tả
- ✅ Badges độ ưu tiên: Thấp, Trung bình, Cao, Khẩn cấp
- ✅ Badges trạng thái với màu sắc và icon
- ✅ Chi tiết sự cố với modal bottom sheet
- ✅ Cập nhật trạng thái:
  - Chờ xử lý → Bắt đầu xử lý
  - Đang xử lý → Đánh dấu đã xử lý
- ✅ Lọc theo trạng thái
- ✅ Pull to refresh

### 4. Quản lý hóa đơn (owner_invoices_page.dart)
- ✅ Tabs: Tất cả, Chưa thanh toán, Đã thanh toán
- ✅ Hiển thị: Phòng, kỳ thanh toán, hạn thanh toán, tổng tiền
- ✅ Chi tiết hóa đơn với breakdown:
  - Tiền phòng
  - Tiền điện
  - Tiền nước
  - Dịch vụ
  - Tổng cộng
- ✅ Xác nhận thanh toán (cập nhật trạng thái → paid)
- ✅ Badges trạng thái: Chưa thanh toán, Đã thanh toán, Quá hạn
- ✅ Tạo hóa đơn mới (placeholder - chờ backend)
- ✅ Pull to refresh

### 5. Quản lý phòng (owner_room_management_page.dart)
- ✅ Lọc phòng theo trạng thái: Tất cả, Trống, Đã thuê, Bảo trì
- ✅ Card hiển thị đầy đủ thông tin:
  - Số phòng và diện tích
  - Trạng thái với badge màu
  - Thông tin người thuê (nếu có)
  - Giá phòng và tiền cọc
  - Tiện nghi (hiển thị 3 đầu tiên)
- ✅ Chi tiết phòng với modal:
  - Thông tin phòng: Diện tích, giá, cọc, tầng
  - Thông tin người thuê (nếu đang cho thuê)
  - Danh sách tiện nghi đầy đủ
  - Mô tả phòng
- ✅ Thêm phòng mới
- ✅ Chỉnh sửa phòng
- ✅ Xóa phòng (với xác nhận)
- ✅ Pull to refresh

### 6. Hồ sơ (owner_profile_page.dart)
- ✅ Hiển thị avatar và thông tin cơ bản
- ✅ Menu sections:
  - **Tài khoản**: Chỉnh sửa hồ sơ, Đổi mật khẩu
  - **Quản lý**: Thông tin nhà trọ, Mẫu hợp đồng, Phương thức thanh toán
  - **Cài đặt**: Thông báo, Ngôn ngữ, Giao diện
  - **Hỗ trợ**: Trung tâm trợ giúp, Về ứng dụng
- ✅ Đăng xuất với xác nhận
- ✅ Placeholder cho các tính năng chờ phát triển

## 📊 Data Models

### RoomModel
```dart
- id: String
- roomNumber: String
- area: double (m²)
- price: double
- deposit: double
- status: String (available/occupied/maintenance)
- floor: int
- amenities: List<String>
- tenantName: String?
- tenantPhone: String?
- description: String
```

### DashboardStatsModel
```dart
- totalRooms: int
- occupiedRooms: int
- availableRooms: int
- maintenanceRooms: int
- totalTenants: int
- monthlyRevenue: double
- unpaidInvoices: int
- pendingIncidents: int
- occupancyRate: double (%)
```

### FeedbackModel
```dart
- id: String
- roomNumber: String
- tenantName: String
- rating: int (1-5)
- comment: String
- createdAt: DateTime
- status: String (pending/reviewed/resolved)
```

## 🎨 UI/UX Features

### Design Patterns
- **Material Design 3**: NavigationBar, Cards, Badges
- **Consistent Color Coding**:
  - 🟢 Green: Available, Paid, Resolved
  - 🔵 Blue: Occupied, In Progress
  - 🟠 Orange: Pending, Maintenance, Medium Priority
  - 🔴 Red: Overdue, High/Urgent Priority
- **Icons tự động**: Dịch vụ có icon riêng theo loại
- **Pull to Refresh**: Tất cả các danh sách
- **Modal Bottom Sheets**: Chi tiết phòng, sự cố, hóa đơn
- **Confirmation Dialogs**: Xóa, đăng xuất

### Responsive Components
- Cards với padding và margin đồng nhất
- Grid layout cho stats và quick actions
- Flexible layouts cho các kích thước màn hình
- Overflow handling cho text dài

## 🔄 State Management (OwnerProvider)

### Mock Data
```dart
- 20 tổng phòng (5 phòng mẫu)
- 15 phòng đã cho thuê
- Doanh thu: 37,500,000 VND/tháng
- 4 hóa đơn (mix paid/unpaid)
- 3 sự cố (pending/in_progress/resolved)
- 5 dịch vụ (điện, nước, internet, vệ sinh, bảo vệ)
- 3 feedbacks
- 6 tháng revenue chart data
```

### Methods
```dart
// Initialization
- initialize()
- refreshAll()

// Rooms
- addRoom()
- updateRoom()
- deleteRoom()

// Invoices
- createInvoice()
- updateInvoice()

// Incidents
- updateIncident()

// Services
- addService()
- updateService()
- deleteService()

// Feedbacks
- getFeedbacks()
- updateFeedback()
```

## 🚀 Sử dụng

1. **Đăng nhập với role Owner**
2. **Dashboard tự động load** khi vào app
3. **Navigate giữa các tabs** qua bottom navigation
4. **Pull to refresh** để cập nhật dữ liệu
5. **Tap vào item** để xem chi tiết
6. **FAB button** để thêm mới (Services, Invoices)
7. **Menu actions** để edit/delete

## 📝 Notes

- ✅ **Tất cả dữ liệu là MOCK** - chưa kết nối backend
- ✅ **Ready for API integration** - chỉ cần thay thế mock data
- ✅ **Format helpers** sử dụng FormatUtils cho currency và date
- ✅ **Error handling** với SnackBar
- ✅ **Loading states** với CircularProgressIndicator
- ⏳ **Backend API** chưa phát triển - sẽ tích hợp sau
- ⏳ **Create Invoice** - chờ backend để implement form đầy đủ
- ⏳ **Reports** - tính năng báo cáo chi tiết chờ phát triển

## 🎯 Next Steps (Khi có Backend)

1. Thay thế mock data bằng API calls
2. Implement pagination cho danh sách
3. Add search/filter nâng cao
4. Real-time updates với WebSocket
5. Upload ảnh phòng
6. Export báo cáo PDF/Excel
7. Push notifications cho sự cố mới
8. Multi-property support (nhiều nhà trọ)

## 🔗 Dependencies

```yaml
provider: ^6.1.2      # State management
intl: ^0.19.0         # Formatting
```

## ✨ Hoàn thành

- ✅ 3 Models
- ✅ 1 Provider với mock data đầy đủ
- ✅ 6 Pages (Main + 5 features + Room Management)
- ✅ Navigation với 5 tabs
- ✅ CRUD operations cho tất cả entities
- ✅ Responsive UI với Material Design 3
- ✅ Error handling và loading states
- ✅ Integrated vào app routing
