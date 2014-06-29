import unicodedata
import re

def hodnota_textu(obsah, request, diacritic=True, no_diacritic=False):
    ohodnotene_slova = 0
    hodnota_celkove = 0
    priemer_celkove = 0
    
    slova = re.split(r"[\s\.,\!\?]+", obsah)
    
    for slovo in slova:
        slovo = slovo.strip('";:„')
        slovo=slovo.lower()
        if len(slovo) > 2:
            hodnota = wordValue(request, slovo, diacritic, no_diacritic)
            if hodnota != 0:
                #print(slovo + ' ' + str(hodnota))
                hodnota_celkove += hodnota
                ohodnotene_slova += 1
    
    if ohodnotene_slova != 0:
        return hodnota_celkove / ohodnotene_slova
    else:
        return 0

def remove_diacritic(input):
    '''
    Accept a unicode string, and return a normal string (bytes in Python 3)
    without any diacritical marks.
    '''
    output=unicodedata.normalize('NFKD', input).encode('ASCII', 'ignore')
    output=output.decode("utf-8")
    return output

def searchInDict(request,word, diacritic, no_diacritic):
    formDictionary = request.form_dic
    formDictionaryDiacritic = request.form_dic_diac
    valuedDictionary = request.value_dic
    valuedDictionaryDiacritic = request.value_dic_diac
    
    if diacritic and no_diacritic:
        value = int(valuedDictionaryDiacritic[formDictionaryDiacritic[word]])
        if value != 0:
            return value
        word = remove_diacritic(word)
        return int(valuedDictionary[formDictionary[word]])
    if diacritic:
        return int(valuedDictionaryDiacritic[formDictionaryDiacritic[word]])
    if no_diacritic:
        #word = remove_diacritic(word)
        return int(valuedDictionary[formDictionary[word]])

def wordValue(request,word, diacritic, no_diacritic):
    najKonstanta = 1.5
    sieKonstanta = 1.25
    stupen3 = "naj"
    stupen2_diacritic = "šie"
    stupen2 = "sie"
    
    #konstanty = {stupen3:najKonstanta,stupen2:sieKonstanta}
    if word.find(stupen3) == 0:
        return searchInDict(request, word, diacritic, no_diacritic) * najKonstanta

    if diacritic and word.find(stupen2_diacritic) > 0:
        return searchInDict(request, word, diacritic, no_diacritic) * sieKonstanta

    if no_diacritic and word.find(stupen2) > 0:
        return searchInDict(request, word, diacritic, no_diacritic) * sieKonstanta

    return searchInDict(request, word, diacritic, no_diacritic)