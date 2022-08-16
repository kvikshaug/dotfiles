#!/usr/bin/env /home/kvikshaug/.pyenv/versions/home/bin/python

import importlib.util
import os
import sys

path = os.path.dirname(os.path.realpath(__file__))
projects = []
for filename in os.listdir(path):
    full_path = f"{path}/{filename}"
    if not os.path.isfile(full_path):
        continue
    if filename.startswith("_"):
        continue
    if filename.startswith("."):
        continue

    spec = importlib.util.spec_from_file_location(filename, full_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    projects.append(module.project)

cwd = os.getcwd().replace("/home/kvikshaug/", "")
args = " ".join(sys.argv[1:])

try:
    project = [p for p in projects if p.path == cwd][0]
except IndexError:
    print(f"no workflow defined for path: {cwd}, valid project paths are:")
    for project in sorted(projects):
        print(f"  {project.path}")
    sys.exit(-1)

try:
    command = [c for c in project.commands if c.argument == args][0]
except IndexError:
    maxlen = max(len(c.argument) for c in project.commands)
    for i, command in enumerate(project.commands):
        print(f"wf {command.argument.ljust(maxlen)}")
        for line in command.script:
            print(f"  {line}")
        if i < len(project.commands) - 1:
            print()
    sys.exit(-1)

exit_codes = []
for line in command.script:
    print(f"wf: {line}")
    exit_codes.append(os.WEXITSTATUS(os.system(line)))

if any(code > 0 for code in exit_codes):
    print("wf: non-zero exit code:")
    for line, code in zip(command.script, exit_codes):
        print(f"  {line}: exit {code}")
    sys.exit(-1)
else:
    sys.exit(0)
