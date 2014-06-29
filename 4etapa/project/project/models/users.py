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

class User(Base):
    __tablename__ = 'user'
    id = Column(Integer, primary_key=True)
    meno = Column(String(30))
    heslo = Column(String, nullable=False)
    prava = Column(String(20))

    def __init__(self, meno, heslo, prava ):
        self.meno = meno
        self.heslo  = heslo
        self.prava = prava
