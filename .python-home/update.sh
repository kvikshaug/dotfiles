# These files are used to compile & install requirements for your local .pyenv 'home' virtualenv.
set -eux

pip install --upgrade pip setuptools wheel pip-tools
pip-compile --upgrade
pip-sync
