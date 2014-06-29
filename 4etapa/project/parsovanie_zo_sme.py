from bs4 import BeautifulSoup
import urllib.request as req
from urllib.parse import urlparse
from urllib.parse import urljoin
import sys

def build_url(url, page):
    return url.format(var=page)

def parse_sme_sk_old(source_links):
    articles_count = 0
    for page_link in source_links:
        for page in range(2): #pocet stran s clankami ktore ma navstivit pre jednu rubriku
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
        for page in range(2): #pocet stran s clankami ktore ma navstivit pre jednu rubriku
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
    
def process_article_link(link):
    try:
        html_text = req.urlopen(link)
        parse = BeautifulSoup(html_text)
        date = parse.body.find('b').text
        content = parse.body.find('div', attrs={'id' : 'itext_content'}).text
        title = parse.body.find('div', attrs={'id' : 'contenth'}).find('h1').text
        diskusie_url = parse.body.find('div', attrs={'class' : 'options'}).find('a')['href']
        print(diskusie_url)
        # print(date)t 
        # print(title)
        # print(content)
        print(title)
        print(link)
    except:
        print('something is worng')
    

def main():
    #http://www.sme.sk/mapa-stranky/ -z domova, zo zahranicia,sport,slovensko, svet, kultura
    articles_count = 0
    articles_links = []
    html_src_url_home = "http://www.sme.sk/rubrika.asp?rub=online_zdom&st={var}" #bez mainHeadtitle
    html_src_url_outland = "http://www.sme.sk/rubrika.asp?rub=online_zahr&st={var}" #bez mainHeadtitle
    html_src_url_culture = "http://kultura.sme.sk/hs/?st={var}"
    html_src_url_home_economy = "http://ekonomika.sme.sk/r/ekon_sfsr/slovensko.html?st={var}"
    html_src_url_world_economy = "http://ekonomika.sme.sk/r/ekon_st/svet.html?st={var}"
    html_src_url_music = "http://kultura.sme.sk/r/kult_hudba/hudba.html?st={var}"
    
    source_links = [html_src_url_home,
             html_src_url_outland,
             # html_src_url_culture,
             # html_src_url_home_economy,
             # html_src_url_world_economy,
             # html_src_url_music
            ]
    
    articles_links = get_articles_links_from_sme_sk(source_links)
    for article_link in articles_links:
        process_article_link(article_link)


    # process_article_link(articles_links[0])
    # process_article_link(articles_links[30])
    # process_article_link(articles_links[75])
    # process_article_link(articles_links[100])
    
    
    #htmltext = req.urlopen("http://bratislava.sme.sk/c/6877581/v-bratislave-sa-rodi-vela-deti-najvacsia-porodnica-nezvlada-napor.html").read()
    
    #soup = BeautifulSoup(htmltext)
    
    #date = soup.body.find('b').text
    #content = soup.body.find('div', attrs={'id' : 'itext_content'}).text
    #title = soup.body.find('div', attrs={'id' : 'contenth'}).find('h1').text
    
    
    

if __name__=='__main__':
    main()