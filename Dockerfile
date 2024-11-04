# Debian 기반 이미지로 변경 (안정성 확보)
FROM python:3.10-slim

# 빌드 도구와 scikit-learn에 필요한 라이브러리 설치
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    liblapack-dev \
    libblas-dev \
    gfortran \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# 작업 디렉토리 설정
WORKDIR /app

# requirements.txt 복사 및 종속성 설치
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
