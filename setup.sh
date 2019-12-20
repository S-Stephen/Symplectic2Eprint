#!/bin/bash

mkdir src/output
pipenv shell
pipenv install;
cd src
python ./main.py --help
