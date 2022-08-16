from _models import Command, Project

project = Project("code/cobrapy", [
    Command("test", ["python setup.py test"]),
])
