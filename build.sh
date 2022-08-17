#!/bin/bash
set -eu -o pipefail

IMAGE_REPO=weirdgiraffe/gcloud-emulators-pubsub
VERSION=$(curl -s 'https://storage.googleapis.com/cloud-sdk-release?prefix=google-cloud-cli' |\
		tr "<" "\n<" |\
		sed '/google-cloud-cli-.*-linux-x86_64\.tar\.gz/!d;s/^.*-cli-\([^-]*\)-.*$/\1/' |\
		sort -nr |\
		head -1)

docker buildx build --push \
	--platform=linux/arm64,linux/amd64 \
	--build-arg=CLOUD_SDK_VERSION=${VERSION} \
	--tag=${IMAGE_REPO}:${VERSION} \
	--tag=${IMAGE_REPO}:latest .
