from fastapi import FastAPI, HTTPException
import joblib
import os
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()

MODEL_PATH = "models/model.pkl"

# Initialize model variable
model = None

@app.on_event("startup")
async def startup():
    # Initialize monitoring
    Instrumentator().instrument(app).expose(app)
    
    # Load model with better error handling
    global model
    try:
        model = joblib.load(MODEL_PATH)
        app.state.model_loaded = True
    except Exception as e:
        app.state.model_loaded = False
        app.state.model_error = str(e)

@app.post("/predict")
def predict(data: dict):
    if not getattr(app.state, 'model_loaded', False):
        raise HTTPException(
            status_code=503,
            detail=f"Model not loaded: {getattr(app.state, 'model_error', 'Unknown error')}"
        )
    
    try:
        features = data.get("features")
        if not features or not isinstance(features, list):
            raise ValueError("Features must be a non-empty list")
            
        return {
            "prediction": float(model.predict([features])[0]),
            "model_version": os.path.basename(MODEL_PATH)
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
