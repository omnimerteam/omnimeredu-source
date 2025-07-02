omnimeredi-source/
│
├── apps/ # Chứa các ứng dụng chính (Frontend)
│ ├── mobile/ # Flutter app cho iOS, Android
│ │ └── ...
│ │
│ ├── web/ # Flutter Web (hoặc Next.js)
│ │ └── ...
│
├── services/ # Chứa các backend service
│ ├── api/ # Backend Node.js / Express API chính
│ ├── ai/ # AI Server riêng (Python FastAPI, Node, ...)
│ │ ├── models/ # Mô hình ML đã train
│ │ ├── src/ # API phục vụ AI
│ │ ├── requirements.txt # Nếu Python
│ │ ├── app.py
│ │ └── ...
│
├── configs/ # File cấu hình CI/CD, env template
│ ├── .env.example
│ ├── docker-compose.yml
│ ├── nginx.conf (nếu deploy nginx proxy)
│ └── README.md
│
├── scripts/ # Script hỗ trợ build, deploy, migrate DB, seed data
│ ├── deploy.sh
│ ├── seed.js
│ └── ...
│
├── docs/ # Tài liệu kỹ thuật, swagger, diagram kiến trúc
│ ├── API-spec.md
│ ├── ARCHITECTURE.md
│ └── ...
│
├── .gitignore
├── README.md # Giải thích toàn bộ cấu trúc
└── LICENSE (nếu public)
