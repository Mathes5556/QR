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


class Employee(Base):
    __tablename__ = 'employee'
    id = Column(Integer, primary_key=True)
    name  = Column(String)
    surname = Column(String)
    
    boss = Column(String)
    residence = Column(String)
    merital_status = Column(String) 
    sex = Column(String)
    age = Column(Integer)
    by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    user = relationship('User')
    position_id = Column(Integer, ForeignKey('Employees_type.id'), index=True)
    position = relationship('Employees_type', backref=backref("Employees_type", cascade="all, delete-orphan"))
    hash1 = Column(Integer);
    hash2 = Column(Integer);
        
    # sentiment = Column(Float)
    # article_id= Column(Integer, ForeignKey('article.id'), index=True)
    # article=relationship('Article', backref=backref("feedbacks", cascade="all, delete-orphan"))
    

    def __init__(self, by_user, name, surname, position, age , merital_status =None, sex =None, residence=None):
        self.user = by_user
        self.name = name
        self.surname = surname
        self.position = position
        self.age = age      
        self.boss = None
        self.residence = residence
        self.merital_status = merital_status
        self.sex = sex
        self.full_name = self.name + " " + self.surname

    def is_in_work(self, request):
        users_departures = request.db_session.query(Arrival.departure).filter(Arrival.employee_id == self.id).all()
        for departure in users_departures:
            if departure[0] == None:
                return True
            else:
                pass
        if users_departures == []:
            pass

        return False