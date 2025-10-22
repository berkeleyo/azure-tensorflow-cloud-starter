# Minimal CPU TensorFlow base (adjust to a pinned version for reproducibility)
FROM python:3.11-slim

RUN pip install --no-cache-dir tensorflow==2.16.1

# Default workdir
WORKDIR /app

# Non-root best practice
RUN useradd -m worker
USER worker

CMD ["python","-c","import tensorflow as tf; print(tf.__version__)"]
