from _models import Command, Project

project = Project("code/benssalong.no", [
    Command("start", ["PASSWORD=dev FLASK_ENV=development FLASK_APP=benssalong.py flask run"]),
    Command("black", ["black ."]),
])
