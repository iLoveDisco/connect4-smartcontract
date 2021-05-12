from connectfour import *

import hashlib
import json
from time import time
from urllib.parse import urlparse
from uuid import uuid4

import requests
from flask import Flask, jsonify, request
from flask_cors import CORS

# Instantiate the Node
app = Flask(__name__)
CORS(app)
app.config['JSONIFY_PRETTYPRINT_REGULAR'] = False

game = Game()

@app.route('/insert', methods=['POST'])
def insert():
    values = request.get_json()

    # Check that the required fields are in the POST'ed data
    required = ['column_number','color']
    if not all(k in values for k in required):
        return 'Missing values. color needs to be either "Y" or "R"', 400

    msg1 = game.insert(int(values['column_number']), values['color'])
    response = {'board_string':msg1}
    return jsonify(response), 201

if __name__ == '__main__':
    from argparse import ArgumentParser

    parser = ArgumentParser()
    parser.add_argument('-p', '--port', default=5000, type=int, help='port to listen on')
    args = parser.parse_args()
    port = args.port

    app.run(host='0.0.0.0', port=port)