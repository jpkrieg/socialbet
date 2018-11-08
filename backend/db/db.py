
from .db_config import get_db_config
import pymysql

########################## USERS ###########################################################
# I DONT NEED ANYTHING
def get_users():
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()
	
	sql = ""SELECT * FROM users;""
	cursor.execute(sql)


	res = []
	for row in cursor:
		res.append(row)

	db.close()
	return res

# I NEED USER_ID
def get_user(data):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()
	
	user_id = data['user_id']

	sql = "SELECT * FROM users WHERE uid = " + user_id + ";"
	cursor.execute(sql)

	res = []
	for row in cursor:
		res.append(row)

	db.close()

	return res

# I NEED ALL USER INFO
def create_user(data):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()


	user_id = data['user_id']
	first_name = data['first_name']
	last_name = data['last_name']
	birthdate = data['birthdate']
	phone = data['phone']
	sql = "INSERT INTO users VALUES ( " + user_id + ", " + first_name + ", " + last_name + ", " + 
	birthdate + ","  + phone + ");"

	cursor.execute(sql)
	res = []
	for row in cursor:
		res.append(row)


	db.close()

	return res

# I NEED ONLY USER_ID
def drop_user(data):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()

	user_id = data['user_id']
	sql = "DELETE FROM users WHERE user_id = " + user_id + ";"
	
	cursor.execute(sql)
	res = []
	for row in cursor:
		res.append(row)


	db.close()

	return res

########################## FRIENDS ###########################################################
# I NEED USER_ID ONLY
def get_friends(data):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()
	
	user_id = data['user_id']

	sql = "SELECT user2 FROM friends WHERE user1 = " + user_id + ";"

	cursor.execute(sql)

	res = []
	for row in cursor:
		res.append(row)


	db.close()

	return res

########################## GAMES ###########################################################
# I NEED NOTHING
def get_games(data):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()
	
	user_id = data['user_id']

	sql = "SELECT * FROM games;"

	cursor.execute(sql)

	res = []
	for row in cursor:
		res.append(row)


	db.close()

	return res

########################## BETS ###########################################################
def get_bets(direct, live):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()

	sql = "SELECT * FROM bets WHERE direct= " + direct + " " + "and live = " + live + ";"
	cursor.execute(sql)

	res = []
	for row in cursor:
		res.append(row)


	db.close()

	return res

# I NEED ALL BET INFO
def place_bet(data):
	db_config = get_db_config()
	db = pymysql.connect(db_config['host'], db_config['username'], db_config['password'], db_config['database_name'])
	cursor = db.cursor()

	bet_id = data['bet_id']
	contest_id = data['contest_id']
	time_placed = data['time_placed']
	game_time = data['game_time']
	num_comments = data['num_comments']
	message = data['message']
	ammount = data['ammount']
	user1 = data['user1']
	user2 = data['user2']
    direct = data['direct']
    accepted = data['accepted']

    sql = "INSERT INTO bets VALUES ( " + 
    bet_id + ", " + contest_id + ", " + time_placed + ", " + game_time + ", " + num_comments + ", " + 
    message + ", " + ammount + ", " + user1 + ", "+ user2 + ", " + direct + ", " + accepted + ";"

	cursor.execute(sql)
	
	res = []
	for row in cursor:
		res.append(row)


	db.close()

	return res
