# ==========================================
# Stage 1: Builder
# ==========================================
FROM node:20-slim AS builder

WORKDIR /app

COPY shared-lib/package*.json ./shared-lib/
COPY shared-lib/tsconfig*.json ./shared-lib/

WORKDIR /app/shared-lib
RUN npm install --include=dev

COPY shared-lib/ .

RUN npm run build 

WORKDIR /app/user_service
COPY user_service/package*.json ./
RUN npm install
COPY user_service/ .
RUN npm run build

# ==========================================
# Stage 2: Runner (Production)
# ==========================================
FROM node:20-slim

WORKDIR /app

# 1. Setup Shared Lib trước (Để User Service link tới được)
# Dùng package*.json để copy cả package-lock.json (quan trọng!)
COPY --from=builder /app/shared-lib/package*.json ./shared-lib/
COPY --from=builder /app/shared-lib/dist ./shared-lib/dist

# Cài dependencies cho shared-lib
WORKDIR /app/shared-lib
RUN npm install --omit=dev

# 2. Setup User Service
WORKDIR /app/user_service

# Copy package và lock file từ builder sang
COPY --from=builder /app/user_service/package*.json ./
# Copy code đã build (dist)
COPY --from=builder /app/user_service/dist ./dist

# 3. Cài dependencies cho User Service
# Lúc này nó sẽ link tới ../shared-lib mà bạn đã setup ở bước 1
RUN npm install --omit=dev

# 4. Start
ENV NODE_ENV=production
EXPOSE 3001
CMD ["npm", "start"]