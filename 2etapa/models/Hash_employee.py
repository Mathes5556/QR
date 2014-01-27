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


class Hash_employee(Base):
    __tablename__ = 'Hash_employee'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    description = Column(String)
    by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    user = relationship('User')
    type = Column(Integer)
    #by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    #user = relationship('Event')

    # type 0 -> event, 1 -> employee
    def __init__ (self, by_user, name, type = 1):
        self.user = by_user
        self.name = name
        self.type = type