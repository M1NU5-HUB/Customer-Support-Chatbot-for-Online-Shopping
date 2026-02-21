# Dockerfile to run Rasa 1.10.2 on Python 3.7 (Debian buster)
FROM python:3.7-buster

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# Install system dependencies required to build some Python packages
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential git gcc libssl-dev libffi-dev python3-dev \
    libxml2-dev libxslt1-dev zlib1g-dev libblas-dev liblapack-dev gfortran swig \
  && rm -rf /var/lib/apt/lists/*

# Upgrade pip and build tools
RUN pip install --upgrade pip setuptools wheel

# Copy project files into container
COPY . /app

# Install Rasa 1.10.2
RUN pip install "rasa==1.10.2"

# Expose Rasa REST API port
EXPOSE 5005

# Start Rasa (listen on all interfaces)
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--debug", "--host", "0.0.0.0", "--port", "5005"]
