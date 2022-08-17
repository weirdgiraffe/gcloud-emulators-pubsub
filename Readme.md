This container provides a minimalistic image for google cloud pubsub emulator.
This image is being automatically rebuilt daily to keep up with the latest
version. You can find it on DockerHub at https://hub.docker.com/r/weirdgiraffe/gcloud-emulators-pubsub

# Usage

Run container:

```sh
docker run --rm -ti -p 8085:8085 weirdgiraffe/gcloud-emulators-pubsub
```

Running your application:

```sh
PUBSUB_EMULATOR_HOST=localhost:8085 ./yourapp
```

This image provides you with the ability to supply flags straight to the
emulator, so you can explore the possible flags using:

```sh
docker run --rm -ti weirdgiraffe/gcloud-emulators-pubsub --help
```

Further references: https://cloud.google.com/pubsub/docs/emulator

