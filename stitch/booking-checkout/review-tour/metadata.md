# Metadata: Gửi đánh giá tour

- **Tên màn hình:** Gửi đánh giá tour
- **Screen ID:** f6378ab248194e2082d3da261e8fc28f
- **Use case tương ứng:** Review Tour
- **Mục đích:** Thu thập phản hồi và xếp hạng từ khách hàng sau chuyến đi.
- **Màn hình trước:** Chi tiết đơn hàng
- **Màn hình tiếp theo:** Chi tiết Tour

## Component chính
- Star rating bar (1-5)\n- Text area for comment\n- Submit button

## Dữ liệu cần hiển thị
- Tên tour\n- Ảnh tour

## Action của người dùng
- Chọn số sao\n- Viết nhận xét\n- Gửi đánh giá

## Trạng thái (Loading, Success, Error)
- **Loading:** Skeleton loading bám theo cấu trúc card/form.
- **Success:** Chuyển sang màn hình tiếp theo hoặc hiển thị toast/dialog thành công.
- **Error:** Inline validation cho form hoặc thông báo lỗi cụ thể (ví dụ: mã giảm giá không lệ phí).
