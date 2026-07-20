# Metadata: Phương thức thanh toán

- **Tên màn hình:** Phương thức thanh toán
- **Screen ID:** 60a5c4e78d2949f9847a844bb985b8dd
- **Use case tương ứng:** Checkout
- **Mục đích:** Chọn cách thức thanh toán đơn hàng.
- **Màn hình trước:** Thông tin người đi
- **Màn hình tiếp theo:** Thanh toán & Xác nhận

## Component chính
- Danh sách PTTT (Thẻ, Ví, Chuyển khoản)\n- Tóm tắt đơn hàng ngắn gọn

## Dữ liệu cần hiển thị
- Tổng số tiền cần thanh toán

## Action của người dùng
- Chọn một phương thức thanh toán\n- Nhấn Tiếp tục

## Trạng thái (Loading, Success, Error)
- **Loading:** Skeleton loading bám theo cấu trúc card/form.
- **Success:** Chuyển sang màn hình tiếp theo hoặc hiển thị toast/dialog thành công.
- **Error:** Inline validation cho form hoặc thông báo lỗi cụ thể (ví dụ: mã giảm giá không lệ phí).
