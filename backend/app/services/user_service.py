from sqlalchemy.orm import Session

from app.models.user import User


class UserService:

    @staticmethod
    def get_profile(
        current_user: User,
    ):
        return current_user

    @staticmethod
    def update_profile(
        db: Session,
        current_user: User,
        user_data,
    ):
        current_user.name = user_data.name
        current_user.college = user_data.college
        current_user.course = user_data.course
        current_user.year = user_data.year

        db.commit()
        db.refresh(current_user)

        return current_user