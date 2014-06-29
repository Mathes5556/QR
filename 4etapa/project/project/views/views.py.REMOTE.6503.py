from pyramid.response import Response
from pyramid.view import view_config
from collections import defaultdict
from sqlalchemy.exc import DBAPIError
import unicodedata
from datetime import date
from project.models import (
    DBSession,
    )
from sqlalchemy import func

from project.models.article import Article
from project.models.feedback import Feedback
import re
from bs4 import BeautifulSoup
import urllib.request as req

import project.views.topky_views

@view_config(route_name='home', renderer='project:templates/home.mako')
def my_view(request):
    return{}

def remove_diacritic(input):
    '''
    Accept a unicode string, and return a normal string (bytes in Python 3)
    without any diacritical marks.
    '''
    output=unicodedata.normalize('NFKD', input).encode('ASCII', 'ignore')
    output=output.decode("utf-8")
    return output

@view_config(route_name='home', request_method="POST", renderer='project:templates/home.mako')
def spracuj(request):
    text = request.POST['textarea']
    vety = list(text.split('.'))  #TODO rozdelovat inteligetne na vety
    print(vety)
    pocet_ohodnotenych_slov_celkove = 0   
    hodnota_celkove = 0
    for veta in vety:

        pocet_ohodnotenych_slov_vo_vete = 0
        slova = re.split(r"[\s\.,\!\?]+", veta)
        hodnota = 0
        hodnota_vety = 0
         
        #priemer_vety = 0
        priemer_celkove = 0      
        for slovo in slova:    
            if len(slovo) >= 2:
                slovo=slovo.strip('";:„')
                slovo=remove_diacritic(slovo)                
                slovo=slovo.lower()
                hodnota = wordValue(request,slovo)
                #print(slovo)
                #print(hodnota)
                hodnota_vety = hodnota_vety + hodnota
                hodnota_celkove = hodnota_celkove + hodnota
                #print(hodnota_celkove)
                if hodnota != 0:
                    pocet_ohodnotenych_slov_vo_vete += 1
                    pocet_ohodnotenych_slov_celkove += 1
        #priemer_vety = hodnota_vety / pocet_ohodnotenych_slov_vo_vete
    if pocet_ohodnotenych_slov_celkove != 0:  
        #print(hodnota_celkove)  
        #print(pocet_ohodnotenych_slov_celkove)
        priemer_celkove = hodnota_celkove / pocet_ohodnotenych_slov_celkove
        print(priemer_celkove)
    return{'text': text, 'vysledok' : priemer_celkove}

@view_config(route_name='daily_evaluation', renderer='project:templates/home.mako')
def daily_evaluation(request):
    today = str(date.today())+" 00:00:00.000000"
    today_avarage=request.db_session.query(func.avg(Article.sentiment)).filter_by(date=today)
    print(today_avarage[0])
    return{'text' : "Dnesny primer: "+str(today_avarage[0])}
     
     
     
def searchInDict(request,word):
    formDictionary = request.form_dic
    valuedDictionary = request.value_dic
    value = valuedDictionary[formDictionary[word]]
    return int(value)


def wordValue(request,word):
    
    najKonstanta = 1.5
    sieKonstanta = 1.25
    stupen3 = "naj"
    stupen2 = "sie"
    #konstanty = {stupen3:najKonstanta,stupen2:sieKonstanta}
    if word.find(stupen3) == 0:
        return searchInDict(request,word)*najKonstanta
    elif word.find(stupen2) > 0:
        return searchInDict(request,word)*sieKonstanta
    else:
        return searchInDict(request,word)
@view_config(route_name='diskusia_parser', renderer='project:templates/home.mako')
def odstartuj_parser(request):
    daj_linky_najcitanejsich_diskusii(request)  
    return{'text': 'mihu', 'vysledok' : '5'}
def daj_linky_najcitanejsich_diskusii(request):
        zdroj = "http://diskusie.sme.sk/diskusie/"
        html = req.urlopen(zdroj)
        soup = BeautifulSoup(html)
        zoznam_linkov = soup.find("tbody")
        odkazy = list(zoznam_linkov.findAll("a"))
        for odkaz in odkazy:
            print(odkaz['href'])
            parsuj_diskusiu(odkaz['href'], request)

    #parsuj_diskusiu(odkazy[0]['href'])
        
def parsuj_diskusiu(zdroj, request, clanok = 0):
    aktualna_stranka = zdroj.split('/')[5]
    kam_dalej = -1
    zaciatok_url = zdroj.split('.sk/')[0] + '.sk'
    html = req.urlopen(zdroj)
    soup = BeautifulSoup(html)
    stranka = int(aktualna_stranka)
    if stranka == 1:
        clanok_ku_ktoremu_diskusia_patri = soup.find("a", {"id": "back_to_article"})['href']
        overovanie_adresy = clanok_ku_ktoremu_diskusia_patri.split('.') 
        clanok = nacitaj_clanok_nad_diskusiou(clanok_ku_ktoremu_diskusia_patri, request)  

    obsah = soup.find("div", {"id": "dxse_mainw_diskus"})
    nazvy = soup.findAll('span', id=re.compile('^subject_user_reaction_\d+'))
    texty = soup.findAll('span', id=re.compile('^text_user_reaction_\d+')) 
    for i in range(len(texty)):
        text_diskusie = nazvy[i].text + texty[i].text
        print(text_diskusie)
        sentimental_hodnota_prispevku = sentimental_hodnota_textu(text_diskusie, request)
        diskuny_prispevok = Feedback(clanok, text_diskusie, sentimental_hodnota_prispevku, datetime.date.today())
    strankovanie = soup.find("div", {"class" : "dxse_commpages"})
    pages = strankovanie.findAll("a")
    for page in pages:
        if page.text == '>':
            kam_dalej = zaciatok_url + page['href']
    #print(kam_dalej)
    print(aktualna_stranka)
    if kam_dalej != -1:
        print('--------------------------------------------------------------------------------------------------------')
        parsuj_diskusiu(kam_dalej, request, clanok)  
def nacitaj_clanok_nad_diskusiou(zdroj, request):
    try: 
        html_text = req.urlopen(zdroj)
        parse = BeautifulSoup(html_text)
        #date = parse.body.find('b').text
        content = parse.body.find('div', attrs={'id' : 'itext_content'}).text
        title = parse.body.find('div', attrs={'id' : 'contenth'}).find('h1').text
        
        #print(title)
        #print(content)
        clanok = spracuj_data_do_db(title, content, request) 
        return clanok    
    except:
        print('nevadlidny format')

    #print(link)
#parsuj_diskusiu(zdroj)




@view_config(route_name='sme_parser', renderer='project:templates/home.mako')
def sme_parser(request):
    #spracuj_data_do_db('pekny.',request)
    zdroj = "http://blog.sme.sk"
    html2 = req.urlopen(zdroj)
    soup2 = BeautifulSoup(html2)
    blogs = list(soup2.body.findAll('div', attrs={'class': 'blog_index_article'}))
    for blog in blogs:
        odkaz = blog.find('h2').find('a')['href']
        span = blog.findAll('span')[1].text
        info = span.split(',')
        kedy = info[1].split(' ')[1]
        print(kedy)
        if kedy == 'dnes':
            #print('ok')
            load_content_from_blog_sme(odkaz, request)
        else:
            break

    #toto je len skuska aby sa daco posielalo do .mako
    html_source_url = "http://slavikova.blog.sme.sk/c/330766/Coze-je-to-patdesiatka.html"
    htmltxt = req.urlopen(html_source_url)
    soup = BeautifulSoup(htmltxt)
    article = soup.body.find('div', attrs={'class': 'article-text'}).text
    return{'text': article}
def load_content_from_blog_sme(source, request):
    #TODO vyparsovat diskusie k danemu clanku
    if source == "http://fotky.sme.sk":
        pass
        print(source)
    else:
        html_source_url = source
        htmltxt = req.urlopen(html_source_url)
        soup = BeautifulSoup(htmltxt)
        print(source)
        perex = soup.body.find('div', attrs={'class' : 'article-perex'}).text
        article = soup.body.find('div', attrs={'class': 'article-text'}).text
        content = perex + article
        title = soup.body.find('h2').text
        print(title)
        #print(content)
        spracuj_data_do_db(title, article, request)

        # print(article)
        # perex = soup.body.find('div', attrs={'class' : 'article-perex'}).text
        # print(perex)
def spracuj_data_do_db(titulok, obsah, request):
    text = obsah + titulok
    priemer_celkove = sentimental_hodnota_textu(text, request)
    clanok = Article(titulok, obsah, priemer_celkove, datetime.date.today())
    DBSession.add(clanok)
    return clanok
def sentimental_hodnota_textu(obsah, request):
    vety = list(obsah.split('.'))  #TODO rozdelovat inteligetne na vety
    #print(vety)
    pocet_ohodnotenych_slov_celkove = 0   
    hodnota_celkove = 0
    for veta in vety:

        pocet_ohodnotenych_slov_vo_vete = 0
        slova = re.split(r"[\s\.,\!\?]+", veta)
        hodnota = 0
        hodnota_vety = 0
        priemer_celkove = 0      
        for slovo in slova:    
            if len(slovo) >= 2:
                slovo=slovo.strip('";:„')
                slovo=remove_diacritic(slovo)                
                slovo=slovo.lower()
                hodnota = wordValue(request,slovo)
                hodnota_vety = hodnota_vety + hodnota
                hodnota_celkove = hodnota_celkove + hodnota
                #print(hodnota_celkove)
                if hodnota != 0:
                    pocet_ohodnotenych_slov_vo_vete += 1
                    pocet_ohodnotenych_slov_celkove += 1
        #priemer_vety = hodnota_vety / pocet_ohodnotenych_slov_vo_vete
    if pocet_ohodnotenych_slov_celkove != 0:  
        priemer_celkove = hodnota_celkove / pocet_ohodnotenych_slov_celkove
        print(priemer_celkove)
    clanok = Article(titulok, obsah, priemer_celkove, date.today())
    DBSession.add(clanok)

    return{'text': text, 'vysledok' : priemer_celkove}

@view_config(route_name='topky_parser', renderer='project:templates/home.mako')
def topky_parser(request):
    project.views.topky_views.topky_parse(request)
    return{'text': 'some random text'}
