# 📚 OmnimerEDI Source

> Đây là repo **OmnimerEDI** chứa toàn bộ mã nguồn **Frontend (Apps)** và **Backend Services**, sẵn sàng mở rộng thêm **AI Server** và hệ thống CI/CD.

---

## 📁 **Cấu trúc thư mục**

omnimeredi-source/
│
├── apps/ # Chứa các ứng dụng chính (Client)
│ ├── mobile/ # Source Flutter app cho iOS & Android
│ ├── web/ # Source Flutter Web (hoặc Next.js nếu cần)
│
├── services/ # Chứa các Backend Services
│ ├── api/ # Node.js/Express.js API chính (Business Logic, Auth, DB)
│ ├── ai/ # AI Server riêng (Python FastAPI hoặc Node)
│ │ ├── models/ # Mô hình Machine Learning đã train
│ │ ├── src/ # Source code API phục vụ AI
│ │ ├── requirements.txt # Python dependencies (nếu dùng Python)
│ │ ├── app.py # Entry point (FastAPI app)
│
├── configs/ # Các file cấu hình, template env, CI/CD, proxy server
│ ├── .env.example
│ ├── docker-compose.yml
│ ├── nginx.conf
│ └── README.md
│
├── scripts/ # Các script hỗ trợ build, deploy, migrate DB, seed data
│ ├── deploy.sh
│ ├── seed.js
│ └── ...
│
├── docs/ # Tài liệu kỹ thuật: Swagger, Architecture Diagram,...
│ ├── API-spec.md
│ ├── ARCHITECTURE.md
│ └── ...
│
├── .gitignore # Bỏ qua node_modules, build, env, cache,...
├── README.md # File này
└── LICENSE # (Nếu public)

---

## ✨ **Mục tiêu tổ chức**

- 🗂 **apps/**: Tách riêng **Frontend Mobile & Web**, giúp dễ maintain và build CI/CD riêng.
- ⚙️ **services/**: Chia nhỏ Microservices:
  - `api/`: Chứa **Node.js/Express.js**, business logic, auth, DB connection.
  - `ai/`: Tách riêng server AI (FastAPI, Tensorflow Serving,...).
- ⚡ **configs/**: Tập trung các file cấu hình CI/CD, docker, reverse proxy.
- 📜 **docs/**: Ghi chú kỹ thuật, swagger, sơ đồ kiến trúc để dễ onboard dev mới.
- 🔧 **scripts/**: Các script tiện ích build/deploy, tự động seed DB,...

---

## ✅ **Hướng dẫn triển khai**

- **Clone Repo**
  ```bash
  git clone https://github.com/your-org/omnimeredi-source.git
  ```

## ** Cài đặt front-end**

cd apps/mobile
flutter pub get
flutter run

cd services/api
npm install
npm run dev

cd services/ai
python -m venv venv
source venv/bin/activate # or venv\Scripts\activate (Windows)
pip install -r requirements.txt
uvicorn app:app --reload
