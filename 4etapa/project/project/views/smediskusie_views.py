import urllib.request as req
from bs4 import BeautifulSoup
import re
import project.views.sentiment as sentiment
from project.models.feedback import Feedback
import datetime
from project.models import (
    DBSession,
    )

def parser(request):
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
        print('koniec')
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
        sentimental_hodnota_prispevku = sentiment.hodnota_textu(text_diskusie, request)
        diskusny_prispevok = Feedback(clanok, text_diskusie, sentimental_hodnota_prispevku, datetime.date.today())
        DBSession.add(diskusny_prispevok)
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
        text = title + content
        priemer_celkove = sentiment.hodnota_textu(text, request)
        clanok = Article(title, content, priemer_celkove, datetime.date.today(), 'sme.sk', 'sme.sk') 
        spracuj_data_do_db(clanok, request) 
        return clanok    
    except:
        print('nevadlidny format')

    #print(link)
#parsuj_diskusiu(zdroj)