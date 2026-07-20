# Metadata: Thanh toán & Xác nhận

- **Tên màn hình:** Thanh toán & Xác nhận
- **Screen ID:** 7300de2ca5df4a70b5000990f2d886b1
- **Use case tương ứng:** Checkout
- **Mục đích:** Kiểm tra lại toàn bộ thông tin và áp dụng mã giảm giá trước khi thanh toán.
- **Màn hình trước:** Phương thức thanh toán
- **Màn hình tiếp theo:** Xác nhận đặt tour thành công

## Component chính
- Order Summary card\n- Promo Code input field\n- Price breakdown\n- Confirm button

## Dữ liệu cần hiển thị
- Thông tin tour, ngày đi, số khách\n- Chi tiết giá (Gốc, Giảm giá, Tổng cộng)

## Action của người dùng
- Nhập mã giảm giá\n- Nhấn Xác nhận thanh toán

## Trạng thái (Loading, Success, Error)
- **Loading:** Skeleton loading bám theo cấu trúc card/form.
- **Success:** Chuyển sang màn hình tiếp theo hoặc hiển thị toast/dialog thành công.
- **Error:** Inline validation cho form hoặc thông báo lỗi cụ thể (ví dụ: mã giảm giá không lệ phí).
