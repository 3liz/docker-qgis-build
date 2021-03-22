#!/bin/bash

#
# Set up xvfb
# https://www.x.org/archive/X11R7.6/doc/man/man1/Xvfb.1.xhtml
# see https://www.x.org/archive/X11R7.6/doc/man/man1/Xserver.1.xhtml
#
if [[ ! -e /tmp/.X11-unix  ]]; then
    echo "Starting Xvfb"
    XVFB_DEFAULT_ARGS="-screen 0 1024x768x24 -ac +extension GLX +render -noreset"
    XVFB_ARGS=${QGSRV_XVFB_ARGS:-":99 $XVFB_DEFAULT_ARGS"}
    nohup /usr/bin/Xvfb $XVFB_ARGS &
    export DISPLAY=":99"
fi

exec bash --rcfile /usr/local/bin/bashrc -i

