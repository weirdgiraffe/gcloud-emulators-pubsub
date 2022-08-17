# base image for all stages
FROM alpine:3.16 AS base

RUN apk add --no-cache \
	openjdk8-jre \
	python3
ENV PATH=/google-cloud-sdk/bin:${PATH}

# stage #1: base image for google-cloud-sdk (has curl)
FROM base AS google-cloud-sdk-base

RUN apk add --no-cache \
	ca-certificates \
	curl

ARG BASE_DOWNLOAD_URL=https://dl.google.com/dl/cloudsdk/channels/rapid/downloads
ARG CLOUD_SDK_VERSION
ARG TARGETARCH

# stage #2: arch specific stage to download google-cloud-sdk release
FROM google-cloud-sdk-base AS google-cloud-sdk-arm64
RUN curl -sO ${BASE_DOWNLOAD_URL}/google-cloud-cli-${CLOUD_SDK_VERSION}-linux-arm.tar.gz
RUN tar xzf google-cloud-cli-${CLOUD_SDK_VERSION}-linux-arm.tar.gz
RUN rm google-cloud-cli-${CLOUD_SDK_VERSION}-linux-arm.tar.gz

# stage #2: arch specific stage to download google-cloud-sdk release
FROM google-cloud-sdk-base AS google-cloud-sdk-amd64
RUN curl -sO ${BASE_DOWNLOAD_URL}/google-cloud-cli-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
RUN tar xzf google-cloud-cli-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz
RUN rm google-cloud-cli-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz

# stage #3: installation of needed components and cleanup
FROM google-cloud-sdk-${TARGETARCH} AS google-cloud-sdk
RUN /google-cloud-sdk/install.sh --quiet
RUN gcloud config set component_manager/disable_update_check true
RUN gcloud config set core/disable_usage_reporting true
RUN gcloud config set metrics/environment pubsub_emulator
RUN gcloud components install --quiet beta pubsub-emulator
RUN rm /google-cloud-sdk/data/cli/gcloud.json
RUN rm -rf /google-cloud-sdk/.install/.backup/
RUN find /google-cloud-sdk/ -name "__pycache__" -type d  | xargs -n 1 rm -rf

# stage #4: final minimal runtime image 
FROM base
COPY --from=google-cloud-sdk /google-cloud-sdk /google-cloud-sdk
CMD gcloud beta emulators pubsub start --project=test
