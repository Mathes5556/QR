from sqlalchemy import (
    Column,
    Integer,
    String,
    Text,
    Float,
    Boolean,
    Table,
    ForeignKey,
    Enum,
    Float,
    Date,
    DateTime
    )

from sqlalchemy.ext.hybrid import (
    Comparator, 
    hybrid_property,
    )

from sqlalchemy.orm import (
        relationship,
        backref
    )

from . import Base

from sqlalchemy.ext.declarative import declarative_base

from zope.sqlalchemy import ZopeTransactionExtension
from project.models.arrivals import Arrival


class Employees_type(Base):
    __tablename__ = 'Employees_type'
    id = Column(Integer, primary_key=True)
    name  = Column(String)
    by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    user = relationship('User')

    

    def __init__(self, by_user, name):
        self.user = by_user
        self.name = name