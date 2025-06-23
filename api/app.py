from fastapi import FastAPI
import joblib

app = FastAPI()
model = joblib.load('models/model.pkl')

@app.post("/predict")
def predict(data: dict):
    return {"prediction": model.predict([data["features"]])[0]}