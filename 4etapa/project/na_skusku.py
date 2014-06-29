import datetime

today= datetime.date.today()
# dnesok = today.split('-')
dnesny_den_v_kalendari = str(today).split("-")[2]
print(dnesny_den_v_kalendari)