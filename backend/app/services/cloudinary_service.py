import cloudinary.uploader


class CloudinaryService:

    @staticmethod
    def upload_profile_image(file):
        result = cloudinary.uploader.upload(
            file.file,
            folder="campus_connect/profile_pictures",
        )

        return result["secure_url"]