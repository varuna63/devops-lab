FROM jenkins/jenkins:lts

USER root

# Install Python 3, pip, virtualenv, and tools to prevent build errors
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    python3-flask \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Switch back to jenkins user
USER jenkins
