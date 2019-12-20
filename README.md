# Symplectic2Eprint

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/S-Stephen/Symplectic2Eprint)

Transform a publication downloaded from Symplectic into an importable EPrint

## Setup and run

```
pipenv shell
pipenv install # fails to install pylint on gitpod; but continue
cd src
mkdir output
python ./main.py <symplectic_id> <user> <pword>
```

The output files (raw Symplectic file and transformed EpPrint file for each relationship found will be in ./output).

Neatly render files with __XML Tools__ Josh Johnson:

```
Ctrl + Shift + Alt + B
```

