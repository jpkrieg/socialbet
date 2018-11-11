from flask import Flask, Blueprint
from .api_utils import create_http_response
from flask import request

app = Flask(__name__)
games = Blueprint('games', __name__)

@games.route('/api/v1/games/')
def get_games():
	# TODO: create games json object and return it
    # check authentication
    log_user = request.args.get('log_user')
    auth = request.args.get('auth')

    # make query
    results = get_games()

    # JSONify query
    retval = Flask.JSONify(results) #TODO

    # return
    return retval

