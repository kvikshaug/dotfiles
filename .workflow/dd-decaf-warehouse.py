from _models import Command, Project

project = Project("code/dd-decaf/warehouse", [
    Command("ipython", ["docker compose run --rm web ipython"]),
    Command("pip-compile", [
        "docker run --rm -v `pwd`/requirements:/build dddecaf/postgres-base:compiler pip-compile --generate-hashes --upgrade --output-file /build/requirements.txt /build/requirements.in",
        "sudo chown -R kvikshaug:kvikshaug .",
    ]),
    Command("databases", [
        "docker compose up -d postgres",
        "./scripts/wait_for_postgres.sh",
        "docker compose exec postgres psql -U postgres -c \"create database testing;\"",
        "docker compose run --rm web flask db upgrade",
    ]),
    Command("format", [
        "docker compose run --rm web isort --recursive src tests",
        "docker compose run --rm web black src tests",
    ]),
    Command("qa", [
        "wf license",
        "wf flake8",
        "wf isort check",
        "wf black check",
        "wf safety",
        "wf test",
    ]),
    Command("license", ["./scripts/verify_license_headers.sh src tests"]),
    Command("flake8", ["docker compose run --rm web flake8 src tests"]),
    Command("isort check", ["docker compose run --rm web isort --check-only --recursive src tests"]),
    Command("black check", ["docker compose run --rm web black --check src tests"]),
    Command("test", ["docker compose run --rm -e ENVIRONMENT=testing web pytest --durations=5 --cov=src"]),
    Command("safety", ["docker compose run --rm web safety check"]),
])
