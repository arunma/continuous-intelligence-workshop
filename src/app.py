from flask import Flask, render_template, jsonify, request
from datetime import datetime
from sklearn.externals import joblib
import pandas as pd
import decision_tree
import mlflow
import mlflow.sklearn
import os

app = Flask(__name__, template_folder='webapp/templates', static_folder='webapp/static')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/prediction')
def get_prediction():
  #loaded_model = joblib.load('data/decision_tree/model.pkl')
  # mlflow.set_tracking_uri("http://35.247.183.209:5000")
  # mlflow.create_experiment("sales_prediction")
  tracking_uri = os.getenv('TRACKING_URI', "http://localhost:5000")
  experiment_name = os.getenv('EXPERIMENT_NAME', "global_experiments")
  mlflow.set_tracking_uri(tracking_uri)
  mlflow.set_experiment(experiment_name)
  artifact = mlflow.get_artifact_uri
  print ("Experiment URI " + artifact)

  loaded_model = mlflow.sklearn.load_model("model", "937b7254b4834a72b085bc55cdfbf460")

  date_string = request.args.get('date')

  date = datetime.strptime(date_string, '%Y-%m-%d')

  data = {
    "date": date_string,
    "item_nbr": request.args.get("item_nbr"),
    "family": request.args.get("family"),
    "class": request.args.get("class"),
    "perishable": request.args.get("perishable"),
    "transactions": request.args.get("transactions"),
    "year": date.year,
    "month": date.month,
    "day": date.day,
    "dayofweek": date.weekday(),
    "days_til_end_of_data": 0,
    "dayoff": request.args.get("day_off")
  }
  df = pd.DataFrame(data=data, index=['row1'])

  df = decision_tree.encode_categorical_columns(df)
  pred = loaded_model.predict(df)

  return "%d (From the model version : %s)" % (pred[0], artifact)

if __name__ == '__main__':
    app.run(host = '0.0.0.0', port=5005)