FROM python:3.10.15-alpine3.20

# 필수 패키지 설치 (gcc, g++, libc-dev, gfortran, lapack-dev 등)
RUN apk add --no-cache \
    gcc \
    g++ \
    libc-dev \
    gfortran \
    libgfortran \
    libstdc++ \
    lapack-dev \
    libexecinfo-dev \
    py3-setuptools \
    py3-wheel \
    musl-dev \
    linux-headers \
    libffi-dev \
    openssl-dev \
    bash

WORKDIR /app

# requirements.txt를 복사하고 종속성 설치
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 프로젝트 파일 복사
COPY main.py .
COPY models ./models
COPY schema ./schema
COPY routes ./routes
COPY service ./service

# 데이터베이스 테이블 생성
RUN python -c "from service.database import create_tables; create_tables()"

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001", "--reload"]


