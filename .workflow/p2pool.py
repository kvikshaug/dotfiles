from _models import Command, Project

project = Project("code/p2pool", [
    Command("clean", [
        "rm -rf p2pool pkg src"
    ]),
])
