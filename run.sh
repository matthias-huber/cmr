#!/bin/sh
if [ ${BUFFER_SIZE+x} ];then
	sed -i "s/Xmn512/Xmn$(expr $BUFFER_SIZE / 3)/" startup.sh
	sed -i "s/Xms1536/Xms$BUFFER_SIZE/" startup.sh
	sed -i "s/Xmx1536/Xmx$BUFFER_SIZE/" startup.sh
fi

if [ -z "$(ls /CMR/config)" ];then
	# Copying original config folder. This is due mounting the config folder to an empty directory with docker `-v` parameter. Fixing issue #2
	cp -ra /CMR/config.orig/* /CMR/config/
fi

# cleanUp previously created symlinks
find /CMR/ci/profiles -type l -delete
if [ -d "/CMR/ci/environments" ]; then
	find /CMR/ci/environments -type l -delete
fi

if [ "$(ls /CMR/custom/profiles)" ];then
	# Create symlinks in /CMR/ci/profiles folder
	ln -s /CMR/custom/profiles/* /CMR/ci/profiles
	echo "$(ls -la /CMR/ci/profiles/)"
fi

if [ "$(ls /CMR/custom/environments)" ];then
	# Create the folder /CMR/ci/environments as it is non-existing at this point
	mkdir -p /CMR/ci/environments

	# Create symlinks in /CMR/ci/environments folder
	ln -s /CMR/custom/environments/* /CMR/ci/environments
fi

exec sh startup.sh

