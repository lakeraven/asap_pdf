FROM python:latest
COPY requirements.txt .
ENV PYTHONPATH=\/workspace
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir
RUN apt-get update && apt-get install -y --no-install-recommends default-jre
WORKDIR /workspace