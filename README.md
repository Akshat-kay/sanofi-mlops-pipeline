# Molecular Property Prediction API - MLOps Ready

## Project Overview

This project provides a REST API for predicting molecular properties using machine learning. The system is designed with MLOps best practices in mind, featuring model serving, basic CI/CD, and infrastructure-as-code components.

## Architecture

```
                   ┌───────────────────────────────────────────────────────┐
                   │                   AWS EC2 (t3.xlarge)                 │
                   │                                                       │
┌──────────────┐   │  ┌─────────────┐    ┌─────────────┐    ┌───────────┐ │
│   Scientist  │──────▶│ FastAPI     │    │   Metaflow  │    │ Docker    │ │
│ (API Client) │   │  │ (Port 8000) │◀──▶│  Pipeline   │◀──▶│ Container │ │
└──────────────┘   │  └─────────────┘    └─────────────┘    └───────────┘ │
                   │          │               │                   │        │
                   │          ▼               ▼                   ▼        │
                   │  ┌─────────────┐  ┌─────────────┐  ┌────────────────┐│
                   │  │  Scikit-Learn│  │  Model      │  │  Local Model   ││
                   │  │  Model       │  │  Training   │  │  Storage       ││
                   │  │  (Inference) │  │  (Random    │  │  (/models)     ││
                   │  └─────────────┘  │  Forest)     │  └────────────────┘│
                   │                   └─────────────┘                     │
                   └───────────────────────────────────────────────────────┘
```

## Features

- REST API endpoint for molecular property predictions
- Containerized deployment with Docker
- Basic model versioning
- CI/CD pipeline foundation
- Infrastructure automation scripts

## Getting Started

### Prerequisites

- Python 3.9+
- Docker
- AWS account (for deployment)

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/molecular-prediction-api.git
cd molecular-prediction-api

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Running Locally

```bash
# Start the FastAPI server
uvicorn app.main:app --reload

# The API will be available at http://localhost:8000
```

### Building the Docker Image

```bash
docker build -t molecular-api .
docker run -p 8000:8000 molecular-api
```

## API Documentation

### Prediction Endpoint

`POST /predict`

**Request:**
```json
{
  "features": [1.0, 2.5, 3.7]
}
```

**Response:**
```json
{
  "prediction": 5.18,
  "model_version": "20230624",
  "timestamp": "2023-06-24T12:34:56.789Z"
}
```

## Deployment

### AWS EC2 Deployment

```bash
./deploy_api.sh
```

## Next Steps in Your MLOps Journey

Here's a prioritized roadmap to enhance your MLOps capabilities:

### 1. Immediate Next Steps (0-2 weeks)

**Model Management:**
```bash
# Implement proper model versioning
mkdir -p models/versions
cp models/model.pkl models/versions/model_$(date +%Y%m%d_%H%M%S).pkl
```

**Monitoring:**
- Add Prometheus metrics endpoint
- Implement basic health checks
- Set up API request logging

**CI/CD:**
- Complete GitHub Actions pipeline
- Add automated testing
- Implement blue/green deployment

### 2. Medium-Term Improvements (2-8 weeks)

**Model Operations:**
- Implement model registry (MLflow or S3-based)
- Add model performance monitoring
- Set up automated retraining pipeline

**Infrastructure:**
- Container orchestration with Kubernetes
- Auto-scaling configuration
- Infrastructure as code (Terraform)

**Data Quality:**
- Implement input data validation
- Add feature store integration
- Set up data drift detection

### 3. Advanced MLOps (8+ weeks)

**Advanced Features:**
- A/B testing framework
- Canary deployments
- Model explainability endpoints

**Observability:**
- Centralized logging (ELK stack)
- Distributed tracing
- Automated alerting system

**Security:**
- API authentication (JWT/OAuth)
- Role-based access control
- Model encryption

## Example Implementation: Adding Model Monitoring

Here's a concrete example of how you might implement basic model monitoring:

1. Create a monitoring service:
```python
# app/monitoring.py
from prometheus_client import Counter, Gauge

PREDICTION_COUNTER = Counter(
    'model_predictions_total',
    'Total predictions made by model',
    ['model_version']
)

PREDICTION_VALUE = Gauge(
    'model_prediction_values',
    'Values of predictions made',
    ['model_version']
)

def record_prediction(version, value):
    PREDICTION_COUNTER.labels(model_version=version).inc()
    PREDICTION_VALUE.labels(model_version=version).set(value)
```

2. Modify your prediction endpoint:
```python
from .monitoring import record_prediction

@app.post("/predict")
async def predict(features: Features):
    prediction = model.predict([features.features])[0]
    record_prediction(MODEL_VERSION, prediction)
    return {
        "prediction": prediction,
        "model_version": MODEL_VERSION
    }
```

3. Add metrics endpoint:
```python
from prometheus_client import generate_latest

@app.get("/metrics")
async def metrics():
    return Response(
        content=generate_latest(),
        media_type="text/plain"
    )
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
