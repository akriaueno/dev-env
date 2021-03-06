IMAGE_NAME=dev-env
IMAGE_TAG=latest
BUILD_OPT="--no-cache"

build:
	docker build . -t $(IMAGE_NAME):$(IMAGE_TAG) $(BUILD_OPT)
clean:
	docker image rm $(IMAGE_NAME):$(IMAGE_TAG)
