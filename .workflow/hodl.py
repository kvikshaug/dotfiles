from _models import Command, Project

project = Project("code/hodl", [
    Command("flake8", ["flake8 hodl"]),
    Command("isort check", ["isort --check-only hodl"]),
    Command("black check", ["black --check hodl/*"]),
    Command("safety", ["safety check --full-report"]),
    Command("qa", [
        "wf flake8",
        "wf isort check",
        "wf black check",
        "wf safety",
    ]),
    Command("format", [
        "isort hodl",
        "black hodl/*",
    ]),

    Command("print_history", ["python -m hodl.main print_history"]),
    Command("print_holdings", ["python -m hodl.main print_holdings"]),
    Command("print_realizations", ["python -m hodl.main print_realizations"]),
    Command("print_yearly_results", ["python -m hodl.main print_yearly_results"]),
    Command("print_yearly_results_per_currency", ["python -m hodl.main print_yearly_results_per_currency"]),
    Command("save_history_csv", ["python -m hodl.main save_history_csv"]),
    Command("save_holdings_csv", ["python -m hodl.main save_holdings_csv"]),
    Command("save_realizations_csv", ["python -m hodl.main save_realizations_csv"]),
    Command("save_realizations_csv_skat", ["python -m hodl.main save_realizations_csv_skat"]),
    Command("render_charts", ["python -m hodl.main render_charts"]),

    Command("parse_bitstamp", ["python hodl/parse_bitstamp.py"]),
    Command("open", ["firefox dist/charts.html"]),
])
