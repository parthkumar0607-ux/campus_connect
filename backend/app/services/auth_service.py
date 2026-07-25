from fastapi import HTTPException
from sqlalchemy.orm import Session

from app.core.security import (
    create_access_token,
    hash_password,
    verify_password,
)
from app.models.user import User
from app.repositories.user_repository import UserRepository
from app.schemas.auth import Token


class AuthService:

    @staticmethod
    def register(
        db: Session,
        user_data,
    ):
        existing = UserRepository.get_by_email(
            db,
            user_data.email,
        )

        if existing:
            raise HTTPException(
                status_code=400,
                detail="Email already registered",
            )

        user = User(
            name=user_data.name,
            email=user_data.email,
            password=hash_password(
                user_data.password,
            ),
            college=user_data.college,
            course=user_data.course,
            year=user_data.year,
        )

        return UserRepository.create_user(
            db,
            user,
        )

    @staticmethod
    def login(
        db: Session,
        credentials,
    ):
        user = UserRepository.get_by_email(
            db,
            credentials.email,
        )

        if not user:
            raise HTTPException(
                status_code=401,
                detail="Invalid email or password",
            )

        if not verify_password(
            credentials.password,
            user.password,
        ):
            raise HTTPException(
                status_code=401,
                detail="Invalid email or password",
            )

        token = create_access_token(
            {
                "sub": str(user.id),
                "email": user.email,
            }
        )

        return Token(
            access_token=token,
            token_type="bearer",
        )