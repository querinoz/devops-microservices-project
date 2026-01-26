FROM python:3.10-slim

# Required for healthchecks in docker-compose
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Senior Practice: Non-root user for security
RUN useradd -m devopsuser
USER devopsuser

EXPOSE 8001

CMD ["gunicorn", "--bind", "0.0.0.0:8001", "--workers", "2", "app:app"]