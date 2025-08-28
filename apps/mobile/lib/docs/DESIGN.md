# 🎨 Bảng màu dự án

## 1. Màu chính (Primary Palette)

- **Primary Blue**: `#006a9c`  
  → Màu chủ đạo, dùng cho brand, header, text highlight.

- **Blue**: `#1E88E5`  
  → Dùng cho button chính, link, icon quan trọng.

- **Light Blue**: `#4A90E2`  
  → Dùng cho hover, button phụ, background nhấn nhẹ.

- **Extra Light Blue**: `#D0E6FF`  
  → Dùng làm nền section, background phụ, tạo cảm giác sáng sủa.

---

## 2. Màu nền và chữ

- **Background White**: `#FFFFFF`  
  → Nền chính, đảm bảo bố cục sáng và dễ đọc.

- **Dark**: `#002134`  
  → Màu chữ chính (heading, paragraph), border, icon.

---

## 3. Màu nhấn (Accent)

- **Red**: `#b22e33`  
  → CTA button (Call to Action), cảnh báo, highlight quan trọng.

- **Dark Red**: `#82060e`  
  → Trạng thái cảnh báo đậm, hover khi nhấn nút đỏ.

---

## 4. Nguyên tắc sử dụng

- **Primary (#006a9c)** luôn là màu gắn với thương hiệu → xuất hiện xuyên suốt app.
- **Blue (#1E88E5)** làm màu hành động (CTA, button chính).
- **Red (#b22e33)** chỉ dùng khi cần tạo sự chú ý đặc biệt.
- **Nền trắng (#FFFFFF)** giữ app sạch sẽ, dễ đọc.
- **Dark (#002134)** dùng cho text chính, tránh dùng màu xám nhạt gây khó đọc.
- **Phối màu:** Ưu tiên dùng tông xanh lam + nền sáng, đỏ chỉ làm điểm nhấn.

---

✅ Với bảng màu này + font ở trên, team có thể thống nhất khi làm UI (Flutter, Web, hoặc bất kỳ nền tảng nào).

# 📖 Hướng dẫn sử dụng Font chữ trong dự án

## 🎯 Mục đích

Việc sử dụng font chữ thống nhất giúp:

- Đảm bảo **trải nghiệm người dùng** mượt mà, dễ đọc.
- Giữ **tính nhất quán** trong giao diện ứng dụng.
- Thể hiện đúng **thương hiệu** và **ngữ điệu** của sản phẩm.

---

## 🖋️ Font chính trong dự án

### 1. **Inter**

- **Dùng cho**: Nội dung chính, văn bản dài, body text.
- **Ưu điểm**:
  - Hiện đại, dễ đọc trên mọi màn hình.
  - Thích hợp cho cả tiếng Việt và tiếng Anh.
- **Ứng dụng**: Mặc định cho hầu hết các màn hình, đặc biệt là mô tả, label, paragraph.

### 2. **Nunito**

- **Dùng cho**: Tiêu đề phụ, button, nhấn mạnh trong UI.
- **Ưu điểm**:
  - Bo tròn nhẹ, tạo cảm giác thân thiện và dễ gần.
  - Hợp với app giáo dục, cộng đồng, trẻ em.
- **Ứng dụng**:
  - Sub-heading, caption, CTA button (Call to Action).

### 3. **Playfair Display**

- **Dùng cho**: Tiêu đề lớn, highlight, branding.
- **Ưu điểm**:
  - Font serif sang trọng, tạo điểm nhấn.
  - Dùng để phân cấp thị giác trong màn hình.
- **Ứng dụng**:
  - Title chính trên màn hình landing, slogan, quote.

---

## 🧩 Nguyên tắc sử dụng

- **Không dùng quá nhiều font** → chỉ 2–3 font chính cho toàn bộ app.
- **Nhất quán**: Giữ định dạng giống nhau cho cùng loại text (vd: toàn bộ body text đều dùng Inter 14px).
- **Phân cấp thị giác rõ ràng**:
  - Tiêu đề lớn: Playfair Display
  - Tiêu đề nhỏ & button: Nunito
  - Nội dung chính: Inter
- **Đảm bảo đa ngôn ngữ**: Font đã được kiểm tra hiển thị tốt với tiếng Việt.

---

## 🔧 Triển khai trong Flutter

Trong file `pubspec.yaml`:

```yaml
fonts:
  - family: Inter
    fonts:
      - asset: assets/fonts/Inter-Italic-VariableFont_opsz,wght.ttf
      - asset: assets/fonts/Inter-VariableFont_opsz,wght.ttf
  - family: Nunito
    fonts:
      - asset: assets/fonts/Nunito-Italic-VariableFont_wght.ttf
      - asset: assets/fonts/Nunito-VariableFont_wght.ttf
  - family: PlayfairDisplay
    fonts:
      - asset: assets/fonts/PlayfairDisplay-VariableFont_wght.ttf
      - asset: assets/fonts/PlayfairDisplay-Italic-VariableFont_wght.ttf
```
