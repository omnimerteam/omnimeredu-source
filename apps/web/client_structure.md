# Source Structure – Client

Cấu trúc thư mục của `src/` trong dự án frontend được tổ chức theo kiểu **modular và component-based**. Dưới đây là giải thích chi tiết từng phần.

---

## 1. `assets/`

Chứa các tài nguyên tĩnh dùng trong ứng dụng:

- Hình ảnh, icon, logo
- Fonts, animations, GIF, v.v.

---

## 2. `components/`

Chứa các **React components tái sử dụng được**, chia thành nhiều module nhỏ:

- **charts/** – Components để hiển thị các biểu đồ, dashboard charts
- **common/** – Các component chung, được dùng ở nhiều nơi (Button, Modal, Loader, etc.)
- **ecommerce/** – Components phục vụ phần thương mại điện tử (sản phẩm, giỏ hàng…)
- **Form/** – Các component form riêng biệt, input, select, validate…
- **header/** – Components header cho các layout khác nhau
- **tables/** – Components hiển thị bảng dữ liệu (data table)
- **ui/** – Components UI cơ bản, thường là các building blocks (Card, Badge, Tag…)

---

## 3. `configs/`

Chứa các file cấu hình toàn cục:

- API endpoints, constants
- Theme configuration
- App settings khác

---

## 4. `contexts/`

Chứa các **React Context** dùng để quản lý state toàn cục hoặc quyền truy cập:

- Ví dụ: `RequireAdmin.tsx` kiểm tra quyền admin trước khi render component/route

---

## 5. `hooks/`

Chứa các **custom hooks** tái sử dụng:

- Quản lý state, API calls, logic chung
- Ví dụ: `useFetch`, `useForm`, `useAuth`…

---

## 6. `layouts/`

Chứa các **layout chính** của ứng dụng:

- `AdminLayout.tsx` – Layout dành cho admin/dashboard
- `UserLayout.tsx` – Layout dành cho người dùng thông thường

---

## 7. `models/`

Chứa các **TypeScript type/interface hoặc schema** dùng cho dữ liệu:

- Định nghĩa structure của các entity (User, Class, Attendance…)

---

## 8. `pages/`

Chứa các **React pages** theo route:

- `auth/` – Trang liên quan đến authentication
- `writting/` – Trang viết bài hoặc quản lý nội dung

```bash
 src/
└─ pages/
   ├─ auth/
   │  ├─ LoginPage/
   │  │  ├─ LoginPage.tsx          # Component page chính
   │  │  ├─ components/            # Các component con của page này
   │  │  │  ├─ LoginForm.tsx
   │  │  │  └─ LoginHeader.tsx
   │  │  └─ index.ts               # xuất mặc định LoginPage
   │  └─ RegisterPage/
   │     ├─ RegisterPage.tsx
   │     ├─ components/
   │     │  ├─ RegisterForm.tsx
   │     │  └─ RegisterHeader.tsx
   │     └─ index.ts
   │
   └─ writing/
      ├─ PostEditorPage/
      │  ├─ PostEditorPage.tsx
      │  ├─ components/
      │  │  ├─ EditorToolbar.tsx
      │  │  └─ PostForm.tsx
      │  └─ index.ts
      └─ PostListPage/
         ├─ PostListPage.tsx
         ├─ components/
         │  ├─ PostItem.tsx
         │  └─ FilterBar.tsx
         └─ index.ts


```

---

## 9. `redux/`

Chứa các **Redux slice và store**:

- Quản lý state toàn cục (user, theme, dashboard…)
- Thường gồm `store.ts` và các slice riêng

---

## 10. `services/`

Chứa các **API service**:

- Gọi API backend
- Tách biệt logic API khỏi component

---

## 11. `styles/`

Chứa các **file CSS/SCSS hoặc Tailwind config**:

- Global styles, theme overrides, mixins…

---

## 12. `utils/`

Chứa các **hàm helper** dùng chung trong toàn ứng dụng:

- Format date, validate data, helper functions khác

---

## 13. Các file gốc

- `App.tsx` – Root component của React app
- `main.tsx` – Entry point, render React app vào DOM
- `custom.d.ts` – TypeScript custom types hoặc module declarations
- `README.md` – File hướng dẫn này

---

### 💡 Ghi chú

- Cấu trúc này giúp **dễ bảo trì**, mỗi thư mục có trách nhiệm riêng.
- Component, layout, page được tách rõ để **tái sử dụng** và **quản lý quyền/route** dễ dàng.
- Redux + Context kết hợp để quản lý state toàn cục và quyền truy cập.
