import unicodedata
import re



def hodnota_textu(obsah, request, diacritic=True, no_diacritic=False):
    ohodnotene_slova = 0
    hodnota_celkove = 0
    priemer_celkove = 0
    
    slova = re.split(r"[\s\.,\!\?]+", obsah)
    return hodnota_zo_slov(slova, request, diacritic, no_diacritic)

def hodnota_zo_slov(slova, request, diacritic, no_diacritic, analyzuj=False):
    ohodnotene_slova = 0
    hodnota_celkove = 0
    priemer_celkove = 0
    vysledok = dict()
    trendy = {'Fico': 0, 'a': 0}
    for slovo in slova:
        hodnota = wordValue(request, slovo, diacritic, no_diacritic)
        if hodnota != 0:
            #print(slovo, hodnota)
            vysledok[slovo] = hodnota
            hodnota_celkove += hodnota
            ohodnotene_slova += 1
        if slovo in trendy.keys():
            trendy[slovo] += 1 

    for slovo, hodnota in trendy.items():
        if hodnota > 3:
            # posli_clanok_k_teme(obsah)
            print('*' * 250)
            print(trendy)
            print('*' * 250)


    if (analyzuj):
        print(vysledok)
        return vysledok

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
    
    word = word.strip('";:„')
    word = word.lower()
    if len(word) <= 2:
        return 0
    if word.find(stupen3) == 0:
        return searchInDict(request, word, diacritic, no_diacritic) * najKonstanta

    if diacritic and word.find(stupen2_diacritic) > 0:
        return searchInDict(request, word, diacritic, no_diacritic) * sieKonstanta

    if no_diacritic and word.find(stupen2) > 0:
        return searchInDict(request, word, diacritic, no_diacritic) * sieKonstanta

    return searchInDict(request, word, diacritic, no_diacritic)



def analyzuj_text_po_slovach(obsah, request, diacritic, no_diacritic):
    slova = re.split(r"[\s\.,\!\?]+", obsah)
    return hodnota_zo_slov(slova, request, diacritic, no_diacritic, True)

def analyzuj_text_po_vetach(obsah, request, diacritic, no_diacritic):
    sentences = [s.strip() for s in re.split('[\.\?!]' , obsah) if s]
    vysledok = dict()
    i = 0
    for sentence in sentences:
        hodnota = hodnota_textu(sentence, request, diacritic, no_diacritic)
        if (hodnota != 0):
            vysledok[sentence] = hodnota
            i += 1
    print(vysledok)
    return vysledok

def analyzuj_text_po_kuskoch(obsah, request, diacritic, no_diacritic, kusov=0):
    slova = re.split(r"[\s\.,\!\?]+", obsah)
    word_count = len(slova)

    #defaultne bude jeden kus dlzky 100 slov, davame ale limit na pocet vypoctov -> 30
    if kusov == 0:

        kusov = word_count // 100
        if kusov == 0:
            kusov = 1
        elif kusov > 30:
            kusov = 30

    #print(word_count)
    vysledok = dict()
    one_part = word_count // kusov
    part = 0
    for kus in range(kusov):
        new_part = part+one_part
        if (word_count - new_part) < one_part:
            new_part = word_count
        else:
            new_part = part+one_part

        #print('new: ', new_part)
        hodnota = hodnota_zo_slov(slova[part:new_part], request, diacritic, no_diacritic)

        #print('hodnota: ',hodnota)
        part += one_part
        vysledok[kus]= hodnota
    print(vysledok)
    return vysledok