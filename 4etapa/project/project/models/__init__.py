import pkgutil
from sqlalchemy.ext.declarative import declarative_base

from sqlalchemy.orm import (
    scoped_session,
    sessionmaker,
    )
from pyramid.security import (
    Allow,
    Everyone,
    )
from zope.sqlalchemy import ZopeTransactionExtension
import project 

Base = declarative_base()
DBSession = scoped_session(sessionmaker(extension=ZopeTransactionExtension()))



def load_modules():
    for loader, module_name, pkg in pkgutil.walk_packages(project.models.__path__, project.models.__name__ + '.'):
        __import__(module_name)

def set_up_tables(engine):
    """Sets up all tables in defined in module `.models` and its submodules.
    
    Args: 
        engine: SQLAlchemy database engine
    """
    metadata = Base.metadata
    load_modules()   
    metadata.drop_all(engine)
    metadata.create_all(engine)
    print("Hello guy,\nI created tables")

class RootFactory(object):
    __acl__ = [ (Allow, Everyone, 'Vsetci'),  #posledny argument je nazov prava nie viewsu
                (Allow, 'group:admin', 'admin') ]
    def __init__(self, request):
        pass