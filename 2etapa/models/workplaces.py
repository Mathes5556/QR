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


class Workplace(Base):
    __tablename__ = 'Workplace'
    id = Column(Integer, primary_key=True)
    city  = Column(String)
    address  = Column(String)
    by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    user = relationship('User')

    

    def __init__(self, by_user, city, address):
        self.user = by_user
        self.city = city
        self.address = address