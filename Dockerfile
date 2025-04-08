# Start from the Alpine image
FROM alpine:latest

# Install system dependencies
RUN apk add --no-cache \
    gunicorn
    Flask
    Jinja2
    Werkzeug

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate virtualenv and install Python dependencies
ENV PATH="/opt/venv/bin:$PATH"

# Add requirements and install
COPY ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy application code
COPY ./webapp /opt/webapp
WORKDIR /opt/webapp

# Create a non-root user
RUN adduser -D myuser
USER myuser

# Heroku runs this with PORT env variable set
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
