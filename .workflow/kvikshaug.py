from _models import Command, Project

project = Project("code/kvikshaug.no", [
    Command("build", [
        "wf sass build",
        "wf babel build",
    ]),
    Command("sass build", ["docker-compose run --rm sass sass -s compressed assets/sass:assets/dist/css"]),
    Command("babel build", ["docker-compose run --rm babel babel --verbose js -d assets/dist/js"]),

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
    Command("test", ["docker compose run --rm -e ENVIRONMENT=testing web pytest --durations=5 --cov=src"]),
    Command("gunicorn", ["docker compose run --rm web gunicorn --check-config -c gunicorn.py kvikshaug.app:app"]),
    Command("safety", ["docker compose run --rm web safety check --full-report"]),

    Command("deploy", ["ssh spittle ./kvikshaug.no/deploy.sh"]),
])
