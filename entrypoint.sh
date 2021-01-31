#!/bin/sh

echo "Start Testing"
echo "Req path : $1"
echo "DAGs dir : $2"
echo "Var path : $3"

export AIRFLOW_HOME="/github/workspace/$2"
export PYTHONPATH="${PYTHONPATH}:${AIRFLOW_HOME}"

echo "Airflow : $AIRFLOW_HOME"
echo "Python : $PYTHONPATH"

pip install -r $1

jinja2 ./dag_validation.py -D dags=./$2 > ./temp.txt && mv ./temp.txt ./dag_validation.py

cat ./dag_validation.py

airflow initdb > /dev/null

airflow variables --import $3

pytest ./dag_validation.py
