from bs4 import BeautifulSoup
import urllib.request as req
import re
zdroj = "http://vranov.korzar.sme.sk/diskusie/2174429/1/Z-Domase-vytiahli-zrejme-rekordneho-sumca.html"
def daj_linky_najcitanejsich_diskusii():
    zdroj = "http://diskusie.sme.sk/diskusie/"
    html = req.urlopen(zdroj)
    soup = BeautifulSoup(html)
    zoznam_linkov = soup.find("tbody")
    odkazy = list(zoznam_linkov.findAll("a"))
    for odkaz in odkazy:
        print(odkaz['href'])
        parsuj_diskusiu(odkaz['href'])

    #parsuj_diskusiu(odkazy[0]['href'])
        
def parsuj_diskusiu(zdroj):
    aktualna_stranka = zdroj.split('/')[5]
    kam_dalej = -1
    zaciatok_url = zdroj.split('.sk/')[0] + '.sk'
    html = req.urlopen(zdroj)
    soup = BeautifulSoup(html)
    stranka = int(aktualna_stranka)
    if stranka == 1:
        clanok_ku_ktoremu_diskusia_patri = soup.find("a", {"id": "back_to_article"})['href']
        overovanie_adresy = clanok_ku_ktoremu_diskusia_patri.split('.') 
        nacitaj_clanok_nad_diskusiou(clanok_ku_ktoremu_diskusia_patri)  
    obsah = soup.find("div", {"id": "dxse_mainw_diskus"})
    nazvy = soup.findAll('span', id=re.compile('^subject_user_reaction_\d+'))
    texty = soup.findAll('span', id=re.compile('^text_user_reaction_\d+')) 
    for i in range(len(nazvy)):
        pass
        #print(nazvy[i].text)
        #print(texty[i].text)

        #TODO tuto to budem posielat do funckie ktora to posle do db atd..

    strankovanie = soup.find("div", {"class" : "dxse_commpages"})
    pages = strankovanie.findAll("a")
    for page in pages:
        if page.text == '>':
            kam_dalej = zaciatok_url + page['href']
    #print(kam_dalej)
    print(aktualna_stranka)
    if kam_dalej != -1:
        print('--------------------------------------------------------------------------------------------------------')
        parsuj_diskusiu(kam_dalej)  
def nacitaj_clanok_nad_diskusiou(zdroj):
    try: 
        html_text = req.urlopen(zdroj)
        parse = BeautifulSoup(html_text)
        #date = parse.body.find('b').text
        content = parse.body.find('div', attrs={'id' : 'itext_content'}).text
        title = parse.body.find('div', attrs={'id' : 'contenth'}).find('h1').text
        # print(date)t 
        print(title)
        print(content)
    except:
        print('nevadlidny format')
    #print(link)
#parsuj_diskusiu(zdroj)
daj_linky_najcitanejsich_diskusii()

