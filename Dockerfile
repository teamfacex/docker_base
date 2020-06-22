FROM ubuntu:18.04

RUN apt-get -qq update && apt-get -qq install --no-install-recommends -y python3 \ 
 		bc \
		build-essential \
		cmake \
		curl \
		g++ \
		gfortran \
		git \
		libffi-dev \
		libfreetype6-dev \
		libhdf5-dev \
		libjpeg-dev \
		liblcms2-dev \
		libopenblas-dev \
		liblapack-dev \
		libpng-dev \
		libssl-dev \
		libtiff5-dev \
		libwebp-dev \
		libzmq3-dev \
		nano \
		pkg-config \
		python3-dev \
		software-properties-common \
		unzip \
		vim \
		wget \
		zlib1g-dev \
		qt5-default \
		libvtk6-dev \
		zlib1g-dev \
		libwebp-dev \
		libpng-dev \
		libtiff5-dev \
		libopenexr-dev \
		libgdal-dev \
		libdc1394-22-dev \
		libavcodec-dev \
		libavformat-dev \
		libswscale-dev \
		libtheora-dev \
		libvorbis-dev \
		libxvidcore-dev \
                libx11-dev \ 
                libatlas-base-dev \
                libgtk-3-dev \
                libboost-python-dev \
		libx264-dev \
		yasm \
		libopencore-amrnb-dev \
		libopencore-amrwb-dev \
		libv4l-dev \
		libxine2-dev \
		libtbb-dev \
		libeigen3-dev \
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
        update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3
RUN wget -q -O /tmp/get-pip.py --no-check-certificate https://bootstrap.pypa.io/get-pip.py && python3 /tmp/get-pip.py
RUN  pip  --no-cache-dir  install  \
                requests \
          	json_tricks \ 
          	Flask \
		pyopenssl \
		ndg-httpsclient \
		pyasn1 \ 
		annoy	\
		crython	\
		quart
# Install useful Python packages using apt-get to avoid version incompatibilities with Tensorflow binary
# especially numpy, scipy, skimage and sklearn (see https://github.com/tensorflow/tensorflow/issues/2034)
RUN apt-get update && apt-get -qq install --no-install-recommends -y  \
		python3-numpy \
		python3-scipy \
		python3-nose \
		python3-h5py \
		python3-skimage \
		python3-matplotlib \
		python3-pandas \
		python3-sklearn \
		python3-sympy \
        python3-pil \
		&& \
	    apt-get clean && \
	    apt-get autoremove && \
        rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/opencv/opencv/archive/4.1.0.zip  && \
	 unzip 4.1.0.zip && \
         rm 4.1.0.zip && \
         mv opencv-4.1.0 OpenCV && \ 
         cd OpenCV && \
         mkdir build && \
         cd build && \
         cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DENABLE_PRECOMPILED_HEADERS=OFF .. && \
         make -j4 && \
         make install && \
         ldconfig 


RUN wget http://dlib.net/files/dlib-19.6.tar.bz2 && \
	tar xvf dlib-19.6.tar.bz2 && \
	cd dlib-19.6/ && \
	mkdir build && \
	cd build && \ 
	cmake .. 	 -DUSE_AVX_INSTRUCTIONS=1 && \
	cmake --build . --config Release && \
	make install && \
	ldconfig && \
	cd .. && \
        pkg-config --libs --cflags dlib-1 && \ 
        python3 setup.py install --yes USE_AVX_INSTRUCTIONS --yes DLIB_USE_CUDA &&\
	rm -rf dist && \
	rm -rf tools/python/build && \
	rm python_examples/dlib.so 

