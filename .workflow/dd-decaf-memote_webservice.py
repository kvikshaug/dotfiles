from _models import Command, Project

project = Project("code/dd-decaf/memote-webservice", [
    Command("ipython", ["docker compose run --rm web ipython"]),
    Command("format", ["docker compose run --rm web isort --recursive src tests"]),
    Command("qa", [
        "wf license",
        "wf flake8",
        "wf isort check",
        "wf safety",
        "wf test",
    ]),
    Command("license", ["./scripts/verify_license_headers.sh src tests"]),
    Command("flake8", ["docker compose run --rm web flake8 src tests"]),
    Command("isort check", ["docker compose run --rm web isort --check-only --recursive src tests"]),
    Command("test", ["docker compose run --rm -e ENVIRONMENT=testing web pytest --durations=5 --cov=src"]),
    Command("safety", ["docker compose run --rm web safety check"]),
])
