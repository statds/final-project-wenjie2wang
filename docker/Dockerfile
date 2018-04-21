##############################################################################
### Please see the README file for usage
###
### This Dockerfile was written based on the following reference:
###
### https://github.com/rocker-org/rocker (under GPL v2.0 license),
### https://github.com/floydhub/dl-docker
###
### and under the same GPL v2.0 license with rocker.
### Please see <https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html>
### for a copy of the GPL v2.0 license
##############################################################################


FROM ubuntu:16.04

MAINTAINER "Wenjie Wang" wjwang.stat@gmail.com

ENV R_BASE_VERSION 3.4.4
ARG THEANO_VERSION=rel-0.8.2
ARG LASAGNE_VERSION=37ca13459c95dac314c344b0c7c236270c4a69f1
ARG LIFELINES_VERSION=v0.14.0
ARG TBLOG_VERSION=0.1.0

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group,
## granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory
## (for rstudio or linked volumes to work properly).
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		wget \
		ca-certificates \
                bc \
		build-essential \
		cmake \
		curl \
                ed \
                fonts-texgyre \
		g++ \
		gfortran \
		git \
      		less \
		libffi-dev \
		libfreetype6-dev \
		libhdf5-dev \
		libjpeg-dev \
		liblcms2-dev \
		libopenblas-dev \
		liblapack-dev \
		libopenjpeg5 \
		libpng12-dev \
		libssl-dev \
		libtiff5-dev \
		libwebp-dev \
		libzmq3-dev \
                locales \
		nano \
		pkg-config \
		python-dev \
		software-properties-common \
		unzip \
		zlib1g-dev \
		qt5-default \
		libvtk6-dev \
		zlib1g-dev \
		libjpeg-dev \
		libwebp-dev \
		libpng-dev \
		libtiff5-dev \
		libjasper-dev \
		libopenexr-dev \
		libgdal-dev \
		libdc1394-22-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libtheora-dev \
		libvorbis-dev \
		libxvidcore-dev \
		libx264-dev \
		yasm \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libv4l-dev \
		libxine2-dev \
		libtbb-dev \
		libeigen3-dev \
		python-dev \
		python-tk \
		python-numpy \
		python3-dev \
		python3-tk \
		python3-numpy \
		ant \
		default-jdk \
		doxygen \
		&& \
	apt-get clean && \
	apt-get autoremove && \
	rm -rf /var/lib/apt/lists/* && \
        ## Link BLAS library to use OpenBLAS using the alternatives mechanism
        ## https://www.scipy.org/scipylib/building/linux.html#debian-ubuntu
	update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## prepare for installing R
RUN echo "deb http://cloud.r-project.org/bin/linux/ubuntu xenial/" >> \
    /etc/apt/sources.list && \
    # echo "deb http://cloud.r-project.org/ \
    # trusty-backports main restricted universe" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

## Now install R and littler, and create a link for littler in /usr/local/bin
## Also set a default CRAN repo, and make sure littler knows about it too
RUN apt-get update -y \
	&& apt-get install -y --no-install-recommends \
		littler \
                r-cran-littler \
		r-base=${R_BASE_VERSION}-* \
		r-base-dev=${R_BASE_VERSION}-* \
		r-recommended=${R_BASE_VERSION}-* \
        && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"),\
           download.file.method = "libcurl")' >> /etc/R/Rprofile.site \
        && echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r \
	&& ln -s /usr/share/doc/littler/examples/install.r /usr/local/bin/install.r \
	&& ln -s /usr/share/doc/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/share/doc/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
	&& ln -s /usr/share/doc/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
	&& install.r docopt \
	&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
	&& rm -rf /var/lib/apt/lists/*

## install some R packages


## install pip
RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
	python3 get-pip.py && \
	rm get-pip.py

## install useful Python packages using apt-get to avoid version
## incompatibilities with Tensorflow binary especially numpy, scipy, skimage
## and sklearn (see https://github.com/tensorflow/tensorflow/issues/2034)
# RUN apt-get update && apt-get install -y \
# 		python-numpy \
# 		python-scipy \
# 		python-nose \
# 		python-h5py \
# 		python-skimage \
# 		python-matplotlib \
# 		python-pandas \
# 		python-sklearn \
# 		python-sympy \
# 		&& \
# 	apt-get clean && \
# 	apt-get autoremove && \
# 	rm -rf /var/lib/apt/lists/*

## install lifelines
RUN pip3 --no-cache-dir install \
    git+https://github.com/CamDavidsonPilon/lifelines.git@${LIFELINES_VERSION}

## install tensorboard_logger
RUN pip3 --no-cache-dir install \
    git+https://github.com/TeamHG-Memex/tensorboard_logger.git@${TBLOG_VERSION}

## install Theano and set up Theano config (.theanorc) OpenBLAS
RUN pip3 --no-cache-dir install \
    git+https://github.com/Theano/Theano.git@${THEANO_VERSION} && \
	echo "[global]\ndevice=cpu\nfloatX=float32\nmode=FAST_RUN \
		\n[lib]\ncnmem=0.95 \
		\n[nvcc]\nfastmath=True \
		\n[blas]\nldflag = -L/usr/lib/openblas-base -lopenblas \
		\n[DebugMode]\ncheck_finite=1" \
	> /root/.theanorc

## install Lasagne
RUN pip3 --no-cache-dir install \
    git+https://github.com/Lasagne/Lasagne.git@${LASAGNE_VERSION}

## install h5py and matplotlib
RUN pip3 --no-cache-dir install \
    git+https://github.com/h5py/h5py.git@2.8.0rc1 && \
    pip3 --no-cache-dir install \
    git+https://github.com/matplotlib/matplotlib.git@v2.2.2

## install tensorflow and tensorboard
RUN pip3 --no-cache-dir install \
    https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.7.0-cp35-cp35m-linux_x86_64.whl

## clone the project from github and set it up
RUN cd /root && \
    git clone https://github.com/wenjie2wang/statds-spring2018.git \
    statds-project && cd statds-project && \
    git submodule update --init --recursive && \
    cd /root/statds-project && bash fresh-start.sh

# Expose Port for TensorBoard
EXPOSE 6006


WORKDIR "/root/statds-project"
CMD ["/bin/bash"]
