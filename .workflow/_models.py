from collections import namedtuple

Command = namedtuple("Command", ("argument", "script"))
Project = namedtuple("Project", ("path", "commands"))
