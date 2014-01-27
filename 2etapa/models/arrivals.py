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



class Arrival(Base):
    __tablename__ = 'arrival'
    id = Column(Integer, primary_key=True)
    poznamka = Column(String)
    arrival = Column(DateTime)
    departure = Column(DateTime)
    hodnotenie = Column(Integer)
    employee_id= Column(Integer, ForeignKey('employee.id'), index=True)
    employee = relationship('Employee', backref=backref("employee", cascade="all, delete-orphan"))
    performance = Column(Integer)
    type_of_performance = Column(Integer)
    # 0 pocet, 1 percenta

    def __init__(self,employee,poznamka,arrival,departure = None,hodnotenie = None):
        self.employee = employee
        self.poznamka = poznamka
        self.arrival = arrival
        self.departure = departure
        self.hodnotenie = hodnotenie
