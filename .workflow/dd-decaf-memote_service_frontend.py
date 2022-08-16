from _models import Command, Project

project = Project("code/dd-decaf/memote-service-frontend", [
    Command("serve", ["npx vue-cli-service serve --port 4200"]),
    Command("lint", ["npx vue-cli-service lint --no-fix --max-warnings 0"]),
    Command("test", ["npx vue-cli-service test:unit"]),
    Command("format", ["npx vue-cli-service lint"]),
])
