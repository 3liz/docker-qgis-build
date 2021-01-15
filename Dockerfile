# Need docker above v17-05.0-ce
ARG SUPER

FROM ${SUPER}

MAINTAINER David Marteau <david.marteau@3liz.com>

LABEL Description="Docker container with QGIS build dependencies" Vendor="3liz.org" Version="1.0"

RUN export DEBIAN_FRONTEND=noninteractive && dpkg-divert --local --rename --add /sbin/initctl \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    python3-setuptools \
  && python3 -m easy_install pip \
  && apt-get remove -y python3-setuptools \
  && apt-get install -y --no-install-recommends \
    bison \
    ccache \
    clang \
    cmake \
    dh-python \
    flex \
    git \
    graphviz \
    libexpat1-dev \
    libfcgi-dev \
    libgeos-dev \
    libgsl-dev \
    libpq-dev \
    libqca-qt5-2-dev \
    libqca-qt5-2-plugins \
    libqt53drender5 \
    libqt5concurrent5 \
    libqt5opengl5-dev \
    libqt5positioning5 \
    libqt5qml5 \
    libqt5quick5 \
    libqt5quickcontrols2-5 \
    libqt5scintilla2-dev \
    libqt5sql5-sqlite \
    libqt5svg5-dev \
    libqt5webkit5-dev \
    libqt5xml5 \
    libqt5xmlpatterns5-dev \
    libqt5serialport5-dev \
    libqwt-qt5-dev \
    libspatialindex-dev \
    libspatialite-dev \
    libsqlite3-dev \
    libsqlite3-mod-spatialite \
    libzip-dev \
    libexiv2-dev \
    lighttpd \
    locales \
    make \
    ninja-build \
    pkg-config \
    poppler-utils \
    postgresql-client \
    pyqt5-dev \
    pyqt5-dev-tools \
    pyqt5.qsci-dev \
    python3-all-dev \
    python3-dateutil \
    python3-dev \
    python3-future \
    python3-psycopg2 \
    python3-httplib2 \
    python3-jinja2 \
    python3-markupsafe \
    python3-mock \
    python3-pygments \
    python3-pyqt5 \
    python3-pyqt5.qsci \
    python3-pyqt5.qtsql \
    python3-pyqt5.qtsvg \
    python3-sip \
    python3-sip-dev \
    python3-six \
    python3-termcolor \
    python3-tz \
    python3-numpy \
    qt5-default \
    qt5keychain-dev \
    qt3d5-dev \
    qt3d-gltfsceneio-plugin \
    qtbase5-dev \
    qtpositioning5-dev \
    qtscript5-dev \
    qttools5-dev \
    qttools5-dev-tools \
    spawn-fcgi \
    txt2tags \
    xauth \
    xfonts-100dpi \
    xfonts-75dpi \
    xfonts-base \
    xfonts-scalable \
    xvfb  \
    gosu  \
    unzip \
    libgl1-mesa-dri \
    bash-completion \
    libprotobuf-dev \
    protobuf-compiler \
    libzstd-dev \
    libnetcdf-dev \
    libhdf4-alt-dev \
    libhdf5-serial-dev \
    flip \
  && apt-get autoremove -y --purge exim4  exim4-base exim4-config exim4-daemon-light \
  && apt-get clean

RUN pip3 install setuptools wheel \
  && pip3 install \
    owslib \
    pyyaml \
    nose2  \
    future \
    oauthlib \
    pyopenssl \
    autopep8

RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
      vim \
      build-essential \
      devscripts \ 
      libdistro-info-perl \
      fakeroot \
      debhelper \
      gpp \
      libyaml-tiny-perl \
      less \
      openssh-client \
    && apt-get clean    

COPY scripts/ /usr/local/bin/

ARG GDAL_INSTALL=default
ARG PROJ_LIBRARY

RUN if [ "$GDAL_INSTALL" = "default" ]; then \
    export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    libproj-dev \
    libgdal-dev \
    python3-pyproj \
    python3-gdal \
    python-gdal \
    gdal-bin \
  && apt-get clean; fi

# Set uid root on Xvfb
RUN chmod u+s /usr/bin/Xvfb

ENV CC=/usr/lib/ccache/clang
ENV CXX=/usr/lib/ccache/clang++
ENV QT_SELECT=5
ENV LANG=C.UTF-8

ENTRYPOINT /usr/local/bin/docker-entrypoint.sh

