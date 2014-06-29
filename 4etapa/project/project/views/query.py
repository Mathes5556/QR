from sqlalchemy import func
from datetime import date
import datetime

from project.models import (
    DBSession,
    )

from project.models.article import Article
from project.models.feedback import Feedback


def sentiment_for_specific_day(request):
    print("Vybrane obdobie: "+request.POST['textarea'])
    day = request.POST['textarea']+" 00:00:00.000000"
    day_avg=request.db_session.query(func.avg(Article.sentiment)).filter_by(date=day).first()
    day_count=request.db_session.query(func.count(Article.id)).filter_by(date=day).first()
    print("Priemer clankov za vybrane obdobie: "+ str(day_avg[0]))
    print("Pocet clankov za vybrane obdobie: "+str(day_count[0]))
    print("1  "+str(sentiment_of_specific_type(request)))
    return day_avg[0]

def number_of_articles_per_specific_day(request):
    day=request.POST['textarea']+" 00:00:00.000000"
    day_count=request.db_session.query(func.count(Article.id)).filter_by(date=day).first()
    return day_count[0]

def query_all_day(request):
    from time import gmtime, strftime
    dnesok = strftime("%Y-%m-%d", gmtime())
    dnesok2 = strftime("%A", gmtime())
    print('*' * 250)
    print(dnesok)
    obdobie = datetime.date.today() - datetime.timedelta(weeks=1)
    medziobdobie = obdobie - datetime.timedelta(weeks=2)
    print('*' * 250)
    all_day=request.db_session.query(Article.date,func.avg(Article.sentiment)).\
    filter(Article.date  >=  medziobdobie ).order_by(Article.date).group_by(Article.date).all()
    return all_day

def query_one_day_for_bar(request, date, category):
    if category == 'vsetky':
        if date != 'vsetky':
            one_day=request.db_session.query(Article.date,func.avg(Article.sentiment)).\
            filter(Article.date == date).order_by(Article.date).group_by(Article.date).all()
            return one_day[0]
        else:
            one_day=request.db_session.query(func.avg(Article.sentiment)).\
           all()
            return one_day[0]
    else:
         media = ['topky.sk', 'sme.sk', 'pravda.sk', 'blog.sme.sk'] 
         if category in media:
            if date != 'vsetky':
                one_day=request.db_session.query(Article.date,func.avg(Article.sentiment)).\
                filter(Article.date == date, Article.type == category).order_by(Article.date).group_by(Article.date).all()
                return one_day[0] 
         else:
            if date != 'vsetky':
                one_day=request.db_session.query(Article.date,func.avg(Article.sentiment)).\
                filter(Article.date == date, Article.kategoria == category).order_by(Article.date).group_by(Article.date).all()
                return one_day[0]

        
def query_all_day_feedback(request):
    all_day_feedbacks=request.db_session.query(Feedback.date,func.avg(Feedback.sentiment)).\
    filter(Feedback.sentiment!=0.0).group_by(Feedback.date).all()
    return all_day_feedbacks

def sentiment_for_specific_article(request):
    specific_id=1
    article = request.db_session.query(Article.sentiment).filter_by(id=specific_id).first()
    return article[0]

def feedbacks_sentiment_for_specific_article(request): 
    specific_id=33 #TODO DOOKONCIT 
    article = request.db_session.query(func.avg(Feedback.sentiment)).\
    filter(Feedback.article_id==specific_id, Feedback.sentiment!=0.0).first()
    return article[0]

def number_of_feedbacks_for_article(request):
    specific_id=33
    number_of_feedbacks = request.db_session.query(func.count(Feedback.id)).\
    filter(Feedback.article_id==specific_id).first()
    return number_of_feedbacks[0]

def number_of_article_for_specific_day_and_type(request):
    specific_id = 33
    tp='sme.sk'
    number_of_feedbacks = request.db_session.query(func.count(Feedback.id)).\
    filter(Feedback.id==specific_id,Feedback.type==tp).first()
    return number_of_feedbacks[0]

def sentiment_of_specific_type(request, jtype):
    all_day=request.db_session.query(Article.date,func.avg(Article.sentiment)).\
    filter(Article.type==jtype).group_by(Article.date).all()
    return all_day

def number_of_good_sen_of_articles(request, date, category):
    if (category == 'vsetky'):
        if(date == 'vsetky'):
            mood=request.db_session.query(func.count(Article.id)).\
            filter(Article.sentiment>=0).first()
        else:
            mood=request.db_session.query(func.count(Article.id)).\
            filter(Article.sentiment>=0, Article.date == date).first()
        return mood[0]
    else:
        media = ['topky.sk', 'sme.sk', 'pravda.sk', 'blog.sme.sk']
        if category in media:
            if(date == 'vsetky'):
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment>=0, Article.type == category).first()
            else:
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment>=0, Article.date == date, Article.type == category).first()
            return mood[0]
        else:
            if(date == 'vsetky'):
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment>=0, Article.kategoria == category).first()
            else:
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment>=0, Article.date == date, Article.kategoria == category).first()
            return mood[0]



def number_of_bad_sen_of_articles(request, date, category):
    if (category == 'vsetky'):
        if(date == 'vsetky'):
            mood=request.db_session.query(func.count(Article.id)).\
            filter(Article.sentiment<=0).first()
            return mood[0]
        else:
            mood=request.db_session.query(func.count(Article.id)).\
            filter(Article.sentiment<=0, Article.date == date).first()
            return mood[0]
    else:
        media = ['topky.sk', 'sme.sk', 'pravda.sk', 'blog.sme.sk']
        if category in media: 
            if(date == 'vsetky'):
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment<=0, Article.type == category).first()
                return mood[0]
            else:
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment<=0, Article.date == date, Article.type == category).first()
                return mood[0]
        else:
            if(date == 'vsetky'):
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment<=0, Article.kategoria == category).first()
                return mood[0]
            else:
                mood=request.db_session.query(func.count(Article.id)).\
                filter(Article.sentiment<=0, Article.date == date, Article.kategoria == category).first()
                return mood[0]

def number_of_good_sen_of_feedbacks(request, date):
    if(date == 'vsetky'):
        mood=request.db_session.query(func.count(Feedback.id)).\
        filter(Feedback.sentiment>=0, Feedback.sentiment!=0.0).first()
        return mood[0]
    else:
        mood=request.db_session.query(func.count(Feedback.id)).\
        filter(Feedback.sentiment>=0, Feedback.sentiment!=0.0, Feedback.date == date).first()
        return mood[0]

def number_of_bad_sen_of_feedbacks(request, date):
    if(date == 'vsetky'):
        mood=request.db_session.query(func.count(Feedback.id)).\
        filter(Feedback.sentiment<=0,Feedback.sentiment!=0.0).first()
        return mood[0]
    else:
        mood=request.db_session.query(func.count(Feedback.id)).\
        filter(Feedback.sentiment<=0, Feedback.sentiment!=0.0, Feedback.date == date).first()
        return mood[0]

def the_most_positive_article_in_day(request, date):
    if(date == 'vsetky'):
        article = request.db_session.query(Article.sentiment,Article.title).\
        filter(Article.date == datetime.date.today()).order_by(Article.sentiment.desc()).first()
        return article

def the_most_positive_article_in_day_with_medium(request, date, medium):
    article = request.db_session.query(Article.sentiment,Article.title).\
    filter(Article.date == date, Article.type == medium).order_by(Article.sentiment.desc())[0:2]
    return article

def the_most_negative_article_in_day_with_medium(request, date, medium):
    article = request.db_session.query(Article.sentiment,Article.title).\
    filter(Article.date == date, Article.type == medium).order_by(Article.sentiment)[0:2]
    return article

def the_most_positive_article_in_day_with_category(request, date, category):
    if category == 'vsetky':
        article = request.db_session.query(Article.sentiment,Article.title).\
        filter(Article.date == date).order_by(Article.sentiment.desc())[0:2 ]
    else:
        article = request.db_session.query(Article.sentiment,Article.title).\
        filter(Article.date == date, Article.kategoria == category).order_by(Article.sentiment.desc())[0:2]
    return article

def the_most_negative_article_in_day_with_category(request, date, category):
    if category == 'vsetky':
        article = request.db_session.query(Article.sentiment,Article.title).\
        filter(Article.date == date).order_by(Article.sentiment)[0:2]
    else:
        article = request.db_session.query(Article.sentiment,Article.title).\
        filter(Article.date == date, Article.kategoria == category).order_by(Article.sentiment)[0:2]
    return article
# def the_most_negative_article_in_day(request, date):
#     date2 = datetime.date.today()
#     article = request.db_session.query(func.min(Article.sentiment),Article.title).\
#     filter(Article.date == date2).first()
#     # print(article)
#     return article
    
def query_value_of_category(request, category):
    all_days = request.db_session.query(Article.date,func.avg(Article.sentiment)).\
    filter(Article.kategoria == category).group_by(Article.date).all()
    return all_days

def top_ten_positive_articles_in_day(request, date):
    articles = request.db_session.query(Article.sentiment,Article.title).\
    filter(Article.date == date).order_by(Article.sentiment.desc())[0:10]
    return articles

def top_ten_negative_articles_in_day(request, date):
    articles = request.db_session.query(Article.sentiment,Article.title).\
    filter(Article.date == date).order_by(Article.sentiment)[0:10]
    return articles


# def sentiment_by_town(request, date):
#     articles = request.db_session.query(Article.kategoria,func.avg(Article.sentiment)).\
#     filter(Article.date == date).
