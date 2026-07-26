@staticmethod
def get_team_status(
    db: Session,
    team_id: int,
    current_user: User,
):
    team = TeamRepository.get_team_by_id(
        db,
        team_id,
    )

    if not team:
        raise HTTPException(
            status_code=404,
            detail="Team not found",
        )

    member = TeamRepository.is_member(
        db,
        team_id,
        current_user.id,
    )

    return {
        "joined": member is not None,
        "is_creator": team.created_by == current_user.id,
    }