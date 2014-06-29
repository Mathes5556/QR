from pyramid.config import Configurator
from sqlalchemy import engine_from_config
from collections import defaultdict
from project.views.sentiment import remove_diacritic
from pyramid.renderers import JSON
from pyramid.events import (
    ContextFound,
    BeforeRender,
    )
import datetime
from .models import (
    DBSession,
    Base,

    )
from pyramid.authentication import AuthTktAuthenticationPolicy
from pyramid.authorization import ACLAuthorizationPolicy
from .models.security import groupfinder

def main(global_config, **settings):
    def prepare_request(event): #{{{
        """Add some additional information to the request object.
        """
        request = event.request
        request.settings = settings
        request.db_session = DBSession
       
        """
        request.userid = authenticated_userid(request)

        if request.userid is not None:
            request.user = request.db_session.query(User).\
                    filter(User.id == request.userid).\
                    first()
        else:
            request.user = None

        if request.registry and 'mailer' in request.registry:
            mailer = request.registry['mailer']
            request.mailer = mailer

        request.authenticator = Authenticator(request.db_session, request)
        """    
        """ This function returns a Pyramid WSGI application.
        """
    json_renderer = JSON()
    def datetime_adapter(obj, request):
        return obj.isoformat()
    json_renderer.add_adapter(datetime.datetime, datetime_adapter)
    json_renderer.add_adapter(datetime.date, datetime_adapter)

    
    engine = engine_from_config(settings, 'sqlalchemy.')
   
    DBSession.configure(bind=engine)
    Base.metadata.bind = engine
    authn_policy = AuthTktAuthenticationPolicy('sosecret', callback=groupfinder, hashalg='sha512')
    authz_policy = ACLAuthorizationPolicy()
    config = Configurator(settings=settings, root_factory='project.models.RootFactory')
    config.set_authentication_policy(authn_policy)
    config.set_authorization_policy(authz_policy)

    config.add_renderer('json', json_renderer)
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('sme_parser', '/smeparser')
    config.add_route('sme_sk', '/sme_sk')
    config.add_route('topky_parser', '/topkyparser')
    config.add_route('daily_evaluation','/daily')
    config.add_route('smediskusie_parser', '/smediskusie')
    config.add_route('pravda_parser', '/pravdaparser')
    config.add_route('graf', '/graf')
    config.add_route('json', '/json/{zdroj}')  #pyta si json do grafu
    config.add_route('json_den_clanky', '/json_den_clanky/{den}/{zdroj}')  #pyta si json do pri kliknuti na jednoltive 
    config.add_route('parse_all','/parse_all')
    config.add_route('piechart', '/piechart')
    config.add_route('jpie', '/jpie/{datum}/{kategoria}')  #json pre pie
    config.add_route('jbar','/jbar/{datum}/{kategoria}') #json pre barometer
    config.add_route('top_ten','/topten/{datum}')
    
    config.add_route('checkin','/checkin/{employee_id}')
    config.add_route('checkout','/checkout/{employee_id}/{performance}')
    config.add_route('events','/events')
    config.add_route('event','/event/{event_id}')
    config.add_route('edit_event','/event/edit/{event_id}')
    config.add_route('change_event','/{event_id}/name_of_event/goal/workplace/description')
    config.add_route('change_task','change_task/{id}/{performance}/{delay}')

    config.add_route('employees','/employees')
    config.add_route('employee','/employee/{employee_id}')
    config.add_route('employee-public','/employee-public/{employee_id}')
    
    config.add_route('customize','/customize')
    config.add_route('delete','delete/{type_to_delete}/{id}')
    config.add_route('add','add/{type_to_delete}/{name}')
    config.add_route('add_comparison','add_comparison/{type}/{hash1}/{hash2}')
    config.add_route('add_employee','add_employee')
    config.add_route('add_user','add_user')
    config.add_route('add_event','add_event')
    
    config.add_route('add_hash_employee','employee/add_hash_employee/{id_employee}/{id_hash}')
    config.add_route('add_hash_event','event/add_hash_event/{id_employee}/{id_hash}')
    config.add_route('delete_hash_employee','employee/delete_hash_employee/{id_employee}/{id_hash}')
    config.add_route('all_employee','all_employee')
    config.add_route('add_task','add_task/{id_event}/{name_of_employee}')
    config.add_route('delete_employee_from_task','event/delete_employee_from_task/{id_event}/{id_of_employee}')
    config.add_route('stats', '/stats')

    config.add_route('login', '/login')
    config.add_route('logout', '/logout')
    config.add_route('registration', '/registration')
    
    config.add_route('upload_csv', '/upload_csv')
    config.add_route('procces_csv', '/procces_csv')

    #stats..
    config.add_route('comparison_employee', '/comparison_employee/{id1}/{id2}')
    config.add_route('comparison_events', '/comparison_events/{id1}/{id2}')
    
    #qr-checker
    config.add_route('qr-checker', '/qr-checker')

    config.add_route('skuska','/skuska/{kolka}')
    config.add_route('skuska2','/skuska2')

    config.add_subscriber(prepare_request, ContextFound)
    config.scan() 
 
    return config.make_wsgi_app()

# from pyramid.config import Configurator


# def main(global_config, **settings):
#     """ This function returns a Pyramid WSGI application.
#     """
#     print('b')
#     config = Configurator(settings=settings)
#     config.include('pyramid_chameleon')
#     config.add_static_view('static', 'static', cache_max_age=3600)
#     config.add_route('home', '/')
#     config.scan()
#     return config.make_wsgi_app()

#   