from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.team import Team
from app.models.user import User
from app.schemas.team import (
    TeamCreate,
    TeamResponse,
)

router = APIRouter(
    prefix="/teams",
    tags=["Teams"],
)


@router.post(
    "",
    response_model=TeamResponse,
)
def create_team(
    team: TeamCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    new_team = Team(
        title=team.title,
        description=team.description,
        tech_stack=team.tech_stack,
        max_members=team.max_members,
        current_members=1,
        created_by=current_user.id,
    )

    db.add(new_team)
    db.commit()
    db.refresh(new_team)

    return new_team


@router.get(
    "",
    response_model=list[TeamResponse],
)
def get_teams(
    db: Session = Depends(get_db),
):
    return (
        db.query(Team)
        .order_by(Team.created_at.desc())
        .all()
    )