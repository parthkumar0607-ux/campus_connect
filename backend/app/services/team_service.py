@staticmethod
def leave_team(
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

    if team.created_by == current_user.id:
        raise HTTPException(
            status_code=400,
            detail="Team creator cannot leave. Delete the team instead.",
        )

    member = TeamRepository.is_member(
        db,
        team_id,
        current_user.id,
    )

    if not member:
        raise HTTPException(
            status_code=400,
            detail="You are not a member of this team.",
        )

    TeamRepository.remove_member(
        db,
        member,
    )

    team.current_members -= 1

    TeamRepository.commit(db)

    return {
        "message": "Left team successfully"
    }