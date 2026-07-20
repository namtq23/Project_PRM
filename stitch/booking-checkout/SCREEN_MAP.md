# SCREEN_MAP.md --- Booking & Checkout Module

Bản đồ này tóm tắt các màn hình, luồng điều hướng và thông số kỹ thuật cho module Booking & Checkout dựa trên tài nguyên từ Stitch.

## 1. Danh sách màn hình & Tài nguyên Stitch

| Tên màn hình | Screen ID | Ảnh (Screenshot) | HTML Tham chiếu |
| :--- | :--- | :--- | :--- |
| **Chi tiết Tour** | `bef21697827944e38141dda40ed702bb` | [PNG](./dependencies/tour-detail/reference.png) | [HTML](./dependencies/tour-detail/reference.html) |
| **Thông tin người đi** | `cbf7dff5293b411a8bf2e64ac55fb768` | [PNG](./traveler-info/reference.png) | [HTML](./traveler-info/reference.html) |
| **Phương thức thanh toán** | `60a5c4e78d2949f9847a844bb985b8dd` | [PNG](./payment-method/reference.png) | [HTML](./payment-method/reference.html) |
| **Thanh toán & Xác nhận** | `7300de2ca5df4a70b5000990f2d886b1` | [PNG](./checkout-confirmation/reference.png) | [HTML](./checkout-confirmation/reference.html) |
| **Xác nhận đặt tour thành công** | `79c16c3337a740daa96eebd02bdc4210` | [PNG](./booking-success/reference.png) | [HTML](./booking-success/reference.html) |
| **Đặt tour thất bại** | `239409ce15714625b5fb941ad8b2fa3f` | [PNG](./dependencies/booking-failed/reference.png) | [HTML](./dependencies/booking-failed/reference.html) |
| **Lịch sử đặt chỗ** | `1c8b3aef65894ca88f710c849f6548ee` | [PNG](./dependencies/booking-history/reference.png) | [HTML](./dependencies/booking-history/reference.html) |
| **Chi tiết đơn hàng** | `78cfcdcb5e0a4a12a6853528d98b83c2` | [PNG](./dependencies/booking-detail/reference.png) | [HTML](./dependencies/booking-detail/reference.html) |
| **Gửi đánh giá tour** | `f6378ab248194e2082d3da261e8fc28f` | [PNG](./review-tour/reference.png) | [HTML](./review-tour/reference.html) |

---

## 2. Luồng điều hướng (Navigation Flow)

### Luồng chính (Happy Path):
1. **Chi tiết Tour** → Bấm "Đặt ngay"
2. **Thông tin người đi** → Nhập khách/ngày → Bấm "Tiếp tục"
3. **Phương thức thanh toán** → Chọn PTTT → Bấm "Tiếp tục"
4. **Thanh toán & Xác nhận** → Nhập mã giảm giá → Bấm "Xác nhận thanh toán"
5. **Xác nhận đặt tour thành công** → Xem mã đơn hàng → Bấm "Về đơn hàng của tôi"
6. **Lịch sử đặt chỗ** → Chọn đơn hàng vừa đặt
7. **Chi tiết đơn hàng** → Sau chuyến đi → Bấm "Gửi đánh giá"
8. **Gửi đánh giá tour** → Chọn sao/nhận xét → Hoàn tất.

### Luồng lỗi (Error Flow):
- **Thanh toán & Xác nhận** → Xử lý thất bại → **Đặt tour thất bại** → Bấm "Thử lại" hoặc "Chọn PTTT khác".

---

## 3. Thông số kỹ thuật chi tiết

### 3.1. Thông tin người đi (Traveler Info)
- **Input:** `tourId`, `userId` (từ session).
- **Output:** `bookingDate`, `adultCount`, `childCount`, `contactName`, `contactPhone`, `specialNotes`.
- **State Riverpod:** `bookingViewModelProvider` (lưu state tạm thời).
- **Validation:** 
    - Tên liên hệ không trống.
    - SĐT đúng định dạng.
    - Số khách ít nhất là 1.
    - Ngày khởi hành phải được chọn.

### 3.2. Phương thức thanh toán (Payment Method)
- **Input:** Tổng tiền từ bước trước.
- **Output:** `paymentMethod` (String).
- **Các nút:** Radio list chọn PTTT, nút "Tiếp tục".
- **State Riverpod:** Cập nhật `paymentMethod` vào `bookingViewModelProvider`.

### 3.3. Thanh toán & Xác nhận (Checkout Confirmation)
- **Input:** Đầy đủ dữ liệu booking tạm thời.
- **Output:** `promoCode`, `totalAmount` sau giảm giá.
- **API dự kiến:** `bookingRepository.createBooking(bookingModel)`.
- **Validation:** Kiểm tra mã giảm giá (nếu có) qua API.
- **Trạng thái:** Hiển thị loading overlay khi đang gọi API thanh toán.

### 3.4. Xác nhận đặt tour thành công (Booking Success)
- **Input:** `bookingModel` vừa tạo thành công (lấy `confirmationCode`).
- **Nút bấm:** "Go to My Bookings" (Route: `/bookings`), "Copy Code".
- **API dự kiến:** Không (chỉ hiển thị dữ liệu từ state thành công).

### 3.5. Gửi đánh giá tour (Review Tour)
- **Input:** `bookingId`, `tourId`, `userId`.
- **Output:** `rating` (1-5), `comment`.
- **API dự kiến:** `reviewRepository.submitReview(reviewModel)`.
- **Validation:** Rating phải >= 1.

---

## 4. Đối chiếu với Use Case & GAP Analysis

| Phần | Trạng thái trong Stitch | Cần bổ sung khi code Flutter |
| :--- | :--- | :--- |
| **Tính toán tiền tạm tính** | Đã có UI Price Breakdown | Cần logic nhân số lượng khách x giá tour trong ViewModel. |
| **Chọn ngày khởi hành** | Có UI Calendar | Cần tích hợp `showDatePicker` hoặc widget lịch tùy chỉnh. |
| **Mã giảm giá** | Có UI TextField | Cần logic kiểm tra mã giảm giá (Mock API hoặc Firestore). |
| **Mã xác nhận (Reference)** | Có UI hiển thị | Cần logic generate mã ngẫu nhiên hoặc lấy từ Backend sau khi Save thành công. |
| **Offline Support** | Chưa có (Stitch chỉ làm UI) | Cần tích hợp `DatabaseService` (SQLite) để cache đơn hàng. |
| **Loading States** | Có Skeleton tham khảo | Cần triển khai `shimmer` package bám theo layout của Stitch. |

---

## 5. Danh sách Route (Dự kiến)
- `/tours/:id` -> Tour Detail
- `/booking/info` -> Traveler Info
- `/booking/payment` -> Payment Method
- `/booking/checkout` -> Checkout Confirmation
- `/booking/success` -> Booking Success
- `/booking/failed` -> Booking Failed
- `/bookings` -> Booking History
- `/bookings/:id` -> Booking Detail
- `/bookings/:id/review` -> Review Tour
