from _models import Command, Project

project = Project("code/unseen-bio/ubdb", [
    Command("pip-compile", ["docker compose run --rm web pip-compile --generate-hashes"]),
    Command("pip-compile upgrade", ["docker compose run --rm web pip-compile --generate-hashes --upgrade"]),
    Command("createdb", [
        "docker compose exec ubdb psql -U postgres -c 'create database unseen'",
        "docker compose exec ubdb psql -U postgres -c 'create database testing'",
    ]),
    Command("importroles", ["ssh marvin docker-compose -f services/ubdb/docker-compose.production.yml exec -T ubdb pg_dumpall --roles-only -U postgres | docker compose exec -T ubdb psql -U postgres"]),
    Command("importdb", [
        "docker compose exec ubdb psql -U postgres -c 'drop database unseen;'",
        "docker compose exec ubdb psql -U postgres -c 'create database unseen;'",
        "ssh marvin docker-compose -f services/ubdb/docker-compose.production.yml exec -T ubdb pg_dump -U postgres -Fc unseen | docker-compose exec -T ubdb pg_restore -U postgres -d unseen",
        # Workaround, seems it's not needed anymore:
        # "ssh marvin docker-compose -f services/ubdb/docker-compose.production.yml exec -T ubdb pg_dump -U postgres -Fc unseen > db-tmp",
        # "docker compose cp ./db-tmp ubdb:/",
        # "docker-compose exec -T ubdb pg_restore -U postgres -d unseen /db-tmp",
        # "docker-compose exec -T ubdb rm /db-tmp",
        # "rm db-tmp",
    ]),
    Command("importdb local", [
        "docker compose exec ubdb psql -U postgres -c 'drop database unseen;'",
        "docker compose exec ubdb psql -U postgres -c 'create database unseen;'",
        "cat ubdb.sql | docker-compose exec -T ubdb pg_restore -U postgres -d unseen",
    ]),
    Command("importdb backup", [
        "mcli cp wasabi-2/unseenbio-backups-marvin/$(date +\"%Y-%m-%d\")/ubdb.sql.zst .",
        "unzstd ubdb.sql.zst",
        "docker compose exec ubdb psql -U postgres -c 'drop database unseen;'",
        "docker compose exec ubdb psql -U postgres -c 'create database unseen;'",
        "cat ubdb.sql | docker compose exec -T ubdb psql -U postgres -d unseen",
    ]),
    Command("migrate", [
        "docker compose run --rm web flask db migrate",
        "sudo chown -R kvikshaug:kvikshaug .",
    ]),
    Command("upgrade", ["docker compose run --rm web flask db upgrade"]),
    Command("testing reset", [
        "docker compose exec ubdb psql -U postgres -c 'drop database testing'",
        "docker compose exec ubdb psql -U postgres -c 'create database testing'",
    ]),
    Command("ipython", ["docker compose run --rm web ipython"]),
    Command("psql", ["docker compose run --rm ubdb psql -U postgres -h ubdb"]),
    Command("format", [
        "docker compose run --rm web isort src",
        "docker compose run --rm web black src",
        "sudo chown -R kvikshaug:kvikshaug .",
    ]),
    Command("qa", [
        "wf flake8",
        "wf isort check",
        "wf black check",
        "wf safety",
    ]),
    Command("flake8", ["docker compose run --rm web flake8 src"]),
    Command("isort check", ["docker compose run --rm web isort --check-only src"]),
    Command("black check", ["docker compose run --rm web black --check src"]),
    Command("safety", ["docker compose run --rm web safety check --full-report"]),
    Command("deploy master", ["ssh marvin ./scripts/deploy-ubdb.sh"]),
    Command("deploy staging", ["ssh marvin ./scripts/deploy-ubdb-staging.sh"]),
    Command("marvin staging importdb", ["ssh marvin ./scripts/ubdb-staging-importdb.sh"]),
    Command("marvin staging upgrade", ["ssh marvin ./scripts/ubdb-staging-upgrade.sh"]),
    Command("marvin staging create-superuser", ["ssh marvin ./scripts/ubdb-staging-create-superuser.sh"]),
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
        "wf deploy staging",
        "git co -",
    ]),
])
