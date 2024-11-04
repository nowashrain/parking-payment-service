# Alpine 3.20 기반 Python 이미지
FROM python:3.10-alpine3.20

# 빌드 도구와 필요한 라이브러리 설치
RUN apk update && apk add --no-cache \
    build-base \
    gcc \
    g++ \
    lapack-dev \
    blas-dev \
    libffi-dev \
    openssl-dev \
    && rm -rf /var/cache/apk/*

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 복사 및 종속성 설치
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && apk del build-base gcc g++  # 불필요한 빌드 패키지 삭제

# 프로젝트 파일 복사
COPY main.py .
COPY models ./models
COPY schema ./schema
COPY routes ./routes
COPY service ./service

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001", "--reload"]
