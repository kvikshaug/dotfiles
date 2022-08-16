from _models import Command, Project

project = Project("code/unseen-bio/terms-of-service", [
    Command("markdown", [
        "python -m markdown2 --extras break-on-newline,code-friendly,header-ids source/terms.md > html/en.html",
    ]),
    Command("i18n extract", [
        "html2po -P html/en.html -o translations/messages.pot",
        # Note: Could maybe use `pot2po` + `pomerge` here, but `pybabel` does the trick.
        "pybabel update --no-wrap --ignore-obsolete -l da -i translations/messages.pot -o 'translations/da.po'",
        "pybabel update --no-wrap --ignore-obsolete -l de -i translations/messages.pot -o 'translations/de.po'",
        # "pot2po -t html -i translations/messages.pot -o translations/da.po",
        # "pot2po -t html -i translations/messages.pot -o translations/de.po",
    ]),
    Command("i18n write", [
        "po2html -t html/en.html -i translations/da.po -o html/da.html",
        "po2html -t html/en.html -i translations/de.po -o html/de.html",
    ]),
    Command("terms cp", [
        "cp html/en.html ../myub/templates/terms/en.html",
        "cp html/da.html ../myub/templates/terms/da.html",
        "cp html/de.html ../myub/templates/terms/de.html",
    ]),
    Command("mpd translations", [
        "git co translations",
        "git merge -",
        "git push",
        "git co -",
    ]),
])
