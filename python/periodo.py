import cx_Oracle

periodos = []

for i in range(24):
    periodos.append({'rango': 'hora', 'valor': i})

for i in range(60):
    periodos.append({'rango': 'minuto', 'valor': i})

xe = cx_Oracle.connect('IBDS/Gomby_0709@172.30.0.250/XE', encoding='ISO-8859-1')
cursor = xe.cursor()
cursor.bindarraysize = 10
cursor.executemany("insert into periodo(rango, valor) values (:rango, :valor)", periodos)
xe.commit()
cursor.close()
xe.close()