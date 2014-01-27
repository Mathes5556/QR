from project.models import (
    DBSession,
    )
from project.models.users import User
from sqlalchemy import func
from datetime import date
import datetime

from project.models import (
    DBSession,
    )
from project.models.users import User

    
# USERS = {'editor':'editor',
#           'viewer':'viewer'}
GROUPS = {'admin':['group:admin']}

def groupfinder(user, request):
    pravomoc = request.db_session.query(User.prava).filter(User.meno == user).first()[0]
    # print('overujeeem', user)
    # print(GROUPS.get(pravomoc, []))
    return GROUPS.get(pravomoc, [])