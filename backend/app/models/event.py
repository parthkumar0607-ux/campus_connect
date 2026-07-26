from datetime import datetime

from sqlalchemy import (
    Column,
    DateTime,
    ForeignKey,
    Integer,
    String,
)
from sqlalchemy.orm import relationship

from app.database.database import Base


class Event(Base):
    __tablename__ = "events"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    title = Column(
        String,
        nullable=False,
    )

    description = Column(
        String,
        nullable=False,
    )

    venue = Column(
        String,
        nullable=False,
    )

    date_time = Column(
        DateTime,
        nullable=False,
    )

    max_attendees = Column(
        Integer,
        nullable=False,
    )

    current_attendees = Column(
        Integer,
        default=1,
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    created_by = Column(
        Integer,
        ForeignKey("users.id"),
    )

    creator = relationship(
        "User",
    )

    attendees = relationship(
        "EventAttendee",
        cascade="all, delete-orphan",
    )