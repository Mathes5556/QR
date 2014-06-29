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


class Comparison(Base):
    __tablename__ = 'comparison'
    id = Column(Integer, primary_key=True)
    comp_1_id =  Column(Integer, ForeignKey('Hash_employee.id'), index=True)
    comp1 = relationship('Hash_employee', foreign_keys='Comparison.comp_1_id', cascade="all, delete-orphan",  single_parent=True,)
    comp_2_id =  Column(Integer, ForeignKey('Hash_employee.id'), index=True)
    comp2 = relationship('Hash_employee', foreign_keys='Comparison.comp_2_id',  cascade="all, delete-orphan",  single_parent=True,)
    by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    user = relationship('User')
    type = Column(Integer)

    def __init__ (self, by_user, comp1, comp2, type = 1):
        self.user = by_user
        self.comp1 = comp1
        self.comp2 = comp2
        self.type = type;
