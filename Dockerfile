# Alpine 3.20 기반 Python 이미지
FROM python:3.10.15-alpine3.20


# 작업 디렉토리 설정
WORKDIR /app

# 빌드 도구와 필요한 라이브러리 설치
RUN apk update && apk add --no-cache \
    build-base \
    gfortran \
    lapack-dev \
    libffi-dev \
    libstdc++

# requirements.txt 파일 복사 및 의존성 설치
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# 프로젝트 파일 복사
COPY main.py .
COPY models ./models
COPY schema ./schema
COPY routes ./routes
COPY service ./service

# FastAPI 서버 실행
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001", "--reload"]
