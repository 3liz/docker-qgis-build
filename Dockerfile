# vim: ft=dockerfile:

ARG BASE_IMAGE=ubuntu:22.04

FROM ${BASE_IMAGE} as builddeps

MAINTAINER David Marteau <david.marteau@3liz.com>

LABEL Description="Docker container with QGIS build dependencies" Vendor="3liz.org" Version="1.0"

RUN export DEBIAN_FRONTEND=noninteractive && dpkg-divert --local --rename --add /sbin/initctl \
  && apt-get update && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    python3-setuptools \
    python3-wheel \
    python3-venv \
    python3-pip \
    bison \
    ccache \
    clang \
    cmake \
    cmake-curses-gui \
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
    python3-pyqt5.qtpositioning \
    python3-sip \
    python3-sip-dev \
    python3-six \
    python3-termcolor \
    python3-tz \
    python3-numpy \
    python3-owslib \
    python3-lxml \
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

RUN pip3 install \
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

ARG GDAL_INSTALL=default
ARG PROJ_LIBRARY

RUN if [ "$GDAL_INSTALL" = "default" ]; then \
    export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    libproj-dev \
    libgdal-dev \
    python3-pyproj \
    python3-gdal \
    gdal-bin \
  && apt-get clean; fi

# Extra buid library as of Qgis 3.34
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y --no-install-recommends \
    libpdal-dev \
    libdraco-dev \
    qtmultimedia5-dev \
    && apt-get clean
 
# Set uid root on Xvfb
RUN chmod u+s /usr/bin/Xvfb

ENV CC=/usr/lib/ccache/clang
ENV CXX=/usr/lib/ccache/clang++
ENV QT_SELECT=5
ENV LANG=C.UTF-8

COPY scripts/ /usr/local/bin/

ENTRYPOINT /usr/local/bin/builder-docker-entrypoint.sh

# Build stage
FROM builddeps as builder

ARG QGIS_GITURL=https://github.com/qgis/QGIS.git
ARG QGIS_VERSION

RUN mkdir -p /build && cd /build \ 
    && echo "Cloning $QGIS_VERSION $QGIS_GITURL" \
    && git clone --depth 1 -b $QGIS_VERSION $QGIS_GITURL

ARG BUILD_THREADS=8
ARG WITH_DESKTOP=ON
ARG WITH_GRASS=OFF
ARG USE_OPENCL=OFF
ARG WITH_3D=OFF
ARG ENABLE_TESTS=OFF

ENV INSTALL_PREFIX=/qgis-install

COPY bh-qgis.sh /usr/local/bin/bh-qgis.sh
RUN /usr/local/bin/bh-qgis.sh

# Build final image
FROM $BASE_IMAGE as runner

MAINTAINER David Marteau <david.marteau@3liz.com>
LABEL Description="QGIS3 Custom install" Vendor="3liz.org" Version="20.08.0"
ENV DEBIAN_FRONTEND noninteractive
RUN export DEBIAN_FRONTEND=noninteractive \
    && dpkg-divert --local --rename --add /sbin/initctl \
    && apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends apt-transport-https ca-certificates dirmngr gnupg2 wget \
    && apt-get install -y --no-install-recommends \
      python3-setuptools \
      python3-pip \
      python3-wheel \
      python3-psutil \
      unzip \
      gosu \
      iputils-ping \
      xvfb \
      libgl1-mesa-dri \
    && rm -rf /root/.cache


RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y --no-install-recommends \
    libexiv2-27 \
    libexpat1 \
    libfcgi0ldbl \
    libgdal28 \
    libgeos-c1v5 \
    libprotobuf-lite23 \
    libgsl25 \
    libpq5 \
    libproj19 \
    libqca-qt5-2 \ 
    libqt5concurrent5 \ 
    libqt5core5a \
    libqt5gui5 \
    libqt5keychain1 \ 
    libqt5network5 \
    libqt5positioning5 \ 
    libqt5printsupport5 \ 
    libqt5sql5 \
    libqt5svg5 \
    libqt5webkit5 \
    libqt5widgets5 \
    libqt5xml5 \
    libspatialindex6 \ 
    libspatialite7 \
    libsqlite3-0 \
    libzip4 \
    libqca-qt5-2-plugins \
    libqt5sql5-sqlite \
    libxml2 \
    libqscintilla2-qt5-15 \
    libqt5qml5 \
    libqt5dbus5 \ 
    libqt5quick5 \ 
    libqwt-qt5-6 \
    libqt5quickwidgets5 \ 
    libqt5serialport5 \
    libqt5Multimedia5 \
    qt5-image-formats-plugins \
    libsqlite3-mod-spatialite \
    python3-dateutil \
    python3-future \
    python3-httplib2 \
    python3-jinja2 \
    python3-markupsafe \
    python3-owslib \
    python3-plotly \
    python3-psycopg2 \
    python3-pygments \
    python3-pyproj \
    python3-pyqt5 \
    python3-pyqt5.qsci \
    python3-pyqt5.qtsql \
    python3-pyqt5.qtsvg \
    python3-pyqt5.qtwebkit \
    python3-pyqt5.qtpositioning \
    python3-requests \
    python3-sip \
    python3-six \
    python3-tz \
    python3-yaml \
    python3-gdal \
    python3-matplotlib \
    python3-venv \
    gdal-bin \
    && if test "${WITH_3D}" = "ON"; then ( \
        apt-get install -y --no-install-recommends \
        libqt53dcore5 \ 
        libqt53dextras5 \ 
        libqt53dinput5 \
        libqt53dlogic5 \
        libqt53drender5 \ 
        qt3d-assimpsceneimport-plugin \
        qt3d-defaultgeometryloader-plugin \
        qt3d-gltfsceneio-plugin \
        qt3d-scene2d-plugin \
    ); fi \
    && if test "${WITH_OPENCL}" = "ON"; then ( \
        apt-get install -y --no-install-recommends ocl-icd-libopencl1 \
    ); fi \
    && apt-get autoremove -y --purge exim4  exim4-base exim4-config exim4-daemon-light \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Use utf-8 for python 3
ENV LC_ALL="C.UTF-8"

ENV QGIS_DISABLE_MESSAGE_HOOKS=1
ENV QGIS_NO_OVERRIDE_IMPORT=1

COPY --from=builder /qgis-install/ /usr/
COPY --from=builder /usr/lib/x86_64-linux-gnu/qt5 usr/lib/x86_64-linux-gnu/

RUN ldconfig /usr/lib && \
    cd /usr/lib/python3/dist-packages/ && ln -s /usr/share/qgis/python/qgis

# Set uid root on Xvfb
RUN chmod u+s /usr/bin/Xvfb

