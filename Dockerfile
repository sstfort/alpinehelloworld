# Start from Alpine
FROM alpine:latest

# Install Python, pip, virtualenv, and build dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-virtualenv \
    gcc \
    musl-dev \
    libffi-dev \
    build-base \
    bash

# Create virtualenv
RUN python3 -m venv /opt/venv

# Activate venv
ENV PATH="/opt/venv/bin:$PATH"

# Use shell form to ensure venv pip is used
SHELL ["/bin/bash", "-c"]

# Copy and install requirements using venv's pip
COPY ./webapp/requirements.txt /tmp/requirements.txt
RUN source /opt/venv/bin/activate && pip install --no-cache-dir -r /tmp/requirements.txt

# Copy app code
COPY ./webapp /opt/webapp
WORKDIR /opt/webapp

# Switch to non-root
RUN adduser -D myuser
USER myuser

# Entrypoint for Heroku
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
