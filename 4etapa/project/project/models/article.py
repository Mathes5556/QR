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
    DateTime,
    Date
    )

from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    )

from sqlalchemy.ext.hybrid import (
    Comparator, 
    hybrid_property,
    )

from sqlalchemy.orm import (
    validates,
    relationship,
    scoped_session,
    sessionmaker,
    )

from . import Base

from sqlalchemy.ext.declarative import declarative_base

from zope.sqlalchemy import ZopeTransactionExtension

class Article(Base):
    """Database table Article

    Attributes:
        id: Identificator of object
        title: Name of article
        text: Raw text
        type: Type of article
        author: Author of article
        date: Date of release article
        sentiment:
    """
    __tablename__ = 'article'
    id = Column(Integer, primary_key=True)
    title = Column(String(150))
    text = Column(String, nullable=False)
    type = Column(String(20))
    author = Column(String(30)) 
    date = Column(Date)
    sentiment = Column(Float)
    kategoria = Column(String(20))
    region = Column(String(30))

    def __init__(self, title, text, sentiment,date, source, author,kategoria='ziadny', region='ziadny'):
        self.title = title
        self.text = text
        self.sentiment = sentiment
        self.date = date
        self.type = source
        self.author = author
        self.kategoria = kategoria
        self.region = region


    def __repr__(self):
        """Returns representative object of class Article.
        """
        return "Article(Title=%s, Author=%s, Date=%s, Sentiment=%s)"%(self.title, self.author , str(self.date), str(self.sentiment))

        