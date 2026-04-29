FROM python:3.11
WORKDIR /code
COPY requirements.txt requirements.txt
RUN python3 -m venv .venv
RUN . .venv/bin/activate
RUN pip install -r requirements.txt
COPY . .
CMD [ "opentelemetry-instrument", "python", "-u", "app.py" ]