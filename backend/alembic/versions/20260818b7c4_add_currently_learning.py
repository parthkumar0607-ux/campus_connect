"""add currently_learning column to users

Revision ID: 20260818b7c4
Revises: 135c1661e5c4
Create Date: 2026-08-18 12:00:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '20260818b7c4'
down_revision: Union[str, Sequence[str], None] = '135c1661e5c4'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # Add currently_learning column to users table with default empty string
    op.add_column('users', sa.Column('currently_learning', sa.String(length=500), nullable=True, server_default=''))


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_column('users', 'currently_learning')
