from fastapi import (
    APIRouter,
    Depends,
    File,
    UploadFile,
    Query,
    HTTPException,
)
from sqlalchemy import or_
from sqlalchemy.orm import Session

from app.core.dependencies import get_current_user
from app.database.database import get_db
from app.models.user import User
from app.schemas.user import (
    UserResponse,
    UserUpdate,
)
from app.services.cloudinary_service import CloudinaryService
from app.services.user_service import UserService


router = APIRouter(
    prefix="/users",
    tags=["Users"],
)


@router.get(
    "/me",
    response_model=UserResponse,
)
def get_my_profile(
    current_user: User = Depends(get_current_user),
):
    return UserService.get_profile(current_user)


@router.put(
    "/me",
    response_model=UserResponse,
)
def update_my_profile(
    user_data: UserUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    return UserService.update_profile(
        db,
        current_user,
        user_data,
    )


@router.post("/me/profile-image")
def upload_profile_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    image_url = CloudinaryService.upload_profile_image(file)

    current_user.profile_image = image_url

    db.commit()
    db.refresh(current_user)

    return {
        "image_url": image_url,
    }


# ============================
# Discover Students
# ============================

@router.get(
    "",
    response_model=list[UserResponse],
)
def get_all_users(
    search: str | None = Query(
        default=None,
        description="Search by name, course or skills",
    ),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    query = db.query(User).filter(
        User.id != current_user.id
    )

    if search:
        keyword = f"%{search}%"

        query = query.filter(
            or_(
                User.name.ilike(keyword),
                User.course.ilike(keyword),
                User.skills.ilike(keyword),
            )
        )

    return query.order_by(User.name.asc()).all()

@router.get(
    "/{user_id}",
    response_model=UserResponse,
)
def get_user_by_id(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    user = db.query(User).filter(User.id == user_id).first()

    if not user:
        raise HTTPException(
            status_code=404,
            detail="User not found",
        )

    return user

