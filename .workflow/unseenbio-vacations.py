from _models import Command, Project

project = Project("code/unseen-bio/vacations", [
    Command("pip-compile", ["pip-compile --generate-hashes"]),
    Command("pip-compile upgrade", ["pip-compile --generate-hashes --upgrade"]),
    Command("format", [
        "isort main.py",
        "black main.py",
        "sudo chown -R kvikshaug:kvikshaug .",
    ]),
    Command("qa", [
        "wf flake8",
        "wf isort check",
        "wf black check",
        "wf safety",
    ]),
    Command("flake8", ["flake8 main.py"]),
    Command("isort check", ["isort --check-only main.py"]),
    Command("black check", ["black --check main.py"]),
    Command("safety", ["safety check --full-report"]),
])
