FILES=iskdaemon

all: FILES iskdaemon

FILES:
	if [ ! -d "./$(FILES)" ];then \
		git clone https://github.com/ricardocabral/iskdaemon.git; \
	fi

# A new build executes when make detects that the Dockerfile has been edited.
.build: Dockerfile
	docker build -t garyritchie/iskdaemon .
	# An indicator that we've already built the image...
	@docker inspect -f '{{.Id}}' garyritchie/iskdaemon > .build

# Only build if we haven't built before...
build: .build

iskdaemon: .build
	-@docker rm -f $@ > /dev/null
	docker run -d --name $@ \
		-p 31128:31128 \
		-v $(HOME)/Pictures:/Pictures \
		garyritchie/iskdaemon
		# -v `pwd`/isk-db:/root/isk-db \
