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
    DateTime,
    Time
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



class Event(Base):
    __tablename__ = 'event'
    id = Column(Integer, primary_key=True)
    nazov = Column(String)
    begin = Column(DateTime)
    end = Column(DateTime)
    by_user_id = Column(Integer, ForeignKey('user.id'), index=True)
    user = relationship('User', backref=backref("user", cascade="all, delete-orphan"))
    leader_id = Column(Integer, ForeignKey('employee.id'), index=True)
    leader = relationship('Employee')
    hash1 = Column(Integer);
    hash2 = Column(Integer);
    description = Column(String)
    goal = Column(String)
    performance = Column(Integer);
    finished = Column(Boolean)
    workplace = Column(String)

    def __init__(self, user, leader, nazov, begin, end ):
        self.user = user
        self.leader = leader
        self.nazov = nazov
        self.begin = begin
        self.end = end
    

    def length(self):
        # returne dlzku eventu v hodinach
        diff = self.end - self.begin
        return diff.total_seconds() /60 / 60

    def how_many_weeks_back(self):
        from datetime import datetime
        now = datetime.now()
        diff = (now-self.end).days
        return int(diff / 7) 

    def is_finished(self):
        from datetime import datetime
        now = datetime.now()
        return now > self.end