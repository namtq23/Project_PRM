# Metadata: Thông tin người đi

- **Tên màn hình:** Thông tin người đi
- **Screen ID:** cbf7dff5293b411a8bf2e64ac55fb768
- **Use case tương ứng:** Input Booking Info
- **Mục đích:** Người dùng nhập thông tin đại diện, số lượng hành khách và ghi chú đặc biệt.
- **Màn hình trước:** Tour Detail
- **Màn hình tiếp theo:** Phương thức thanh toán

## Component chính
- Form nhập liệu (Họ tên, SĐT)\n- Stepper/Quantity selector cho khách\n- Date picker chọn ngày\n- Nút Tiếp tục

## Dữ liệu cần hiển thị
- Tên tour\n- Giá cơ bản\n- Danh sách ngày khả dụng

## Action của người dùng
- Thay đổi số lượng khách\n- Nhập thông tin liên hệ\n- Chọn ngày khởi hành

## Trạng thái (Loading, Success, Error)
- **Loading:** Skeleton loading bám theo cấu trúc card/form.
- **Success:** Chuyển sang màn hình tiếp theo hoặc hiển thị toast/dialog thành công.
- **Error:** Inline validation cho form hoặc thông báo lỗi cụ thể (ví dụ: mã giảm giá không lệ phí).
