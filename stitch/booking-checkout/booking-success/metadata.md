# Metadata: Xác nhận đặt tour thành công

- **Tên màn hình:** Xác nhận đặt tour thành công
- **Screen ID:** 79c16c3337a740daa96eebd02bdc4210
- **Use case tương ứng:** View Booking Result
- **Mục đích:** Thông báo kết quả giao dịch và cung cấp mã đặt chỗ.
- **Màn hình trước:** Thanh toán & Xác nhận
- **Màn hình tiếp theo:** Lịch sử đặt chỗ

## Component chính
- Success icon/animation\n- Booking Reference Code (Copyable)\n- Instruction text\n- Primary button (Go to Bookings)

## Dữ liệu cần hiển thị
- Mã xác nhận đặt chỗ\n- Thông tin tóm tắt tour

## Action của người dùng
- Copy mã\n- Quay về danh sách đơn hàng

## Trạng thái (Loading, Success, Error)
- **Loading:** Skeleton loading bám theo cấu trúc card/form.
- **Success:** Chuyển sang màn hình tiếp theo hoặc hiển thị toast/dialog thành công.
- **Error:** Inline validation cho form hoặc thông báo lỗi cụ thể (ví dụ: mã giảm giá không lệ phí).
