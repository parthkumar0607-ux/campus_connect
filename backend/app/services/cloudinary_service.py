import cloudinary.uploader
from fastapi import HTTPException, UploadFile


class CloudinaryService:

    @staticmethod
    def upload_profile_image(file: UploadFile) -> str:
        if file.content_type not in {"image/jpeg", "image/png", "image/webp"}:
            raise HTTPException(
                status_code=415,
                detail="Profile image must be a JPEG, PNG, or WebP file.",
            )

        result = cloudinary.uploader.upload(
            file.file,
            folder="campus_connect/profile_pictures",
            resource_type="image",
        )

        return result["secure_url"]
