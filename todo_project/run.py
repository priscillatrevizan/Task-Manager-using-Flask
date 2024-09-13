import os
from todo_project import app

if __name__ == '__main__':
    host = os.getenv('FLASK_RUN_HOST', '127.0.0.1' if os.getenv('FLASK_ENV') == 'development' else '0.0.0.0')
    app.run(host=host, port=5000, debug=False)
