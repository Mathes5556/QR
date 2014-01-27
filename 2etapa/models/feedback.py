'''
Created on 31.7.2013

@author: peter
'''
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
    Date
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



class Feedback(Base):
    """Database table Feedback

    Attributes:
        id: Identificator of object
        text: Raw text
        author: Author of feedback
        date: Date of release feedback
        sentiment:
        article_id: ForeignKey to article
    """
    __tablename__ = 'feedback'
    id = Column(Integer, primary_key=True)
    text = Column(String, nullable=False)
    author = Column(String(30))
    type = Column(String(20))
    date = Column(Date)
    sentiment = Column(Float)
    article_id= Column(Integer, ForeignKey('article.id'), index=True)
    article=relationship('Article', backref=backref("feedbacks", cascade="all, delete-orphan"))
    

    def __init__(self,article,text,sentiment,date):
        self.article=article
        self.text = text
        self.sentiment = sentiment
        self.date = date
        