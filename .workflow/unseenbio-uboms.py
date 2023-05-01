from _models import Command, Project

project = Project("code/unseen-bio/uboms", [
    Command("ipython", ["docker compose run --rm web ipython"]),
    Command("pip-compile", ["docker compose run --rm web pip-compile --resolver=backtracking --generate-hashes"]),
    Command("pip-compile upgrade", ["docker compose run --rm web pip-compile --resolver=backtracking --generate-hashes --upgrade"]),
    Command("format", [
        "docker compose run --rm web isort src tests",
        "docker compose run --rm web black src tests",
        "sudo chown -R kvikshaug:kvikshaug .",
    ]),
    Command("qa", [
        "wf flake8",
        "wf isort check",
        "wf black check",
        "wf safety",
        "wf gunicorn",
        "wf test",
    ]),
    Command("flake8", ["docker compose run --rm web flake8 src tests"]),
    Command("isort check", ["docker compose run --rm web isort --check-only src tests"]),
    Command("black check", ["docker compose run --rm web black --check src tests"]),
    Command("test", ["docker compose run --rm -e ENVIRONMENT=testing web pytest --verbosity 1 --durations=5 --cov=src"]),
    Command("gunicorn", ["docker compose run --rm web gunicorn --check-config -c gunicorn.py uboms.app:app"]),
    Command("safety", ["docker compose run --rm web safety check --full-report"]),
    Command("deploy master", ["ssh marvin ./scripts/deploy-uboms.sh"]),
    Command("deploy staging", ["ssh marvin ./scripts/deploy-uboms-staging.sh"]),
    Command("mpd master", [
        "git co master",
        "git merge -",
        "git push",
        "git co -",
        "wf deploy master",
    ]),
    Command("mpd staging", [
        "git co staging",
        "git merge -",
        "git push",
        "git co -",
        "wf deploy staging",
    ]),
])
