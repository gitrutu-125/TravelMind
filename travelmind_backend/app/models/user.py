
from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    DateTime,
    func
)
from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)

    name = Column(String(100), nullable=False)

    email = Column(
        String(255),
        unique=True,
        index=True,
        nullable=False
    )

    # Password hash is nullable to support Google-only accounts.
    hashed_password = Column(String(255), nullable=True)

    # Google account identifier, not the user's email.
    google_sub = Column(String(255), unique=True, nullable=True)

    auth_provider = Column(
        String(20),
        nullable=False,
        default="email"
    )

    is_active = Column(Boolean, default=True, nullable=False)

    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False
    )
