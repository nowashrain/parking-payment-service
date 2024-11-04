import sqlalchemy, logging
from sqlalchemy.orm import sessionmaker
from models.payment import Base  # SQLAlchemy Base import


# 파일에서 DB 정보를 읽어오기
def read_secret_file(file_path):
    with open(file_path, 'r') as file:
        return file.read().strip()

db_user = read_secret_file('/etc/secrets/DB_USER')
db_password = read_secret_file('/etc/secrets/DB_PASSWORD')
db_host = read_secret_file('/etc/secrets/DB_HOST')
db_port = read_secret_file('/etc/secrets/DB_PORT')
db_name = read_secret_file('/etc/secrets/DB_NAME')


# DB URL 구성
db_url = f"mysql+pymysql://{db_user}:{db_password}@{db_host}:{db_port}/{db_name}"

engine = sqlalchemy.create_engine(db_url, echo=True)
SessionLocal = sessionmaker(autocommit=False,
                            autoflush=False, bind=engine)

def create_tables():
    try:
        Base.metadata.create_all(engine)  # Base 클래스에서 정의된 모든 테이블을 생성
        logging.info("Tables created successfully.")
    except Exception as e:
        logging.error("Error creating tables: %s", e)

def get_db():
    with SessionLocal() as db:
        yield db