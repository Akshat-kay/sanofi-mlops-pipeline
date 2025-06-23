from setuptools import setup, find_packages

setup(
    name="sanofi-mlops-api",
    version="0.1",
    packages=find_packages(),
    install_requires=[
        "fastapi==0.109.1",
        "uvicorn==0.27.0",
        "scikit-learn==1.4.0",
        "joblib==1.3.2"
    ],
)
