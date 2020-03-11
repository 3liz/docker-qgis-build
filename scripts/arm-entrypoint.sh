#!/usr/bin/qemu-arm-static /bin/sh

# We need to simulate what's append in the dockerfile build process
# See https://www.balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/

# Replace the sh command with qemu enabled
cross-build-start
# Run command
/bin/sh -c "$@"
cross-build-end

