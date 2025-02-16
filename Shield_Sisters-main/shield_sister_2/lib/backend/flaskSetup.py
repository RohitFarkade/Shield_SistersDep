from flask import Flask, request, jsonify
from flask_bcrypt import Bcrypt
from pymongo import MongoClient

app = Flask(__name__)
bcrypt = Bcrypt(app)

# MongoDB setup
client = MongoClient('mongodb://127.0.0.1:27017')
db = client['flutter_app']
users = db['users']

# User registration endpoint
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    hashed_password = bcrypt.generate_password_hash(data['password']).decode('utf-8')
    user = {'name': data['name'],'email': data['email'], 'password': hashed_password,'number': data['number']}
    users.insert_one(user)
    return jsonify({'message': 'User registered successfully'}), 201

# User login endpoint
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    user = users.find_one({'email': data['email']})
    if user and bcrypt.check_password_hash(user['password'], data['password']):
        return jsonify({'message': 'Login successful'}), 200
    return jsonify({'message': 'Invalid credentials'}), 401

if __name__ == '__main__':
    app.run(debug=True)
