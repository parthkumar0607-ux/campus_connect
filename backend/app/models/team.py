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


class Team(Base):
    __tablename__ = "teams"

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

    tech_stack = Column(
        String,
        nullable=False,
    )

    max_members = Column(
        Integer,
        nullable=False,
    )

    current_members = Column(
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

    creator = relationship("User")

    members = relationship(
        "TeamMember",
        cascade="all, delete-orphan",
    )

    invitations = relationship(
        "TeamInvitation",
        cascade="all, delete-orphan",
    )