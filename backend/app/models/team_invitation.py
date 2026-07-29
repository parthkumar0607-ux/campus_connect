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


class TeamInvitation(Base):
    __tablename__ = "team_invitations"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    team_id = Column(
        Integer,
        ForeignKey("teams.id"),
        nullable=False,
    )

    sender_id = Column(
        Integer,
        ForeignKey("users.id"),
        nullable=False,
    )

    receiver_id = Column(
        Integer,
        ForeignKey("users.id"),
        nullable=False,
    )

    status = Column(
        String(20),
        default="pending",
    )

    created_at = Column(
        DateTime,
        default=datetime.utcnow,
    )

    team = relationship("Team")

    sender = relationship(
        "User",
        foreign_keys=[sender_id],
    )

    receiver = relationship(
        "User",
        foreign_keys=[receiver_id],
    )