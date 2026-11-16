
FROM jenkins/inbound-agent:3385.vf1123fb_515da_-1

USER root

# Install Node.js, npm, AWS CLI and utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nodejs \
        npm \
        awscli \
        git \
        curl \
        unzip \
        ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Return to the non-root Jenkins user
USER jenkins

WORKDIR /home/jenkins/agent

