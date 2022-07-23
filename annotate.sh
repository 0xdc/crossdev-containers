#!/bin/bash

image=applehq/roflmaos
date=${1?need date}

for stage in stage3 stage4; do
	docker manifest create \
		${image}-${stage}:$date \
			${image}-${stage}:amd64-${date} \
			${image}-${stage}:armv7a-$date
	docker manifest annotate \
		${image}-${stage}:$date \
			${image}-${stage}:armv7a-$date --arch arm
	docker manifest push ${image}-${stage}:$date
done
