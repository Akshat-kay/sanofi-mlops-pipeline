from fastapi import FastAPI, HTTPException
import joblib
import os
##############
# Add to api/app.py
from prometheus_fastapi_instrumentator import Instrumentator

@app.on_event("startup")
async def startup():
    Instrumentator().instrument(app).expose(app)


###############
app = FastAPI()

MODEL_PATH = "models/model.pkl"

try:
    model = joblib.load(MODEL_PATH)
except FileNotFoundError:
    raise RuntimeError(f"Model file not found at {MODEL_PATH}. Please train the model first.")

@app.post("/predict")
def predict(data: dict):
    try:
        return {"prediction": float(model.predict([data["features"]])[0])}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
