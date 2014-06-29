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



class Task(Base):
    __tablename__ = 'task'
    id = Column(Integer, primary_key=True)
    employee_id = Column(Integer, ForeignKey('employee.id'), index=True)
    employee = relationship('Employee', backref=backref("employees", cascade="all, delete-orphan"))
    event_id =  Column(Integer, ForeignKey('event.id'))
    event = relationship('Event')
    performance = Column(Integer)
    delay = Column(Integer)
    length_of_work = Column(Integer)
    # todo gone,cas ?



    def __init__(self,employee,event, performance, delay, length_of_work):
        self.employee = employee
        self.event = event
        self.performance = performance
        self.delay = delay
        self.length_of_work = length_of_work
        