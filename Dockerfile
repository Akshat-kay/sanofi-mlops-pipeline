FROM python:3.9
WORKDIR /app

# Copy only what's needed for dependency installation
COPY setup.py .
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip && \
    pip install -e .

# Copy the rest
COPY . .

CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]
