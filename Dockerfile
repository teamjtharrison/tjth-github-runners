FROM ubuntu

WORKDIR /github-action-runner

COPY scripts/launch-runner.sh /github-action-runner/launch-runner.sh

RUN apt-get update && \
    apt-get install curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip -y && \
    cd /github-action-runner && \
    curl -o actions-runner-linux-x64-2.287.1.tar.gz -L \
    https://github.com/actions/runner/releases/download/v2.287.1/actions-runner-linux-x64-2.287.1.tar.gz && \
    tar xzf ./actions-runner-linux-x64-2.287.1.tar.gz && \
    rm -rf ./actions-runner-linux-x64-2.287.1.tar.gz && \
    chown -R daemon:daemon /github-action-runner/ && \
    # Install depedencies
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC bin/installdependencies.sh

USER daemon