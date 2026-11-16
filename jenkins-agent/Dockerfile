
# Stage 1: Get BuildKit rootless binaries
FROM moby/buildkit:v0.20.2-rootless AS buildkit

# Stage 2: Jenkins agent
FROM jenkins/inbound-agent:3385.vf1123fb_515da_-1

USER root

# Install Node.js, npm, AWS CLI, Git and rootless UID mapping tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        nodejs \
        npm \
        awscli \
        git \
        curl \
        unzip \
        ca-certificates \
        uidmap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy BuildKit tools into the Jenkins agent
COPY --from=buildkit /usr/bin/ /opt/buildkit/bin/

ENV PATH="/opt/buildkit/bin:${PATH}"

# Configure subordinate UID/GID mappings for rootless BuildKit
RUN printf 'jenkins:100000:65536\n' > /etc/subuid && \
    printf 'jenkins:100000:65536\n' > /etc/subgid && \
    mkdir -p /run/user/1000 \
             /home/jenkins/.local/share/buildkit && \
    chown -R jenkins:jenkins /run/user/1000 \
             /home/jenkins/.local && \
    chmod 700 /run/user/1000

# BuildKit configuration for Kubernetes
ENV XDG_RUNTIME_DIR=/run/user/1000
ENV BUILDKITD_FLAGS="--oci-worker-no-process-sandbox --oci-worker-snapshotter=native"

# Return to non-root Jenkins user
USER jenkins

WORKDIR /home/jenkins/agent

# Verify installed tools
RUN node --version && \
    npm --version && \
    aws --version && \
    buildctl --version && \
    buildkitd --version && \
    rootlesskit --version

