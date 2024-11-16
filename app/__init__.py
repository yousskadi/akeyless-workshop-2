from flask import Flask
from .akeyless_integration import init_app as init_db
import os

def create_app():
    app = Flask(__name__)
    
    # Set a secret key for Flask sessions
    app.secret_key = os.urandom(24)
    
    # Initialize the database pool
    init_db(app)
    
    from app import routes
    routes.init_app(app)
    
    return app

