from project.models import (
    DBSession,
    )

def spracuj_data_do_db(article, request):
    #pridane OBJEKTU article do db

    if is_article_morbid(article):
    	article.sentiment = -3

    DBSession.add(article)
    return article

def is_article_morbid(article):
	morbidne_slova = (
					'zahynul',
					'uhynul',
					'usmrtil',
					'usmrtenie',
					'zomrel',
					'úmrtie',
					'zabil',
					'zabijak',
					'zavraždil',
					'vražd',
					'vraždenie',
					'vrah',
					'tragick',
					'zosnul',
					'znasil',
					'†',
					'†',
					'✝',
					'✞',
					'✟',)
	for slovo in morbidne_slova:
		if article.title.find(slovo) != -1:
			return True
	return False