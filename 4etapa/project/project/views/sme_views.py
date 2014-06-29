
import urllib.request as req
from bs4 import BeautifulSoup
import project.views.sentiment as sentiment
import datetime
from project.models.article import Article
import project.views.data_do_db as data_do_db

def parser(request):
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
        author = soup.body.find('span', attrs={'class': 'article-author'}).text

        print(title)
        print(author)
        #print(content)
        text = title + content
        priemer_celkove = sentiment.hodnota_textu(text, request)
        clanok = Article(title, content, priemer_celkove, datetime.date.today(), 'blog.sme.sk', author)
        data_do_db.spracuj_data_do_db(clanok, request)