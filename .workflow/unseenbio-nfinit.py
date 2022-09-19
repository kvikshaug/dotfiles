from _models import Command, Project

project = Project("code/unseen-bio/nfinit", [
    Command("ipython", ["ipython"]),
    Command("pip-compile", ["pip-compile --generate-hashes"]),
    Command("pip-compile upgrade", ["pip-compile --generate-hashes --upgrade"]),
    Command("format", [
        "PYTHONPATH=src isort src tests",
        "PYTHONPATH=src black src tests",
    ]),
    Command("qa", [
        "wf flake8",
        "wf isort check",
        "wf black check",
        "wf safety",
        "wf gunicorn",
        "wf test",
    ]),
    Command("flake8", ["PYTHONPATH=src flake8 src tests"]),
    Command("isort check", ["PYTHONPATH=src isort --check-only src tests"]),
    Command("black check", ["PYTHONPATH=src black --check src tests"]),
    Command("test", ["PYTHONPATH=src ENVIRONMENT=testing pytest --verbosity 1 --durations=5 --cov=src"]),
    Command("gunicorn", ["PYTHONPATH=src gunicorn --check-config -c gunicorn.py nfinit.app:app"]),
    Command("safety", ["PYTHONPATH=src safety check --full-report"]),
    # Command("deploy master", ["ssh anton ./scripts/deploy-nfinit.sh"]),
    # Command("mpd master", [
    #     "git co master",
    #     "git merge -",
    #     "git push",
    #     "git co -",
    #     "wf deploy master",
    # ]),
])
