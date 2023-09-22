from flask import Flask, request, jsonify
from flask_restful import Resource, Api
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
from flask_cors import CORS
import os

app = Flask(__name__)
api = Api(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///messages.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
with app.app_context():
    if not os.path.exists(os.path.join('instance', 'messages.db')):
        db.create_all()

class Message(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    message = db.Column(db.String(255), nullable=False)
    timestamp = db.Column(db.DateTime, nullable=False, default=datetime.utcnow)
    author = db.Column(db.String(50), nullable=False)

    def __repr__(self):
        return f"Message('{self.message}', '{self.timestamp}', '{self.author}')"

class GetMessages(Resource):
    def get(self):
        messages = Message.query.all()
        mess_list = []
        for mess in messages:
            mess_list.append({'message': mess.message, 'timestamp': mess.timestamp.isoformat(), 'author': mess.author})
        return {'messages': mess_list}


class AddMessage(Resource):
    def post(self):
        data = request.get_json()
        message = data.get('message')
        author = data.get('author')
        if message and author:
            new_message = Message(message=message, author=author)
            db.session.add(new_message)
            db.session.commit()
            return {'message': 'Message added successfully'}, 201
        else:
               return {'message': 'Invalid request'}, 400
   

api.add_resource(GetMessages, '/messages')
api.add_resource(AddMessage, '/add-message')  # Corrected resource URL

CORS(app, origins="*")

if __name__ == "__main__":
    app.run( port=8000)