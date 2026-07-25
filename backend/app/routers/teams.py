from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.team import Team
from app.models.team_member import TeamMember
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

    creator_member = TeamMember(
        user_id=current_user.id,
        team_id=new_team.id,
    )

    db.add(creator_member)
    db.commit()

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


@router.post("/{team_id}/join")
def join_team(
    team_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    team = (
        db.query(Team)
        .filter(Team.id == team_id)
        .first()
    )

    if not team:
        raise HTTPException(
            status_code=404,
            detail="Team not found",
        )

    existing = (
        db.query(TeamMember)
        .filter(
            TeamMember.team_id == team_id,
            TeamMember.user_id == current_user.id,
        )
        .first()
    )

    if existing:
        raise HTTPException(
            status_code=400,
            detail="You are already a member of this team",
        )

    if team.current_members >= team.max_members:
        raise HTTPException(
            status_code=400,
            detail="Team is full",
        )

    member = TeamMember(
        user_id=current_user.id,
        team_id=team.id,
    )

    db.add(member)

    team.current_members += 1

    db.commit()

    return {
        "message": "Joined team successfully"
    }