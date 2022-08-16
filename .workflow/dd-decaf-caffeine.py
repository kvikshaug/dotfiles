from _models import Command, Project

project = Project("code/dd-decaf/caffeine", [
    Command("serve", ["npx vue-cli-service serve --port 4200"]),
    Command("lint", ["npx vue-cli-service lint --no-fix --max-warnings 0"]),
    Command("format", ["npx vue-cli-service lint"]),
    Command("test", ["npx vue-cli-service test:unit"]),
    Command("install local escher", ["cp -va ~/code/dd-decaf/escher/dist/* ~/code/dd-decaf/caffeine/node_modules/@dd-decaf/escher/dist"]),
])
