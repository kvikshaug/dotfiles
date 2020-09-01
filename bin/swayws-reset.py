#!/usr/bin/env python
import json
import subprocess


def workspace_has_windows(workspace_name):
    tree = json.loads(subprocess.run("swaymsg -t get_tree", shell=True, check=True, capture_output=True).stdout)
    for output in tree["nodes"]:
        for workspace in output["nodes"]:
            if workspace["name"] == workspace_name:
                return len(workspace["nodes"]) > 0


tree = json.loads(subprocess.run("swaymsg -t get_tree", shell=True, check=True, capture_output=True).stdout)
workspaces = set()
for output in tree["nodes"]:
    if output["name"].startswith("__"):
        continue
    for workspace in output["nodes"]:
        workspaces.add(workspace["name"])

for output in tree["nodes"]:
    if output["name"].startswith("__"):
        continue
    print(f"Output {output['name']}")
    for workspace in output["nodes"]:
        print(f"  Workspace {workspace['name']}")
        new_name = f"{workspace['num']} {output['id']}:{workspace['num']}"
        if workspace["name"] == new_name:
            print("    Correct workspace output, moving on")
            continue
        if new_name in workspaces:
            print(f"    The workspace exists; moving windows to {new_name}.")
            subprocess.run(f"swaymsg workspace {workspace['name']}", shell=True, check=True)
            while workspace_has_windows(workspace["name"]):
                subprocess.run(f"swaymsg move container to workspace {new_name}", shell=True, check=True)
            subprocess.run(f"swaymsg workspace {new_name}", shell=True, check=True)
        else:
            print(f"    The workspace doesn't exist; renaming from {workspace['name']} to {new_name}.")
            subprocess.run(f"swaymsg rename workspace {workspace['name']} to {new_name}", shell=True, check=True)
            workspaces.add(new_name)
