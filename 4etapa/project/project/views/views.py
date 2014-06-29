from qrcode import *
from pyramid.response import Response
from pyramid.view import view_config
from collections import defaultdict
from sqlalchemy.exc import DBAPIError
from project.views import query
import datetime

import json

import project.views.sentiment as sentiment

import project.views.topky_views as topky
import project.views.sme_views as sme
import project.views.smediskusie_views as sme_diskusie
import project.views.pravda_views as pravda
import project.views.keywords as keywords

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

import project.views.sme_sk as sme_sk

    
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


@view_config(route_name='qr-checker', renderer='project:templates/qr-checker.mako')
def qr_checker(request):
    return {}


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
    return {'logged_in' : authenticated_userid(request), 'employee_id' : employee_id}

@view_config(route_name='checkout', renderer='json',  permission='admin')
def checkout(request):
    employee_id = request.matchdict['employee_id']
    performance = request.matchdict['performance']
    if performance == -1:
        performance == 100
    employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    if employee.by_user_id != get_verified_user_id(request):
        return {'chyba' : 'nemas prava na manipulaciu s tymto employee!'}
    # employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    arrivals = request.db_session.query(Arrival).filter(Arrival.employee_id == employee_id, Arrival.departure == None).all()
    # for i in arrivals:
    #     print(i.id)
    print(arrivals)
    if len(arrivals) == 1:
        arrival = arrivals[0]
        arrival.departure = datetime.datetime.now();
        arrival.performance = performance
        DBSession.flush() 
        return {'arrivaldeparture': arrival.departure}
    else:
        return{'chyba': 'chyba pri check oute kontaltujet admina'}

 #config.add_route('change_event','/{event_id}/name_of_event/goal/workplace/description')
@view_config(route_name='change_event',renderer='json',  permission='admin')
def change_event(request):
    event = request.db_session.query(Event).filter(Event.id == event_id).first()
    event.description = str(request.matchdict['description'])
    event.nazov = str(request.matchdict['name_of_event'])
    event.goal = str(request.matchdict['goal'])
    event.workplace = str(request.matchdict['workplace'])
    DBSession.flush()


@view_config(route_name='events',  renderer='project:templates/events.mako', permission='admin')
def events(request):
    events = request.db_session.query(Event).filter(Event.by_user_id == get_verified_user_id(request)).all()
    avaliable_leaders = request.db_session.query(Employee).filter(Employee.by_user_id == get_verified_user_id(request)).all()
    return {'events' : events, 'avaliable_leaders' : avaliable_leaders} 

@view_config(route_name='event',  renderer='project:templates/event_profile.mako', permission='admin')
@view_config(route_name='edit_event',  renderer='project:templates/event_profile_edit.mako', permission='admin')
def event(request):
    event_id = request.matchdict['event_id']
    event = request.db_session.query(Event).filter(Event.id == event_id).first()
    
    if event.by_user_id != get_verified_user_id(request):
        # ked ide do eventu do ktoreho nema pristup redirect..
        return HTTPFound(location = request.route_url('events'))
    # participiants_id = request.db_session.query(Task.employee_id).filter(Task.event_id == event_id).all()

    # participiants = [request.db_session.query(Employee.id, Employee.name, Employee.surname).filter(Employee.id == p[0]).first() for p in participiants_id]
    participiants2 = request.db_session.query(Task).filter(Task.event_id == event_id).all()
    # print(participiants)
    all_possible_hash_tags = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request),Hash_employee.type == 0).all()
    #hash_tags = request.db_session.query(Hash_employee).filter(or_(Hash_employee.id == employee.hash1, Hash_employee.id == employee.hash2)).all()
    performances = [task.performance for task in participiants2] 
    try:
        avg_performance = sum(performances) / float(len(performances))
    except:
        avg_performance = 0
    participiants2.sort(key=lambda x: x.performance, reverse=True)
    hash_tags = request.db_session.query(Hash_employee).filter(or_(Hash_employee.id == event.hash1, Hash_employee.id == event.hash2)).all()
    on_time = 0
    on_delay = 0
    for task in participiants2:
        if task.delay == 0:
            on_time += 1
        else:
            on_delay += 1

    # if len(participiants2) == 0:
    #     participiants2 = [event.leader]
    return {'hash_tags' : hash_tags, 'on_delay' :  on_delay, 'on_time' : on_time, 'avg_performance': avg_performance, 'event' : event, 'participiants2': participiants2,'all_possible_hash_tags': all_possible_hash_tags,
            'length_of_event' : event.length()}

@view_config(route_name='employee-public',  renderer='project:templates/event_profile_public.mako')
def employee_public(request):
    employee_id = request.matchdict['employee_id']
    employee = request.db_session.query(Employee).filter(Employee.id == employee_id).first()
    if employee.by_user_id != get_verified_user_id(request):
        # ked ide do usera do ktoreho nema pristup redirect..
        return HTTPFound(location = request.route_url('employees'))
    user_tasks = request.db_session.query(Task).filter(Task.employee_id == employee_id).all()
    hash_tags = request.db_session.query(Hash_employee).filter(or_(Hash_employee.id == employee.hash1, Hash_employee.id == employee.hash2)).all()
    all_possible_hash_tags = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request),Hash_employee.type == 1).all()
    arrivals = request.db_session.query(Arrival).filter(Arrival.employee_id == employee_id).all()
    performances = [];
    for arrival in arrivals:
        performances.append(arrival.performance)
    print('*' * 100)
    print(employee.lock_for_public)
    return {'employee' : employee , 'user_tasks' : user_tasks, 'hash_tags' : hash_tags, 'all_possible_hash_tags' : all_possible_hash_tags, 'performances' : performances }

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
    performances = []
    groups_of_week = [0,0,0,0,0]
    if(len(arrivals) > 9):
        arrivals = arrivals[8:] 
    for arrival in arrivals:
        performances.append(arrival.performance)

        history_in_week = arrival.how_many_weeks_back()
        #zobrazim iba psoldne 4 mesiace
        if(history_in_week <= 4):
            groups_of_week[history_in_week] +=  int(arrival.length() * 100) / 100.0
    week_of_now = datetime.datetime.now().isocalendar()[1]
    last_five_weeks = []
    for i in range(5):
        last_five_weeks.append(week_of_now-i)
    print(last_five_weeks)

     #otocim poradie lebo chcem aby bolo na poslendom mieste terajsi tyzden..
    groups_of_week = groups_of_week[::-1]
    last_five_weeks = last_five_weeks[::-1]
    return {'last_five_weeks': last_five_weeks, 'groups_of_week':  groups_of_week  , 'employee' : employee , 'user_tasks' : user_tasks, 'hash_tags' : hash_tags, 'all_possible_hash_tags' : all_possible_hash_tags, 'performances' : performances }

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

@view_config(route_name='stats', renderer='project:templates/stats.mako',  permission='admin')
def stats(request):
    comparisons = request.db_session.query(Comparison).filter(Comparison.by_user_id == get_verified_user_id(request), Comparison.type == 1).all()
    comparisons_event = request.db_session.query(Comparison).filter(Comparison.by_user_id == get_verified_user_id(request), Comparison.type == 0).all()
    return{'comparisons' : comparisons, 'comparisons_event': comparisons_event}



@view_config(route_name='comparison_events', renderer='json',  permission='admin')
def comparison_events(request):
    hash1_id,hash2_id = request.matchdict['id1'], request.matchdict['id2']
    #vsetky eventy ktore maju dany hash..
    hash1_group = request.db_session.query(Event).\
                filter(or_(Event.hash1 == hash1_id, Event.hash2 == hash1_id)).\
                all()
    ids_group1 = [e.id for e in hash1_group]
    hash2_group = request.db_session.query(Event).\
                filter(or_(Event.hash1 == hash2_id, Event.hash2 == hash2_id)).\
                all()
    ids_group2 = [e.id for e in hash2_group]

    #mam idecka  eventov, teraz najts prisluchauje tasky..
    tasks_gruop1 = request.db_session.query(Task).\
                   filter(Task.event_id.in_(ids_group1)).\
                   all()

    tasks_gruop2 = request.db_session.query(Task).\
                   filter(Task.event_id.in_(ids_group2)).\
                   all()

    # a = recitam informacie z jednotlvych taskov..
    weeks_of_performance = {}
    # avg performance of grup for last x week
    weeks, weeks_for_hour = {}, {}
    weeks[1], weeks_for_hour[1] =  [[] for i in range(5)], [0 for i in range(5)]
    weeks[2], weeks_for_hour[2] =  [[] for i in range(5)], [0 for i in range(5)]

    delay = {}
    delay[1], delay[2]  = [0,0], [0,0] #(nemeskal or meskal menej ako 2 minuty, meskal 2 + )
    acceptable_delay = 2


    for task in tasks_gruop1:
        history_in_week = task.event.how_many_weeks_back()
        weeks[1][history_in_week].append(task.performance)
        weeks_for_hour[1][history_in_week] += task.length_of_work
        if task.delay <= acceptable_delay:
            delay[1][0] += 1 
        else:
            delay[1][1] += 1 

    for task in tasks_gruop2:
        history_in_week = task.event.how_many_weeks_back()
        weeks[2][history_in_week].append(task.performance)
        weeks_for_hour[2][history_in_week] += task.length_of_work
        if task.delay <= acceptable_delay:
            delay[2][0] += 1 
        else:
            delay[2][1] += 1 
     #make average for each week 
    for which_week in weeks.keys():
        print(which_week)
        for i, week in enumerate(weeks[which_week]):
            if not len(week):
                weeks[which_week][i] = 0
            else:
                avg = sum(week) / float(len(week)) 
                weeks[which_week][i] = avg 


    #last five weeks..
    week_of_now = datetime.datetime.now().isocalendar()[1]
    last_five_weeks = []
    for i in range(5):
        last_five_weeks.append(week_of_now-i)
    last_five_weeks = last_five_weeks[::-1]

    #otocim poradie lebo chcem aby bolo na poslendom mieste terajsi tyzden..
    for which_week in weeks.keys():
        weeks[which_week] = weeks[which_week][::-1]
        weeks_for_hour[which_week] = weeks_for_hour[which_week][::-1]

    print(delay)
    return{'weeks_of_performance' : weeks, 'weeks_for_hour': weeks_for_hour, 'last_five_weeks' : last_five_weeks,
           'delay' : delay}


@view_config(route_name='comparison_employee', renderer='json',  permission='admin')
def comparison_employee(request):
    hash1_id,hash2_id = request.matchdict['id1'], request.matchdict['id2']
    
    hash1_group = request.db_session.query(Employee).\
                filter(Employee.by_user_id == get_verified_user_id(request)).\
                filter(or_(Employee.hash1 == hash1_id, Employee.hash2 == hash1_id)).\
                all()

    hash2_group = request.db_session.query(Employee).\
                filter(Employee.by_user_id == get_verified_user_id(request)).\
                filter(or_(Employee.hash1 == hash2_id, Employee.hash2 == hash2_id)).\
                all()

    # avg performance of grup for last x week
    weeks, weeks_for_hour = {}, {}
    weeks[1], weeks_for_hour[1] =  [[] for i in range(5)], [0 for i in range(5)]
    weeks[2], weeks_for_hour[2] =  [[] for i in range(5)], [0 for i in range(5)]

    #generate all arrivals by both group
    arrivals_group1 = request.db_session.query(Arrival).\
                filter(Arrival.employee_id.in_([e.id for e in hash1_group])).\
                all() 
    arrivals_group2 = request.db_session.query(Arrival).\
                filter(Arrival.employee_id.in_([e.id for e in hash2_group])).\
                all()

    for a1 in arrivals_group1:
        history_in_week = a1.how_many_weeks_back()
        weeks[1][history_in_week].append(a1.performance)
        weeks_for_hour[1][history_in_week] += a1.length()

    for a2 in arrivals_group2:
        history_in_week = a2.how_many_weeks_back()
        weeks[2][history_in_week].append(a2.performance)
        weeks_for_hour[2][history_in_week] += a2.length()
    #make average for each week 
    for which_week in weeks.keys():
        print(which_week)
        for i, week in enumerate(weeks[which_week]):
            if not len(week):
                weeks[which_week][i] = 0
            else:
                avg = sum(week) / float(len(week)) 
                weeks[which_week][i] = avg 


    # for i, week in enumerate(weeks[1]):
    #     if not len(week):
    #         weeks[1][i] = 0
    #     else:
    #         avg = sum(week) / float(len(week)) 
    #         weeks[1][i] = avg 

    # for i, week in enumerate(weeks[2]):
    #     if not len(week):
    #         weeks[2][i] = 0
    #     else:
    #         avg = sum(week) / float(len(week)) 
    #         weeks[2][i] = avg

    week_of_now = datetime.datetime.now().isocalendar()[1]
    last_five_weeks = []
    for i in range(5):
        last_five_weeks.append(week_of_now-i)

    #otocim poradie lebo chcem aby bolo na poslendom mieste terajsi tyzden..
    for which_week in weeks.keys():
        weeks[which_week] = weeks[which_week][::-1]
        weeks_for_hour[which_week] = weeks_for_hour[which_week][::-1]
    last_five_weeks = last_five_weeks[::-1]
    return{'weeks_of_performance' : weeks, 'weeks_for_hour': weeks_for_hour, 'last_five_weeks' : last_five_weeks}

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

@view_config(route_name='upload_csv',  renderer='project:templates/upload_csv.mako', permission='admin')
def upload_csv(request):
    return {}


@view_config(route_name='procces_csv', renderer='project:templates/registration.mako',  permission='admin')
def procces_csv(request):
    import os
    import csv
       # ``filename`` contains the name of the file in string format.
    #
    # WARNING: this example does not deal with the fact that IE sends an
    # absolute file *path* as the filename.  This example is naive; it
    # trusts user input.

    filename = request.POST['csv'].filename

    # ``input_file`` contains the actual file data which needs to be
    # stored somewhere.

    input_file = request.POST['csv'].file

    # Note that we are generating our own filename instead of trusting
    # the incoming filename since that might result in insecure paths.
    # Please note that in a real application you would not use /tmp,
    # and if you write to an untrusted location you will need to do
    # some extra work to prevent symlink attacks.

    file_path = os.path.join('/tmp', 'ok.csv' )

    # We first write to a temporary file to prevent incomplete files from
    # being used.

    temp_file_path = file_path + '~'
    output_file = open(temp_file_path, 'wb')

    # Finally write the data to a temporary file
    input_file.seek(0)
    while True:
        data = input_file.read(2<<16)
        if not data:
            break
        output_file.write(data)

    # If your data is really critical you may want to force it to disk first
    # using output_file.flush(); os.fsync(output_file.fileno())

    output_file.close()
    try:
        with open(temp_file_path, newline='') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=';', quotechar='|')
            for row in spamreader:
                meno = row[0]
                priezvisko = row[1]
                pozicia = row[2]
                print(meno)
                employee_position = request.db_session.query(Employees_type).filter(Employees_type.by_user_id == get_verified_user_id(request), Employees_type.name == pozicia).first()
                employee = Employee(get_user(request), meno, priezvisko, employee_position, 20, 'heslo', '', '', '')
                register_employee(employee, request)
                # print(', '.join(row))
    except:
        print('ups')
    return HTTPFound(location = request.route_url('employees'))

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


def register_employee(employee, request):
    DBSession.add(employee)
    DBSession.flush()
    #vytvorim QR code,,, 
    print(str(employee.id) * 30)
    qr = QRCode(version=8, error_correction=ERROR_CORRECT_L)
    qr.add_data(str(employee.id))
    qr.make()
    im = qr.make_image()
    im.save('qr_images/'  + str(employee.surname) + '.png')


@view_config(route_name='add_employee', renderer='json',  permission='admin', request_method="POST")
def add_employee(request):
    post=request.POST
    # if post['position'] == "Undefined":
    if post['position'] == '':
        employee_position = None
    else:
        employee_position = request.db_session.query(Employees_type).filter(Employees_type.by_user_id == get_verified_user_id(request), Employees_type.name == post['position']).first()
    

    employee = Employee(get_user(request), post['name'], post['surname'], employee_position, post['age'], post['password'], post['merital_status'], post['sex'], post['addresse'])
    register_employee(employee, request)
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
    DBSession.flush()
    DBSession.refresh(event)
    #leader bude ako task
    task = Task(event.leader, event, 0, 0, event.length())
    DBSession.add(task)

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

@view_config(route_name='add_hash_event', renderer='json' ,  permission='admin',)
def add_hash_event(request):
    id_event = request.matchdict['id_employee']
    id_hash = int(request.matchdict['id_hash'])

    hash_tag = request.db_session.query(Hash_employee).filter(Hash_employee.by_user_id == get_verified_user_id(request), Hash_employee.id == id_hash).first()
    print(hash_tag.name)
    event = request.db_session.query(Event).filter(Event.id == id_event).\
            filter(or_(Employee.hash1 == id_hash, Employee.hash2 == id_hash)).\
            first()

    if event is not None:
        return{'status': 'user have this hash tag already!!'} 
    if hash_tag == None:
        return{'status': 'hash tag dont exist'} 
    else:
        event = request.db_session.query(Event).filter(Event.id == id_event).first()
        if event == None:
            return{'status': 'employee dont exist'}
        if event.hash1 == None:
            event.hash1 = id_hash
            DBSession.flush()
            return{'status': 'ok'}
        elif event.hash2 == None:
            event.hash2 = id_hash
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

 # config.add_route('change_task','change_task/{id}/{performance}/{delay}')
@view_config(route_name='change_task', renderer='json',  permission='admin',)
def change_task(request):
    id_task = int(request.matchdict['id'])
    performance = request.matchdict['performance']
    delay = request.matchdict['delay']
    print(id_task)
    tasks = request.db_session.query(Task).all()
    for t in tasks:
        print(t.id)
    print(tasks)
    task = request.db_session.query(Task).filter(Task.id == id_task).first()
    task.delay = delay
    task.performance = performance
    DBSession.flush() 
    return{'status' : 'ok'}

@view_config(route_name='add_task', renderer='json',  permission='admin',)
def add_task(request):
    id_event = request.matchdict['id_event']
    name_of_employee = request.matchdict['name_of_employee']
    name = name_of_employee.split(' ')[0]
    surname = name_of_employee.split(' ')[1]
    print(name, len(surname))   
    employee = request.db_session.query(Employee).filter(Employee.name == name, Employee.surname == surname).first()
    event = request.db_session.query(Event).filter(Event.id == id_event).first()
    if employee is None:
        # ked ide do eventu do ktoreho nema pristup redirect..
        return{'status': 'you have not acces to do with this employee'} 
    if event.by_user_id != get_verified_user_id(request):
        # ked ide do eventu do ktoreho nema pristup redirect..
        return{'status': 'you have not acces to wotk with this event'} 

    exist_task = request.db_session.query(Task).filter(Task.event_id == id_event, Task.employee_id == employee.id).first()
    if exist_task is not None:
        return{'status': 'employee is in this task already'}  
    task = Task(employee, event, 0, 0, event.length())
    DBSession.add(task)
    # DBSession.add(event)
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





def get_verified_user_id(request):
    # return id aktualne prihalseneho usera

    user_name = authenticated_userid(request)
    print('#' * 40)
    print(user_name)
    return request.db_session.query(User.id).filter(User.meno == user_name).first()[0]


def get_user(request):
    user_name = authenticated_userid(request)
    return request.db_session.query(User).filter(User.meno == user_name).first()































@view_config(route_name='daily_evaluation', renderer='project:templates/daily.mako')
def daily(request):

    return{}


@view_config(route_name='jpie', renderer='json')
def jpie(request):
    date = request.matchdict['datum']
    category = request.matchdict['kategoria']
    bad_sen_of_articles = query.number_of_bad_sen_of_articles(request, date, category)
    happy_sen_of_articles = query.number_of_good_sen_of_articles(request, date, category)
    # happy_sen_of_feedbacks = query.number_of_good_sen_of_feedbacks(request, date)
    # bad_sen_of_feedbacks = query.number_of_bad_sen_of_feedbacks(request, date)
    # print(bad_sen_of_articles)  
    # print(bad_sen_of_feedbacks)
    vysledok={'Bad' : bad_sen_of_articles, 'Happy' : happy_sen_of_articles, }
              # 'Bad_feed': bad_sen_of_feedbacks, 'Happy_feed' : happy_sen_of_feedbacks }

    return vysledok
@view_config(route_name='jbar', renderer='json')
def jbar(request):
    date = request.matchdict['datum']
    category = request.matchdict['kategoria']
    vysledok={'skore' : query.query_one_day_for_bar(request, date, category) }

    return vysledok

@view_config(route_name='daily_evaluation', request_method="POST", renderer='project:templates/daily.mako')
def daily_evaluation(request):
    print(query.query_all_day(request))
    return{'text' : str(query.sentiment_for_specific_day(request))}


@view_config(route_name='top_ten', renderer='project:templates/topten.mako')
def top_ten(request):
    date = request.matchdict['datum']
    return{'pozitivne' : query.top_ten_positive_articles_in_day(request, date) , 'negativne' : query.top_ten_negative_articles_in_day(request, date)}

@view_config(route_name='graf', renderer='project:templates/graf.mako')
def graf(request):
    return{'vysledky' : query.query_all_day(request)}

@view_config(route_name='json', renderer='json')
def json_to_graf(request):
    zdroj = request.matchdict['zdroj']

    if zdroj == 'vsetky':
        return{'vysledky' : query.query_all_day (request)}
    elif (zdroj == 'ekonomika') or (zdroj == 'kultura') or (zdroj == 'sport'):
        return{'vysledky' : query.query_value_of_category(request, zdroj)}
    elif (zdroj == 'diskusie'):
        return{'vysledky' : query.query_all_day_feedback(request)}
    else:
        return{'vysledky' : query.sentiment_of_specific_type(request,zdroj)}

@view_config(route_name='json_den_clanky', renderer='json')
def json_to_text_of_node(request):
    zdroj = request.matchdict['zdroj']
    print(zdroj)
    datum = request.matchdict['den']
    if (zdroj == 'vsetky') or (zdroj == 'ekonomika') or (zdroj == 'kultura'):
        return{'pozitivne' : query.the_most_positive_article_in_day_with_category(request, datum, zdroj) ,'negativne' : query.the_most_negative_article_in_day_with_category(request, datum, zdroj) }
    else: 
        return{'pozitivne' : query.the_most_positive_article_in_day_with_medium(request, datum, zdroj) ,'negativne' : query.the_most_negative_article_in_day_with_medium(request, datum, zdroj) }


@view_config(route_name='home', request_method="POST", renderer='project:templates/home.mako')
def sentimental_hodnota_textu(obsah, request):
    
    obsah = request.POST['textarea']
    diac = request.POST['diac']
    diacritic = no_diacritic = True
    if diac == 'withDiac':
        no_diacritic = False
    elif diac == 'withoutDiac':
        diacritic = False
    #sentiment.analyza_textu(obsah, request, diacritic, no_diacritic)
    print('Slova: ')
    slova = sentiment.analyzuj_text_po_slovach(obsah, request, diacritic, no_diacritic)
    print('Vety: ')
    sentiment.analyzuj_text_po_vetach(obsah, request, diacritic, no_diacritic)
    print('Kusky: ')
    sentiment.analyzuj_text_po_kuskoch(obsah, request, diacritic, no_diacritic)
    print('pocet kladnych______________-')
    pocet_kladnych = 0
    pocet_zapornych = 0
    for slovo in slova.keys():
        if slova[slovo] > 0:
            pocet_kladnych += 1
        elif slova[slovo] < 0:
            pocet_zapornych += 1
    print('pocet kladnych slov')
    print(pocet_kladnych)
    print('pocet zapornych')
    print(pocet_zapornych)
    vysledok = sentiment.hodnota_textu(obsah, request, diacritic, no_diacritic)
    return{'text': str(obsah), 'pocet_kladnych': pocet_kladnych, 'pocet_zapornych': pocet_zapornych, 'vysledok': str(vysledok), 'typ': diac, 'slova': slova, 'kusky': list(sentiment.analyzuj_text_po_kuskoch(obsah, request, diacritic, no_diacritic).values())} 

@view_config(route_name='sme_parser', renderer='project:templates/home.mako')
def sme_parser(request):
    sme.parser(request)
    return{'text': 'some random text'}

@view_config(route_name='smediskusie_parser', renderer='project:templates/home.mako')
def smediskusie_parser(request):
    sme_diskusie.parser(request)
    return{'text': 'some random text'}

@view_config(route_name='sme_sk', renderer='project:templates/home.mako')
def www_sme_sk(request):
    sme_sk.parser(request)
    return{'text': 'some random text'}

@view_config(route_name='topky_parser', renderer='project:templates/home.mako')
def topky_parser(request):

    # tu mozes urcit datum dokedy parsovat,
    # napriklad ked posles tuto premennu:

    # parse_until = datetime.date.today() - datetime.timedelta(weeks=1)

    # tak sparsuje vsetky clanky za posledny tyzden, alebo ak chces cely rok tak
    # namiesto (weeks=1) das (days=365)
    # potom mozes parse_until poslat ako druhy argument do funkcie topky.parser()

    # ak ho tam neposles, parsuje sa klasicky - iba clanky s dnesnym datumom.

    topky.parser(request)
    return{'text': 'some random text'}

@view_config(route_name='pravda_parser', renderer='project:templates/home.mako')
def pravda_parser(request):
    #parse_until = datetime.date.today() - datetime.timedelta(weeks=1)
    pravda.parser(request)
    return{'text': 'some random text'}

@view_config(route_name='parse_all', renderer='project:templates/home.mako')
def all_parser(request):
    sme.parser(request)
    sme_diskusie.parser(request)
    sme_sk.parser(request)
    topky.parser(request)
    pravda.parser(request)
    return{'text': 'some random text'}
