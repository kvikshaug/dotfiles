from _models import Command, Project

project = Project("code/tv", [
    Command("qa", [
        "black --check src tests",
        "flake8 src tests",
        "isort --recursive --check-only src tests",
    ]),
    Command("format", ["black src tests", "isort --recursive src tests",]),
])
