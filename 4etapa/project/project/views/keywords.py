import re
import collections

def find(text):
	print(type(text))
	words = re.findall(r'\w+', text)
	
	cap_words = [word.lower() for word in words]
	counter = collections.Counter(cap_words)
	return counter.most_common()

