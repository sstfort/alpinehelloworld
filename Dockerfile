# Grab the latest alpine image
FROM alpine:latest

# Install python3, pip, and other dependencies
RUN apk add --no-cache --update python3 py3-pip py3-virtualenv bash gcc musl-dev libffi-dev

# Create a virtual environment
RUN python3 -m venv /opt/venv

# Activate virtualenv by setting environment variables
ENV PATH="/opt/venv/bin:$PATH"

# Add requirements and install dependencies inside the virtual environment
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Add your application code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Create non-root user
RUN adduser -D myuser
USER myuser

# Run the app using Gunicorn
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
