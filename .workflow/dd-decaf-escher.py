from _models import Command, Project

project = Project("code/dd-decaf/escher", [
    Command("build", ["npm run-script build"]),
    Command("watch", ["npm run-script watch"]),
    Command("start", ["npm run-script start"]),
    Command("clean", ["npm run-script clean"]),
    Command("test", ["npm run-script test"]),
])
