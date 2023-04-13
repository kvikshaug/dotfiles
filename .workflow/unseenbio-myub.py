from _models import Command, Project

project = Project("code/unseen-bio/myub", [
    Command("ipython", ["docker compose run --rm web ipython"]),
    Command("pip-compile", ["docker compose run --rm web pip-compile --generate-hashes"]),
    Command("pip-compile upgrade", ["docker compose run --rm web pip-compile --generate-hashes --upgrade"]),
    Command("sass build", ["sass -s compressed static/sass:static/css"]),
    Command("sass watch", ["sass --watch -s compressed static/sass:static/css"]),
    Command("i18n external", ["docker compose run --rm web python translations/external/extract.py"]),
    Command("i18n extract", [
        "docker compose run --rm web pybabel extract --no-wrap -F babel.cfg -c 'i18n:' -o translations/messages.pot .",
        "docker compose run --rm web pybabel update --no-wrap --ignore-obsolete -i translations/messages.pot -d translations",
        "sudo chown -R kvikshaug:kvikshaug .",
    ]),
    Command("i18n compile", ["docker compose run --rm web pybabel compile -d translations"]),
    Command("terms cp", [
        "cp ../terms-of-service/source/terms.html ./templates/terms/en.html",
        "cp ../terms-of-service/translations/da.html ./templates/terms/da.html",
        "cp ../terms-of-service/translations/de.html ./templates/terms/de.html",
    ]),
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
    Command("gunicorn", ["docker compose run --rm web gunicorn --check-config -c gunicorn.py myub.app:app"]),
    Command("safety", ["docker compose run --rm web safety check --full-report"]),
    Command("create-superuser", ["docker compose run --rm web flask create-superuser"]),
    Command("deploy master", ["ssh marvin ./scripts/deploy-myub.sh"]),
    Command("deploy staging", ["ssh marvin ./scripts/deploy-myub-staging.sh"]),
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
    Command("mpd translations", [
        "git co translations",
        "git merge -",
        "git push",
        "git co -",
    ]),
])