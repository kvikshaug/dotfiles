from _models import Command, Project

project = Project("code/unseen-bio/oesd-frontend", [
    Command("serve", ["npx vue-cli-service serve"]),
    Command("lint", ["npx vue-cli-service lint --no-fix --max-warnings 0"]),
    Command("format", ["npx vue-cli-service lint"]),
    Command("test", ["npx vue-cli-service test:unit"]),
    Command("build", ["npx vue-cli-service build"]),
    Command("deploy", ["scp -r dist marvin:services/oesd-frontend/"]),
])
