# Start from Alpine
FROM alpine:latest

# Install Python and dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-virtualenv \
    gcc \
    musl-dev \
    libffi-dev \
    build-base \
    bash

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy and install requirements inside the venv
COPY ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Add application code
COPY ./webapp /opt/webapp
WORKDIR /opt/webapp

# Create a non-root user
RUN adduser -D myuser
USER myuser

# Heroku uses $PORT, required for gunicorn
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
