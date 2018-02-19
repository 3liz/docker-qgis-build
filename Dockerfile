# Need docker above v17-05.0-ce
ARG REGISTRY_PREFIX=''

FROM  ${REGISTRY_PREFIX}debian:stretch
MAINTAINER David Marteau <david.marteau@3liz.com>

LABEL Description="Docker container with QGIS dependencies" Vendor="3liz.org" Version="1.0"

ENV DEBIAN_FRONTEND noninteractive

RUN  export DEBIAN_FRONTEND=noninteractive && dpkg-divert --local --rename --add /sbin/initctl \
  &&  apt-get update \
  && apt-get install -y software-properties-common ca-certificates --no-install-recommends \
  && apt-get install -y --no-install-recommends \
    python3-setuptools \
  && easy_install3 pip \
  && apt-get remove -y python3-setuptools \
  && apt-get install -y --no-install-recommends \
    bison \
    ccache \
    clang \
    cmake \
    dh-python \
    flex \
    gdal-bin \
    git \
    graphviz \
    grass-dev \
    libexpat1-dev \
    libfcgi-dev \
    libgdal-dev \
    libgeos-dev \
    libgsl-dev \
    libpq-dev \
    libproj-dev \
    libqca-qt5-2-dev \
    libqca-qt5-2-plugins \
    libqt5opengl5-dev \
    libqt5scintilla2-dev \
    libqt5sql5-sqlite \
    libqt5svg5-dev \
    libqt5webkit5-dev \
    libqt5xmlpatterns5-dev \
    libqwt-qt5-dev \
    libspatialindex-dev \
    libspatialite-dev \
    libsqlite3-dev \
    libsqlite3-mod-spatialite \
    libzip-dev \
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
    python3-gdal \
    python3-httplib2 \
    python3-jinja2 \
    python3-markupsafe \
    python3-mock \
    python3-pygments \
    python3-pyproj \
    python3-pyqt5 \
    python3-pyqt5.qsci \
    python3-pyqt5.qtsql \
    python3-pyqt5.qtsvg \
    python3-sip \
    python3-sip-dev \
    python3-six \
    python3-termcolor \
    python3-tz \
    qt5-default \
    qt5keychain-dev \
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
    xvfb \
  && pip3 install \
    psycopg2 \
    numpy  \
    owslib \
    pyyaml \
    nose2  \
  && apt-get autoremove -y --purge exim4  exim4-base exim4-config exim4-daemon-light \
  && apt-get clean


ENV CC=/usr/lib/ccache/clang
ENV CXX=/usr/lib/ccache/clang++
ENV QT_SELECT=5
ENV LANG=C.UTF-8

CMD /root/src/docker-build-test.sh

