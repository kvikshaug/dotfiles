from _models import Command, Project

project = Project("/home/kvikshaug", [
    Command("cp", [
        "git ci -m updates",
        "git push -f",
    ]),
])
