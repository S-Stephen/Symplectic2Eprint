#!/bin/bash

mkdir src/output
pipenv install;
cd src
python ./main.py --help
