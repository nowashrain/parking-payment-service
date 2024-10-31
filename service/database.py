import sqlalchemy
from sqlalchemy.orm import sessionmaker
from models.payment import Base  # SQLAlchemy Base import


db_url = 'sqlite:///../parkingdb.db'
# Docker Compose에서 정의된 환경 변수로 MariaDB 연결 설정
# DATABASE_URL = "mysql+pymysql://wpuser:abc123!!@mariadb:3306/wordpress

engine = sqlalchemy.create_engine(db_url, echo=True)
SessionLocal = sessionmaker(autocommit=False,
                            autoflush=False, bind=engine)

def create_tables():
    Base.metadata.create_all(engine)

def get_db():
    with SessionLocal() as db:
        yield db