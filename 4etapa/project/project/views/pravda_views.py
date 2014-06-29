import project.views.sentiment as sentiment
import project.views.data_do_db as data_do_db
from bs4 import BeautifulSoup
import datetime
import urllib.request as req
from project.models.article import Article
import re

def parser(request, parse_until=None):
    kategorie = ['domace','svet','ekonomika','regiony','cierna-kronika']
    regiony = ['bratislava','trnava','nitra','trencin','zilina', 'banska-bystrica','presov','kosice']

    for kategoria in kategorie:
        print('beham kategoriu ' + kategoria)
        page_number = 1

        cycle = True
        while cycle:
            if kategoria != 'regiony':
                region = ''
                zdroj = 'http://spravy.pravda.sk/'+kategoria+'/strana-'+str(page_number)+'/'  
                print('=listujem podstranku cislo ' + str(page_number) + ' (' + zdroj + ')')
                blogs = ziskaj_linky(zdroj)
                cycle = pobehaj_linky(blogs, kategoria, region, request, parse_until)
                page_number += 1
            else:
                for region in regiony:
                    print(' ( beham region ' + region + ' )')
                    region_page_number = 1
                    region_cycle = True
                    while region_cycle:
                        zdroj = 'http://spravy.pravda.sk/regiony/kategoria/'+region+'/strana-'+str(region_page_number)+'/'
                        print('=listujem podstranku cislo ' + str(region_page_number) + ' (' + zdroj + ')')
                        blogs = ziskaj_linky(zdroj)
                        region_cycle = pobehaj_linky(blogs, kategoria, region, request, parse_until)
                        region_page_number += 1
                break

    print(' = = = = Done = = = = ')
    return{'text': 'some random text'}

def ziskaj_linky(zdroj):
    try:
        html2 = req.urlopen(zdroj)
    except (req.URLError):
        print('URLError when loading ' + zdroj)
    else:
        soup2 = BeautifulSoup(html2)
        blogs = list(soup2.body.findAll('div', attrs={'class': 'article-preview'}))
        return blogs

def pobehaj_linky(blogs, kategoria, region, request, parse_until):
    if parse_until is None:
        compare_date = datetime.date.today()
    else:
        compare_date = parse_until
    
    for blog in blogs:
        odkaz = 'http://spravy.pravda.sk/' + blog.find('a')['href']
        kedy = blog.find('div', attrs={'class': 'time'}).string
        kedy = find_date(kedy)
        
        if kedy >= compare_date:
            load_content(odkaz, kedy, kategoria, region, request)
        else:
            return False
    return True

def load_content(source, kedy_date, kategoria, region, request):
    print(' =Parsing: ' + source)
    try:
        htmltxt = req.urlopen(source)
    except (req.URLError):
        print(' = result: error with link:')
        print(' = = ' +source)
    else:
        soup = BeautifulSoup(htmltxt)
        title = soup.body.find('div', attrs={'id': 'templavoila-clanoktelo_nadpis-inner'}).find('h1').string
        perex = soup.body.find('p', attrs={'class' : 'article-perex'}).string
        paragraphs = soup.body.findAll('p')
        text = perex
        for paragraph in paragraphs:
            if not paragraph.has_attr('comment-post'):
                text += paragraph.text
        priemer_celkovo = sentiment.hodnota_textu(text+title, request)
        article = Article(title, text, priemer_celkovo, kedy_date, 'pravda.sk', '', kategoria, region)
        data_do_db.spracuj_data_do_db(article, request)
        print(' = result: ok')

def find_date(kedy):
    kedy = kedy.strip()
    kedy = kedy[0:10]
    kedy = datetime.datetime.strptime(kedy, "%d.%m.%Y")
    return kedy.date()