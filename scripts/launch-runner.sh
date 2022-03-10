#!/bin/bash

cat /etc/passwd

./config.sh --url https://github.com/teamjtharrison --token ${GITHUB_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${GITHUB_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!