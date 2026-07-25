from sqlalchemy import Column, ForeignKey, Integer
from sqlalchemy.orm import relationship

from app.database.database import Base


class TeamMember(Base):
    __tablename__ = "team_members"

    id = Column(
        Integer,
        primary_key=True,
        index=True,
    )

    user_id = Column(
        Integer,
        ForeignKey(
            "users.id",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    team_id = Column(
        Integer,
        ForeignKey(
            "teams.id",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    user = relationship(
        "User",
    )

    team = relationship(
        "Team",
    )