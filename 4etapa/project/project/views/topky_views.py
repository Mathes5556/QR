import project.views.sentiment as sentiment
import project.views.data_do_db as data_do_db
from bs4 import BeautifulSoup
import datetime
import urllib.request as req
from project.models.article import Article
import re

def parser(request, parse_until=None):
    #ocislovane kategorie pre topky.sk
    kategorie = {'10':'domace', '11':'zahranicne', '15':'prominenti', '7':'ekonomika','5':'kultura'}
    for kategoria in kategorie.keys():
        print('beham kategoriu ' + kategorie[kategoria])
        page_number = 1
        kedy = 'pred 2 minútami'
        not_last_article = True

        while(not_last_article):
            zdroj = 'http://www.topky.sk/se/'+kategoria+'/'+str(page_number)+'/'
            print('=listujem podstranku cislo ' + str(page_number) + ' (' + zdroj + ')')
            try:
                html2 = req.urlopen(zdroj)
            except (req.URLError):
                print('URLError when loading ' + zdroj)
            else:
                soup2 = BeautifulSoup(html2)
                blogs = list(soup2.body.findAll('div', attrs={'class': 'entry'}))
                
                for blog in blogs:
                    odkaz = 'http://www.topky.sk' + blog.find('h3').find('a')['href']
                    kedy = blog.p.text
                    kedy = find_date(kedy)
                    if parse_until is None:
                        compare_date = datetime.date.today()
                    else:
                        compare_date = parse_until

                    if kedy is None or kedy >= compare_date:
                        load_content(odkaz, kedy, kategorie[kategoria], request)
                    else:
                        not_last_article = False
                page_number += 1

    print(' = = = = Done = = = = ')
    return{'text': 'some random text'}

def load_content(source, kedy_date, kategoria, request):
    print(' =Parsing: ' + source)
    try:
        htmltxt = req.urlopen(source)
    except (req.URLError):
        print(' = result: error with link:')
        print(' = = ' +source)
    else:
        soup = BeautifulSoup(htmltxt)
        perex = soup.body.find('header', attrs={'class' : 'perex'}).find('p').string
        paragraphs = soup.body.find('div', attrs={'id': 'article_body'}).findAll('p')
        town = find_town(perex)
        title = soup.body.find('h1').string
        text = perex
        for paragraph in paragraphs:
            text += paragraph.text
        priemer_celkovo = sentiment.hodnota_textu(text+title, request, True, False)

        article = Article(title, text, priemer_celkovo, kedy_date, 'topky.sk', '', kategoria, town)
        data_do_db.spracuj_data_do_db(article, request)
        print(' = result: ok')

def find_date(kedy):
    now = datetime.datetime.now()

    kedy = str(kedy)
    kedy = kedy.strip()
    pred = kedy.split()
    
    try:
        if pred[0].lower() == 'aktualizované':
            del pred[0]
        if pred[0] == 'pred':
            if pred[1] == 'hodinou':
                return datetime.date.today()
            elif pred[2] == 'minútami':
                return datetime.date.today()
            elif pred[2] == 'hodinami':
                if int(pred[1]) < now.hour:
                    return datetime.date.today()
                else:
                    return datetime.date.today() - datetime.timedelta(days=1)
        if pred[0] == 'včera':
                return datetime.date.today() - datetime.timedelta(days=1)
        kedy = kedy[0:10]
        kedy = datetime.datetime.strptime(kedy, "%d.%m.%Y")
        return kedy.date()
    except:
        print(' = =btw, unknown date "' + kedy + '"')
        return None

# mesto je velkymi pismenami a moze byt viacslovne,
# nacitavame po znakoch kym nenarazime nepismenovy znak ako je pomlcka
# mozny je aj tvar BRATISLAVA/KOSICE, vtedy berieme do uvahy druhe mesto.

def find_town(perex):
    try:
        str_list = []
        for c in perex:
            if c.isupper() or c == ' ' or c == '/':
                if c == '/':
                    str_list = []
                else:
                    str_list.append(c)
            else:
                break
        town = ''.join(str_list)

        if len(town) < 3:
            return ''
        town = sentiment.remove_diacritic(town)
        return town.lower()
    except:
        print(' = =btw, cannot find town in' + perex)
        return ''