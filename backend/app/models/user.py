from sqlalchemy import Column, Integer, String

from app.database.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    name = Column(
        String(100),
        nullable=False,
    )

    email = Column(
        String(255),
        unique=True,
        nullable=False,
        index=True,
    )

    password = Column(
        String(255),
        nullable=False,
    )

    college = Column(
        String(150),
    )

    course = Column(
        String(100),
    )

    year = Column(
        String(20),
    )

    bio = Column(
        String(500),
        default="",
    )

    skills = Column(
        String(500),
        default="",
    )

    profile_image = Column(
        String(500),
        default="",
    )