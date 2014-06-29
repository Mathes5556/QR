import urllib.request as req
from bs4 import BeautifulSoup
import project.views.sentiment as sentiment
import datetime
from project.models.article import Article
import project.views.data_do_db as data_do_db
from urllib.parse import urlparse
from urllib.parse import urljoin
import sys
from project.models.feedback import Feedback
from project.models import (
    DBSession,
    )
import re
import project.views.data_do_db as data_do_db

def build_url(url, page):
    return url.format(var=page)

def parse_sme_sk_old(source_links):
    articles_count = 0
    for page_link in source_links:
        for page in range(1): #pocet stran s clankami ktore ma navstivit pre jednu rubriku
            actual_page_link = build_url(page_link, page)
            html_txt = req.urlopen(actual_page_link)
            parse = BeautifulSoup(html_txt)
            for article in parse.body.findAll('h3'):
                if page_link == html_src_url_culture :
                    articles = article.findAll('a', attrs={'class' : 'mainHeadline'})
                    #print(articles, len(articles))
                    for link in article.findAll('a', attrs={'class' : 'mainHeadline'}):
                        parsing_url = urlparse(link['href'])
                        if parsing_url.netloc:
                            #print(link['href'])
                            articles_count += 1
                        else:
                            slashparts = build_url(page_link,page).split('/')
                            basename = '/'.join(slashparts[:3])
                            #print('-> '+urljoin(basename,link['href']))
                            articles_count += 1
                elif page_link == html_src_url_music :
                    for link in article.findAll('a'):
                        parsing_url = urlparse(link['href'])
                        if parsing_url.netloc:
                            #print(link['href'])
                            articles_count += 1
                        else:
                            #slashparts = build_url(page_link,page).split('/')
                            #basename = '/'.join(slashparts[:3])
                            #print('--> '+urljoin(basename,link['href']))
                            #print('=> '+urljoin(actual_page_link,link['href']))
                            articles_count += 1
                elif page_link == html_src_url_home_economy or page_link == html_src_url_world_economy :
                    ks = article.find('a')
                    if ks is not None :
                        articles_count += 1
                        #print("http://www.ekonomika.sme.sk"+ks['href'])
                else :
                    z = article.find('a')
                    if z is not None :
                        #print(z['href'])
                        articles_count += 1
           # html_source_url="http://www.sme.sk"+parse.body.find('div', attrs={'class' : 'otherart r'}).find('a')['href']
        #print(html_source_url)
    print(articles_count)


def get_articles_links_from_sme_sk(source_links):
    articles_count = 0
    articles_links = []
    for page_link in source_links:
        for page in range(1): #pocet stran s clankami ktore ma navstivit pre jednu rubriku
            actual_page_link = build_url(page_link, page+1)
            #print("Clanky pre url "+actual_page_link+" :")
            #pocet = 0
            html_txt = req.urlopen(actual_page_link)
            parse = BeautifulSoup(html_txt)
            for article in parse.body.findAll('h3'):
                articles = article.findAll('a', attrs={'class' : 'mainHeadline'})
                if len(articles) > 0:
                    for link in articles:
                        parsing_url = urlparse(link['href'])
                        if parsing_url.netloc:
                            articles_links.append(link['href'])
                            articles_count += 1
                            sys.stdout.write('.')
                            sys.stdout.flush()
                            #pocet += 1
                        else:
                            articles_links.append(urljoin(actual_page_link,link['href']))
                            articles_count += 1
                            sys.stdout.write('.')
                            sys.stdout.flush()
                            #pocet += 1
                else:
                    articles = article.findAll('a')
                    if len(articles) > 0:
                        if len(articles)!=1:
                            print('Neocakavane spravanie pri parsovani HTML')
                        for link in articles:
                            parsing_url = urlparse(link['href'])
                            if parsing_url.netloc:
                                articles_links.append(link['href'])
                                articles_count += 1
                                sys.stdout.write('.')
                                sys.stdout.flush()
                                #pocet += 1
                            else:
                                articles_links.append(urljoin(actual_page_link,link['href']))
                                articles_count += 1
                                sys.stdout.write('.')
                                sys.stdout.flush()
                                #pocet += 1
            #print("pocet clankov v danej rubrike "+ str(pocet))
            #print()
           # html_source_url="http://www.sme.sk"+parse.body.find('div', attrs={'class' : 'otherart r'}).find('a')['href']
    #print(articles_links)
    print(articles_count)
    return articles_links
    
def process_article_link(link,request):
    try:
        html_text = req.urlopen(link)
        parse = BeautifulSoup(html_text)
        try:
            date = parse.body.find('b').text
        except:
            print('neni datum')
        
        info = parse.body.find('p', attrs={'class' : 'autor_line'}).find('b').text
        

        # idem porovnat dnesny cas s casom z clanok
        today= datetime.date.today()
        dnesny_den_v_kalendari = str(today).split("-")[2]   
        # print(dnesny_den_v_kalendari)
        datum = info.split(' ')[1:]
        datum[(len(datum)-1):] = " "
        datum_string = "".join(datum)
        print(datum_string)
        print(datum_string)
        print(datum_string[len(datum_string)-1])

        datuum = datum_string[:3] + '0' +datum_string[3:]
        datuum = datuum[0:10]
        print(datuum)
        try:
            datum_do_db = datetime.datetime.strptime  (datuum, "%d.%m.%Y")
            print('---------')
            print(datum_do_db)
        except:
            print('nejde do db date')
        # print(datum_do_db)
        # print(datum_do_db)
        # print(datum_do_db)
        dnesny_den_z_clanku = datum_string.split('.')[0]
        # print(dnesny_den_z_clanku)

        # if dnesny_den_z_clanku == dnesny_den_v_kalendari:
        #     # print('toto je z dneska')
        #     dnesny = 1
        # else:
        #     # print('toto je vcerajsi')
        #     dnesny = 0
        # # ak to je dnesny tak posli do db
        # if dnesny == 1:
        content = parse.body.find('div', attrs={'id' : 'itext_content'}).text
        title = parse.body.find('div', attrs={'id' : 'contenth'}).find('h1').text
        kategory_for = link.split('.')
        kategoria = kategory_for[0].split('/')[2]
        text = title + content
        priemer_celkove = sentiment.hodnota_textu(text, request)
        clanok = Article(title, content, priemer_celkove, datum_do_db, 'sme.sk', 'sme.sk', kategoria, 'bla') 
        data_do_db.spracuj_data_do_db (clanok, request)
        try:
            diskusie_url = parse.body.find('div', attrs={'class' : 'options'}).find('a')['href']
            print(diskusie_url)
        except:
            print('nemam url diskusiu')
        try:
            parsuj_diskusiu(diskusie_url, request, clanok)
        except:
            print('asi nema diskusiu')
        # print('nema diskusia')
        # print(date)t 
        # print(title)
        # print(content)
        print(title)
        
        print(kategoria)
    except:
        print('nepodareny precitany clanok')

                    
    
def parsuj_diskusiu(zdroj, request, clanok = 0,start = 1):
    # try:
        print('citam diskuiu!!')
        if start == 1:
            aktualna_stranka = 1
        else:
            aktualna_stranka = zdroj.split('/')[5]


        kam_dalej = -1
        zaciatok_url = zdroj.split('.sk/')[0] + '.sk'
        html = req.urlopen(zdroj)
        soup = BeautifulSoup(html)
        stranka = int(aktualna_stranka)
        if stranka == 1:
            clanok_ku_ktoremu_diskusia_patri = soup.find("a", {"id": "back_to_article"})['href']
            overovanie_adresy = clanok_ku_ktoremu_diskusia_patri.split('.') 
            # clanok = nacitaj_clanok_nad_diskusiou(clanok_ku_ktoremu_diskusia_patri, request)  

        obsah = soup.find("div", {"id": "dxse_mainw_diskus"})
        nazvy = soup.findAll('span', id=re.compile('^subject_user_reaction_\d+'))
        texty = soup.findAll('span', id=re.compile('^text_user_reaction_\d+')) 
        for i in range(len(texty)):
            text_diskusie = nazvy[i].text + texty[i].text
            # print(text_diskusie)
            sentimental_hodnota_prispevku = sentiment.hodnota_textu(text_diskusie, request)
            diskusny_prispevok = Feedback(clanok, text_diskusie, sentimental_hodnota_prispevku, datetime.date.today())
            if DBSession.add(diskusny_prispevok):
                print('pradny prispevok')

    
        strankovanie = soup.find("div", {"class" : "dxse_commpages"})
        
        pages = strankovanie.findAll("a")
        for page in pages:
            if page.text == '>':
                kam_dalej = zaciatok_url + page['href']
        #print(kam_dalej)
        print(aktualna_stranka)
        if kam_dalej != -1:
            # print('--------------------------------------------------------------------------------------------------------')
            parsuj_diskusiu(kam_dalej, request, clanok, 0)  
            print('koniec citania diskusie')
    # except:
    #     print('neviem citat diusku')

        

def parser(request):
    #http://www.sme.sk/mapa-stranky/ -z domova, zo zahranicia,sport,slovensko, svet, kultura
    articles_count = 0
    articles_links = []
    html_src_url_home = "http://www.sme.sk/rubrika.asp?rub=online_zdom&st={var}" #bez mainHeadtitle
    html_src_url_outland = "http://www.sme.sk/rubrika.asp?rub=online_zahr&st={var}" #bez mainHeadtitle
    html_src_url_culture = "http://kultura.sme.sk/hs/?st={var}"
    html_src_url_home_economy = "http://ekonomika.sme.sk/r/ekon_sfsr/slovensko.html?st={var}"
    html_src_url_world_economy = "http://ekonomika.sme.sk/r/ekon_st/svet.html?st={var}"
    firmy = "http://ekonomika.sme.sk/r/ekon_pod/firmy.html?st={var}"
    html_src_url_music = "http://kultura.sme.sk/r/kult_hudba/hudba.html?st={var}"
    bratislava = "http://bratislava.sme.sk/hs/?st={var}"
    zahorie = "http://zahorie.sme.sk/hs/?st={var}"
    levice = "http://levice.sme.sk/hs/?st={var}"
    trnava = "http://trnava.sme.sk/hs/?st={var}"
    trencin = "http://trencin.sme.sk/hs/?st={var}"
    nitra = "http://nitra.sme.sk/hs/?st={var}"
    topolcany = "http://topolcany.sme.sk/hs/?st={var}"
    nove_zamky = "http://novezamky.sme.sk/hs/?st={var}"

    banska_bystrica = "http://bystrica.sme.sk/hs/?st={var}"
    kysuce = "http://kysuce.sme.sk/hs/?st={var}" 


    kosice = "http://kosice.korzar.sme.sk/hs/?st={var}"
    humenne = "http://humenne.korzar.sme.sk/hs/?st={var}"
    spis = "http://spisskanovaves.korzar.sme.sk/hs/?st={var}"
    poprad = "http://poprad.korzar.sme.sk/hs/?st={var}"
    stara_lubovna = "http://lubovna.korzar.sme.sk/hs/?st={var}"



    
    source_links = [ #html_src_url_home,
             # html_src_url_outland,
             html_src_url_culture,
             # html_src_url_home_economy,
             # html_src_url_world_economy,
             # firmy,
             # html_src_url_music,
             # levice,
             # nitra,
             # trencin,
             # zahorie,
             # nove_zamky,
             # banska_bystrica,
             # kysuce,
             # kosice,
             # poprad
             # bratislava



            ]
    
    articles_links = get_articles_links_from_sme_sk(source_links)
    for article_link in articles_links:
        process_article_link(article_link,request)
    
    print('koniec')
    # parsuj_diskusiu("http://www.sme.sk/diskusie/reaction_show.php?id_extern_theme=6893759&extern_type=sme-clanok", request)

    # process_article_link(articles_links[0])
    # process_article_link(articles_links[30])
    # process_article_link(articles_links[75])
    # process_article_link(articles_links[100])
    
    
    #htmltext = req.urlopen("http://bratislava.sme.sk/c/6877581/v-bratislave-sa-rodi-vela-deti-najvacsia-porodnica-nezvlada-napor.html").read()
    
    #soup = BeautifulSoup(htmltext)
    
    #date = soup.body.find('b').text
    #content = soup.body.find('div', attrs={'id' : 'itext_content'}).text
    #title = soup.body.find('div', attrs={'id' : 'contenth'}).find('h1').text
    
    
    

# if __name__=='__main__':
#     main()
