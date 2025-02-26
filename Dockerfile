# Stage 1: Build dependencies
FROM python:3.9-alpine AS builder

WORKDIR /app

# Copy only requirements.txt to install dependencies first
COPY requirements.txt .

# Install system dependencies for Alpine (for building Python packages)
RUN apk add --no-cache gcc musl-dev libffi-dev

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Stage 2: Create final lightweight image
FROM python:3.9-alpine

WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy the application code
COPY . .

# Expose Flask port
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
