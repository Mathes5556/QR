from pyramid.response import Response
from pyramid.view import view_config
from collections import defaultdict
from sqlalchemy.exc import DBAPIError

import datetime

import json


from project.models import (
    DBSession,
    )
from project.models.users import User
from sqlalchemy import func
from sqlalchemy import or_
from datetime import date
import datetime

from pyramid.view import (
    view_config,
    forbidden_view_config,
    )

from pyramid.security import (
    remember,
    forget,
    authenticated_userid
    )
from pyramid.httpexceptions import (
    HTTPFound,
    HTTPNotFound,
    )
from project.models.security import GROUPS
from pyramid.security import has_permission


    
from project.models.employee import Employee
from project.models.event import Event
from project.models.task import Task
from project.models.arrivals import Arrival
from project.models.employees_type import Employees_type
from project.models.workplaces import Workplace
from project.models.Hash_employee import Hash_employee
from project.models.comparison import Comparison


@view_config(route_name='registration', renderer='project:templates/registration.mako')
def registration(request):
    # print('r')
    # print(request.params)
    login_url = request.route_url('login')
    print(request.url)
    referrer = request.url
    if referrer == login_url:
        referrer = '/' # never use the login form itself as came_from
    came_from = request.params.get('came_from', referrer)
    message = ''
    login = ''
    password = ''
    if 'form.submitted' in request.params:
            # print('a' * 120)
            login = request.params['login']
            id = request.db_session.query(User.id).filter(User.meno == login).first()[0]
            # print('id je')
            # print(id)
            # print(login)
            
            # print(USERS.get(id))
            user_z_db = request.db_session.query(User).get(id)
            print('meno z db')
            print(user_z_db.meno)
            password = request.params['password']
            print(user_z_db.heslo == password)

            # if USERS.get(login) == password:
            if user_z_db.heslo == password:
                print('posielam')
                headers = remember(request, login) #  tato funkcia zavola group finder v secuirity.py
                return HTTPFound(location = came_from,
                                 headers = headers)
            message = 'Failed login'

    return dict(
        message = message,
        url = request.application_url + '/login',
        came_from = came_from,
        login = login,
        password = password,
        )


@view_config(route_name='login', renderer='project:templates/login.mako')
@forbidden_view_config(renderer='project:templates/login.mako')
def login(request):
    # print('r')
    # print(request.params)
    login_url = request.route_url('login')
    print(request.url)
    referrer = request.url
    if referrer == login_url:
        referrer = '/' # never use the login form itself as came_from
    came_from = request.params.get('came_from', referrer)
    message = ''
    login = ''
    password = ''
    if 'form.submitted' in request.params:
            # print('a' * 120)
            login = request.params['login']
            id = request.db_session.query(User.id).filter(User.meno == login).first()[0]
            # print('id je')
            # print(id)
            # print(login)
            
            # print(USERS.get(id))
            user_z_db = request.db_session.query(User).get(id)
            print('meno z db')
            print(user_z_db.meno)
            password = request.params['password']
            print(user_z_db.heslo == password)

            # if USERS.get(login) == password:
            if user_z_db.heslo == password:
                print('posielam')
                headers = remember(request, login) #  tato funkcia zavola group finder v secuirity.py
                return HTTPFound(location = request.route_url('employees'),
                                 headers = headers)
            message = 'Failed login'

    return dict(
        message = message,
        url = request.application_url + '/login',
        came_from = came_from,
        login = login,
        password = password,
        )

@view_config(route_name='logout')
def logout(request):
    headers = forget(request)
    print(request)
    return HTTPFound(location = request.route_url('login'),
                     headers = headers)


@view_config(route_name='skuska', renderer='project:templates/skuska.mako',  permission='edit')
def skuska(request):


    a = request.matchdict['kolka']
    print(USERS)
              # one_day=request.db_session.query(Article.date,func.avg(Article.sentiment)).\
    for id in request.db_session.query(User.id):
        print(id[0] == 5)
    print('heslo je:')
    # user = request.db_session.query(User).get(5)
    print(user)
    print('heslo bolo:')
    # print(has_permission('Vsetci', request.context, request))
    print(authenticated_userid(request))
    return dict(logged_in=authenticated_userid(request))

@view_config(route_name='skuska2', renderer='json',  permission='admin')
def skuska2(request):

    # a = request.db_session.query(User.meno).first()
    # print(a)
    
    prichod = Arrival(25, 'aa', datetime.datetime.now())
    DBSession.add(prichod)
    print(has_permission('edit', request.context, request))
    return {'logged_in' : authenticated_userid(request)}

@view_config(route_name='home', renderer='project:templates/home.mako')
def home(request):
    u = User('mathes', 'mathes', 'admin')
    DBSession.add(u)
    user =  request.db_session.query(User).first()
    typ =  Employees_type(user, 'picker')
    typ2 =  Employees_type(user, 'manager')
    DBSession.add(typ)
    DBSession.add(typ2)

    employee = Employee(user, 'Ladislav', 'Jakab', typ, 21)
    DBSession.add(employee)
    
    miesto = Workplace(user, 'Bratislava', 'Kadnarová 20')
    miesto2 = Workplace(user, 'Senec', 'Letna 12')
    DBSession.add(miesto2)
    DBSession.add(miesto)
    hash_zamestnanec = Hash_employee(user, 'junior')
    DBSession.add(hash_zamestnanec)
    hash_zamestnanec2 = Hash_employee(user, 'senior')
    DBSession.add(hash_zamestnanec2)
    porovnavacka = Comparison(user, hash_zamestnanec, hash_zamestnanec2)
    DBSession.add(porovnavacka)
    zaciatok_eventu = datetime.datetime(2007, 12, 6, 15, 30, 0, 0)
    koniec_eventu = datetime.datetime(2007, 12, 6, 18, 30, 0, 0)
    event = Event(user, employee, 'druhy event', zaciatok_eventu, koniec_eventu)
    task = Task(employee, event)
    DBSession.add(task)
    DBSession.add(event)
    print(event)
    
    return{}

@view_config(route_name='checkin', renderer='json',  permission='admin')
def checkin(request):
    employee_id = request.matchdict['employee_id']
    employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    print('**' * 250)
    print(get_verified_user_id(request))
    print(get_verified_user_id(request))
    print(get_verified_user_id(request))
    print(employee.by_user_id)
    if employee.by_user_id != get_verified_user_id(request):
        return {'chyba' : 'nemas prava na manipulaciu s tymto employee!'}

    users_departure = request.db_session.query(Arrival.departure).filter(Arrival.employee_id ==employee_id).all()
    for departure in users_departure:
        if departure[0] == None:
            return {'chyba' : 'employee je v robote, nemozno ho ceknut'}




    prichod = Arrival(employee, 'ziadna', datetime.datetime.now())
    DBSession.add(prichod)
    departure = request.db_session.query(Arrival.departure).first()[0] ## NONE
    return {'logged_in' : authenticated_userid(request), 'employee_id' : employee_id, 'chyba': None}

@view_config(route_name='checkout', renderer='json',  permission='admin')
def checkout(request):
    employee_id = request.matchdict['employee_id']
    performance = request.matchdict['performance']

    employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    if employee.by_user_id != get_verified_user_id(request):
        return {'chyba' : 'nemas prava na manipulaciu s tymto employee!'}
    # employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    arrivals = request.db_session.query(Arrival).filter(Arrival.employee_id == employee_id, Arrival.departure == None).all()
    print('*' * 250)
    for i in arrivals:
        print(i.id)
    print(arrivals)
    if len(arrivals) == 1:
        arrival = arrivals[0]
        arrival.departure = datetime.datetime.now();
        arrival.performance = performance
        DBSession.flush() 
        return {'arrivaldeparture': arrival.departure}
    else:
        return{'chyba': 'chyba pri check oute kontaltujet admina'}

@view_config(route_name='events',  renderer='project:templates/events.mako', permission='admin')
def events(request):
    events = request.db_session.query(Event).filter(Event.by_user_id == get_verified_user_id(request)).all()
    avaliable_leaders = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request)).all()
    return {'events' : events, 'avaliable_leaders' : avaliable_leaders} 

@view_config(route_name='event',  renderer='project:templates/event_profile.mako', permission='admin')
def event(request):
    event_id = request.matchdict['event_id']
    event = request.db_session.query(Event).filter(Event.id == event_id).first()
    if event.by_user_id != get_verified_user_id(request):
        # ked ide do eventu do ktoreho nema pristup redirect..
        return HTTPFound(location = request.route_url('events'))
    participiants_id = request.db_session.query(Task.employee_id).filter(Task.event_id == event_id).all()
    participiants = [request.db_session.query(Employee.id, Employee.name, Employee.surname).filter(Employee.id == p[0]).first() for p in participiants_id]
    # print(participiants)
    all_possible_hash_tags = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request),Hash_employee.type == 0).all()
    #hash_tags = request.db_session.query(Hash_employee).filter(or_(Hash_employee.id == employee.hash1, Hash_employee.id == employee.hash2)).all()
    return {'event' : event, 'participiants': participiants,'all_possible_hash_tags': all_possible_hash_tags}

@view_config(route_name='employee',  renderer='project:templates/employee_profile.mako', permission='admin')
def employee(request):
    employee_id = request.matchdict['employee_id']
    employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    if employee.by_user_id != get_verified_user_id(request):
        # ked ide do usera do ktoreho nema pristup redirect..
        return HTTPFound(location = request.route_url('employees'))
    user_tasks = request.db_session.query(Task).filter(Task.employee_id == employee_id).all()
    hash_tags = request.db_session.query(Hash_employee).filter(or_(Hash_employee.id == employee.hash1, Hash_employee.id == employee.hash2)).all()
    all_possible_hash_tags = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request),Hash_employee.type == 1).all()
    arrivals = request.db_session.query(Arrival).filter(Arrival.employee_id == employee_id).all()
    print('*' * 250)
    performances = [];
    for arrival in arrivals:
        performances.append(arrival.performance)
    print(performances)
    return {'employee' : employee , 'user_tasks' : user_tasks, 'hash_tags' : hash_tags, 'all_possible_hash_tags' : all_possible_hash_tags, 'performances' : performances }


@view_config(route_name='employees',  renderer='project:templates/employees.mako', permission='admin')
def employees(request):
    employees = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request)).all()
    print(employees)
    in_work = []
    for employee in employees:
        in_work.append(employee.is_in_work(request))
    print(in_work)
    positions = request.db_session.query(Employees_type).filter(Employees_type.by_user_id == get_verified_user_id(request)).all()
    print(positions)
    return {'employees' : employees, 'in_work' : in_work,'positions' : positions}

@view_config(route_name='customize',  renderer='project:templates/customize.mako', permission='admin')
def customize(request):
    employee_types = request.db_session.query(Employees_type).filter(Employees_type.by_user_id == get_verified_user_id(request)).all()
    workplaces = request.db_session.query(Workplace).filter(Workplace.by_user_id == get_verified_user_id(request)).all()
    print(workplaces)
    comparisons = request.db_session.query(Comparison).filter(Comparison.by_user_id == get_verified_user_id(request), Comparison.type == 1).all()
    comparisons_event = request.db_session.query(Comparison).filter(Comparison.by_user_id == get_verified_user_id(request), Comparison.type == 0).all()
    print(comparisons)
    comp = request.db_session.query(Comparison).filter(Workplace.by_user_id == get_verified_user_id(request)).first()

    hash_tags = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request), Hash_employee.type == 1).all()
    hash_tags_event = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request), Hash_employee.type == 0).all()
    print('*' * 200) 
    print(comparisons)
    return {'employee_types': employee_types, 'workplaces': workplaces, 'comparisons': comparisons, 'comparisons_event' : comparisons_event,'hash_tags': hash_tags, 'hash_tags_event': hash_tags_event }


@view_config(route_name='delete', renderer='json',  permission='admin')
def delete(request):
    type_to_delete = request.matchdict['type_to_delete']
    id = request.matchdict['id']
    if type_to_delete == "hash":
        request.db_session.query(Hash_employee).filter(Hash_employee.id == id).delete()
        return {'type' : 'hash'}
    if type_to_delete == "comparison":
        request.db_session.query(Comparison).filter(Comparison.id == id).delete()
        return {'type' : 'comparison'}
    if type_to_delete == "workplace":
        request.db_session.query(Workplace).filter(Workplace.id == id).delete()
        return {'type' : 'wokplace'}
    if type_to_delete == "workposition":
        request.db_session.query(Employees_type).filter(Employees_type.id == id).delete()
        return {'type' : 'Employees_type'}


@view_config(route_name='add', renderer='json',  permission='admin')
def add(request):
    type_to_add = request.matchdict['type_to_delete']
    name = request.matchdict['name']
    if type_to_add == "workposition":
        if request.db_session.query(Employees_type).filter(Employees_type.name == name, Employees_type.by_user_id ==  get_verified_user_id(request)).first() == None:
            new_workposition =  Employees_type(get_user(request), name)
            DBSession.add(new_workposition)
            DBSession.flush()
            DBSession.refresh(new_workposition)
            return{'status': 'ok' ,'name':  name, 'id' : new_workposition.id} 
        else:
            return{'status': 'workposition with name '+name+' is in databse already'}
    elif type_to_add == "workplace":
        print('*' * 500)
        print(name)
        city = name.split('!')[0]
        address = name.split('!')[1]
        if request.db_session.query(Workplace).filter(Workplace.address == address).first() == None:
            new_workplace =  Workplace(get_user(request), city, address)
            DBSession.add(new_workplace)
            DBSession.flush()
            DBSession.refresh(new_workplace)
            return{'status': 'ok' ,'name':  name, 'id' : new_workplace.id} 
        else:
            return{'status': 'workposition with name '+name+' is in databse already'}
    if type_to_add == "hash_employee":
        if request.db_session.query(Hash_employee).filter(Hash_employee.name == name, Hash_employee.type == 1, Hash_employee.by_user_id == get_verified_user_id(request)).first() == None:
            hash_zamestnanec = Hash_employee(get_user(request), name, 1)
            DBSession.add(hash_zamestnanec)
            DBSession.flush()
            DBSession.refresh(hash_zamestnanec)
            return{'status': 'ok' ,'name':  name, 'id' : hash_zamestnanec.id} 
        else:
            return{'status': 'employee hashtag with name '+name+' is in databse already'}
    if type_to_add == "hash_event":
        if request.db_session.query(Hash_employee).filter(Hash_employee.name == name, Hash_employee.type == 0, Hash_employee.by_user_id == get_verified_user_id(request)).first() == None:
            hash_zamestnanec = Hash_employee(get_user(request), name, 0)
            DBSession.add(hash_zamestnanec)
            DBSession.flush()
            DBSession.refresh(hash_zamestnanec)
            return{'status': 'ok' ,'name':  name, 'id' : hash_zamestnanec.id} 
        else:
            return{'status': 'event hashtag with name '+name+' is in databse already'}

@view_config(route_name='add_comparison', renderer='json',  permission='admin')
def add_comparison(request):
    type = request.matchdict['type']
    hash1_name = request.matchdict['hash1']
    hash2_name = request.matchdict['hash2']

    if type == "employee":
        hash1 = request.db_session.query(Hash_employee).filter(Hash_employee.name == hash1_name, Hash_employee.user == get_user(request)).first()
        hash2 = request.db_session.query(Hash_employee).filter(Hash_employee.name == hash2_name, Hash_employee.user == get_user(request)).first()
        print(hash1)
        print(hash2)
        porovnavacka = Comparison(get_user(request), hash1, hash2, 1)
        DBSession.add(porovnavacka)
        DBSession.flush()
        DBSession.refresh(porovnavacka)
        return{'status' : 'ok', 'id' : porovnavacka.id}
    elif type == "event":
        hash1 = request.db_session.query(Hash_employee).filter(Hash_employee.name == hash1_name, Hash_employee.user == get_user(request)).first()
        hash2 = request.db_session.query(Hash_employee).filter(Hash_employee.name == hash2_name, Hash_employee.user == get_user(request)).first()
        print(hash1)
        print(hash2)
        porovnavacka = Comparison(get_user(request), hash1, hash2, 0)
        DBSession.add(porovnavacka)
        DBSession.flush()
        DBSession.refresh(porovnavacka)
        return{'status' : 'ok', 'id' : porovnavacka.id}
    else:
        return{'status' : 'This ype of comparison is not in our system'}
@view_config(route_name='add_employee', renderer='json',  permission='admin', request_method="POST")
def add_employee(request):
    post=request.POST
    # if post['position'] == "Undefined":
    if post['position'] == '':
        employee_position = None
    else:
        employee_position = request.db_session.query(Employees_type).filter(Employees_type.by_user_id == get_verified_user_id(request), Employees_type.name == post['position']).first()
    

    employee = Employee(get_user(request), post['name'], post['surname'], employee_position, post['age'], post['merital_status'], post['sex'], post['addresse'])
    DBSession.add(employee)
    
    #import pyqrcode
    #big_code = pyqrcode.create(employee.id, error='L', version=27, mode='binary')
    #big_code.png(employee.surname, scale=6, module_color=[0, 0, 0, 128], background=[0xff, 0xff, 0xcc])
    # im = Image.open(request.params['code2.png'].file)
    return HTTPFound(location = request.route_url('employees'))

@view_config(route_name='add_user', renderer='json', request_method="POST")
def add_user(request):
    post=request.POST

    new_user = User(post['name'], post['password'], 'admin')
    DBSession.add(new_user)
    return HTTPFound(location = request.route_url('employees'))

@view_config(route_name='add_event', renderer='json', request_method="POST",  permission='admin',)
def add_event(request):
    post=request.POST
    id_leader =  post['id_leader']
    time_begin =  post['time_begin'].split(':')
    time_begin = [int(x) for x in time_begin]
    time_end =  post['time_end'].split(':')
    time_end = [int(x) for x in time_end]
    date_begin = post['date_begin'].split('/')
    date_begin = [int(x) for x in date_begin]
    date_end = post['date_end'].split('/')
    date_end = [int(x) for x in date_end]

    
    leader = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request), Employee.id == id_leader).first()
    print(time_end)
    zaciatok_eventu = datetime.datetime(date_begin[2], date_begin[0], date_begin[1], time_begin[0], time_begin[1], 0, 0)
    koniec_eventu = datetime.datetime(date_end[2], date_end[0], date_end[1], time_end[0], time_end[1], 0, 0)
    event = Event(get_user(request),  leader, post['name'], zaciatok_eventu, koniec_eventu)
    DBSession.add(event)

    return HTTPFound(location = request.route_url('events'))
    #return HTTPFound(location = request.route_url('events'))

@view_config(route_name='add_hash_employee', renderer='json' ,  permission='admin',)
def add_hash_employee(request):
    id_employee = request.matchdict['id_employee']
    id_hash = request.matchdict['id_hash']

    hash_tag = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request), Hash_employee.id == id_hash).first()
    
    employee = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request), Employee.id == id_employee).\
    filter(or_(Employee.hash1 == id_hash, Employee.hash2 == id_hash)).first()
    if employee is not None:
        return{'status': 'user have this hash tag already!!'} 
    if hash_tag == None:
        return{'status': 'hash tag dont exist'} 
    else:
        employee = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request), Employee.id == id_employee).first()
        if employee == None:
            return{'status': 'employee dont exist'}
        if employee.hash1 == None:
            employee.hash1 = id_hash
            DBSession.flush()
            return{'status': 'ok'}
        elif employee.hash2 == None:
            employee.hash2 = id_hash
            DBSession.flush()
            return{'status': 'ok'}
        else:
            return{'status': 'You can have maximum 2 hash tags for one employee'}

@view_config(route_name='delete_hash_employee', renderer='json',  permission='admin',)
def delete_hash_employee(request):
    id_employee = request.matchdict['id_employee']
    id_hash = request.matchdict['id_hash']
    hash_tag = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request), Hash_employee.id == id_hash).first()
    if hash_tag == None:
        return{'status': 'hash tag dont exist'} 
    else:
        employee = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request), Employee.id == id_employee).\
        filter(or_(Employee.hash1 == id_hash, Employee.hash2 == id_hash)).first()
        print(type(employee.hash2))
        # print(type(id_hash))
        if employee == None:
            return{'status': 'No employee require condition'} 
        if employee.hash1 == int(id_hash):
            employee.hash1 = None
            DBSession.flush()
            return{'status': 'hash was deleted'} 

        if employee.hash2 == int(id_hash):
            employee.hash2 = None
            DBSession.flush() 
            return{'status': 'hash was deleted'} 

@view_config(route_name='add_task', renderer='json',  permission='admin',)
def add_task(request):
    id_event = request.matchdict['id_event']
    name_of_employee = request.matchdict['name_of_employee']
    name = name_of_employee.split(' ')[0]
    surname = name_of_employee.split(' ')[1]
    print(name, len(surname))   
    employee = request.db_session.query(Employee).filter(Employee.name == name, Employee.surname == surname).first()
    print(employee)
    event = request.db_session.query(Event).filter(Event.id == id_event).first()
    print('*' * 250)
    print(employee)
    if employee is None:
        # ked ide do eventu do ktoreho nema pristup redirect..
        return{'status': 'you have not acces to do with this employee'} 
    if event.by_user_id != get_verified_user_id(request):
        # ked ide do eventu do ktoreho nema pristup redirect..
        return{'status': 'you have not acces to wotk with this event'} 
    print(events)

    exist_task = request.db_session.query(Task).filter(Task.event_id == id_event, Task.employee_id == employee.id).first()
    print(exist_task)
    if exist_task is not None:
        return{'status': 'employee is in this task already'}  
    task = Task(employee, event)
    DBSession.add(task)
    DBSession.add(event)
    return{'name': name, 'surname': surname, 'status': 'ok'} 

@view_config(route_name='all_employee', renderer='json',  permission='admin',)
def all_employee(request):

    employees = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request)).all()
    names_of_employee = []
    for employee in employees:
        names_of_employee.append(employee.name +" "+employee.surname)
    print(names_of_employee)
    return{'names_of_employee': names_of_employee} 



  

@view_config(route_name='delete_employee_from_task', renderer='json',  permission='admin',)
def delete_employee_from_task(request):
    id_event = request.matchdict['id_event']
    id_of_employee = request.matchdict['id_of_employee']
    event = request.db_session.query(Event).filter(Event.id == id_event).first()
    if event is not None: 
        request.db_session.query(Task).filter(Task.employee_id == id_of_employee, Task.event_id == id_event).delete()
        return{'status' : 'ok'}
    else:
        return{'status' : 'error'}

@view_config(route_name='stats', renderer='project:templates/stats.mako',  permission='admin',)
def stats(request):
    
    return{'status' : 'error'}



def get_verified_user_id(request):
    # return id aktualne prihalseneho usera

    user_name = authenticated_userid(request)
    print('#' * 40)
    print(user_name)
    return request.db_session.query(User.id).filter(User.meno == user_name).first()[0]


def get_user(request):
    user_name = authenticated_userid(request)
    return request.db_session.query(User).filter(User.meno == user_name).first()



