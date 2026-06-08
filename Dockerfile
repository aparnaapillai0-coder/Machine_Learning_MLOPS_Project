FROM python:3.8-slim-buster

# Environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libatlas-base-dev \
    protobuf-compiler \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files (IMPORTANT: build context must be correct)
COPY . .

# Install Python dependencies
RUN pip install --no-cache-dir -e .

# Expose Flask port
EXPOSE 5000

# Run application
CMD ["python", "application.py"]
