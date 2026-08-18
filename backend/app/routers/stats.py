from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database.database import get_db
from app.services.stats_service import StatsService

router = APIRouter(
    prefix="/stats",
    tags=["Stats"],
)


@router.get("")
def get_stats(db: Session = Depends(get_db)):
    return StatsService.get_counts(db)
