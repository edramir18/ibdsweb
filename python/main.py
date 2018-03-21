import cx_Oracle
import csv
import io
import json
import re
from datetime import datetime

xe = cx_Oracle.connect('IBDS/Gomby_0709@192.168.1.250/XE', encoding='ISO-8859-1')

def loadTransacciones ():
	cur = xe.cursor()
	cur.execute('select id, nombre, categoria from transaccion')
	t = {}
	for result in cur:
		cod = result[0]
		name = result[1]
		categoria = result[2]
		t[cod] = {"id": cod, "name": name, "categoria": categoria}
	cur.close()
	return t

def saveTransacciones(transList):
	cursor = xe.cursor()
	cursor.bindarraysize = 10
	cursor.setinputsizes(int, 50, 20)
	cursor.executemany("insert into transaccion(id, nombre, categoria) values (:1, :2, :3)", transList)
	xe.commit()
	cursor.close()

def loadCanales():
	cursor = xe.cursor()
	cursor.execute('select id, nombre from canal')
	t = {}
	for result in cursor:
		cod = result[0]
		name = result[1]
		t[name] = {"id": cod, "nombre": name}
	cursor.close()
	return t

def saveCanal(name):
	cursor = xe.cursor()
	cursor.execute("insert into canal(nombre) values ('"+ name + "')")
	xe.commit()
	cursor2 = xe.cursor()
	cursor2.execute('select id, nombre from canal')
	res = cursor2.fetchone()
	cursor.close()
	cursor2.close()	
	return {"id": res[0], "nombre": res[1]}

def loadUsuario(idUsuario, fecha):
	cursor = xe.cursor()
	cursor.execute("select id, fecha from usuario where id=:id", {'id': idUsuario})
	res = cursor.fetchone()
	cursor.close()
	if res:
		return {'id': res[0], 'fecha': res[1]}
	else:		
		cursor = xe.cursor()
		cursor.execute("INSERT into usuario(id, fecha) values( :1, :2)", (idUsuario, fecha))
		xe.commit()
		return {'id': idUsuario, 'fecha': fecha}

def updateUsuarios(usuarioList):
	usuarioArray = []
	for usuario in usuarioList:		
		usuarioArray.append((usuarioList[usuario]['fecha'], usuarioList[usuario]['id']))
	cursor = xe.cursor()
	cursor.bindarraysize = 100
	cursor.setinputsizes(cx_Oracle.DATETIME, int)
	cursor.executemany("UPDATE usuario SET fecha=:1 WHERE id=:2", usuarioArray)
	xe.commit()
	cursor.close()

def saveLogs(logsList):
	cursor = xe.cursor()
	cursor.bindarraysize = 100
	cursor.setinputsizes(int, int, int, 20, datetime)
	cursor.executemany("insert into logs(usuario, canal, transaccion, error, fecha) values (:1, :2, :3, :4, :5)", logsList)
	xe.commit()
	cursor.close()

transacciones = loadTransacciones()
transaccionList = []

canales = loadCanales()

usuarios = {}
logs = []

# jsonpathname = '/bdspnlog/'
csvfilename = 'logs/trans_ibank.log'
with io.open(csvfilename, 'r', encoding="ISO-8859-1") as csvfile:
	reader = csv.DictReader(csvfile, fieldnames=['canal', 'id', 'descripcion', 'usuario', 'fecha', 'error'])
	for row in reader:
		canal = row['canal']
		cod = int(row['id'])
		descripcion = row['descripcion']
		usuario = int(row['usuario'])
		fecha = datetime.strptime(row['fecha'], '%d-%m-%Y %H:%M')		
		error = row['error']
		if not cod in transacciones:
			transacciones[cod] = {'id': cod, 'nombre': descripcion}
			transaccionList.append((cod, descripcion, ''))
		if not canal in canales:
			canales[canal] = saveCanal(canal)
		if not usuario in usuarios:
			usuarios[usuario] = loadUsuario(usuario, fecha)
		else:
			usuarios[usuario]["fecha"] = fecha
		print(usuario, canales[canal]['id'], cod, error, fecha)
		logs.append((usuario, canales[canal]['id'], cod, error, fecha))

if len(transaccionList) > 0:	
	saveTransacciones(transaccionList)

updateUsuarios(usuarios)
saveLogs(logs)

xe.close