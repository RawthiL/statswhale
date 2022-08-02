ARG UBUNTU_VERSION=20.04
ARG CUDA=11.2.2

FROM nvidia/cuda:${CUDA}-cudnn8-runtime-ubuntu${UBUNTU_VERSION}

ENV TZ=America/Argentina
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated  \
    build-essential  \
    ca-certificates  \
    curl  \
    git  \
    emacs  \
    wget  \
    vim  \
    libffi-dev \
    libssl-dev  \
    libbz2-dev  \
    libreadline-dev  \
    libsqlite3-dev  \
    llvm  \
    libncurses5-dev \
    libncursesw5-dev  \
    xz-utils  \
    tk-dev  \
    python-openssl  \
    openssh-client \
    openssh-server \
    zlib1g-dev  \
    libgtk2.0-dev  \
    pkg-config \
    software-properties-common  \
    unzip \
    nano \
    cmake \
    libpoppler-cpp-dev \
    poppler-utils \
    default-jdk \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


#Installing the python dependencies
RUN apt-get update  \
  && apt-get install -y --no-install-recommends \
  python3-pip=20.0.2-5ubuntu1.6 \
  python3-dev=3.8.2-0ubuntu2 \
  && ln -s /usr/bin/python3 /usr/local/bin/python \
  && apt-get clean && rm -rf /var/lib/apt/lists/*


# Install graphtool
RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
    apt-utils \
    wget \
    bzip2 \
    gcc \
    g++ \
    libboost-all-dev \
    libexpat1-dev \
    libcgal-dev \
    libsparsehash-dev \
    libcairomm-1.0-dev \
    python3-cairo \
    python3-cairo-dev \
    graphviz \
    gir1.2-gtk-3.0 \
    python3-gi-cairo \
    python3-matplotlib \
    python3-pygraphviz \
    python3-scipy \
    python3-numpy \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


RUN echo "deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keys.openpgp.org --recv-key 612DEFB798507F25
RUN add-apt-repository "deb [ arch=amd64 ] https://downloads.skewed.de/apt focal main"
RUN apt update
RUN apt-get update && apt-get install -y --no-install-recommends --allow-unauthenticated \
    python3-graph-tool \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# add user
RUN useradd -ms /bin/bash statswhale && chown -R statswhale:statswhale /home/statswhale
USER statswhale

#Set the work directory
WORKDIR /home/statswhale


# Python stuff
RUN pip3 install --no-cache-dir Pillow==9.0.0
COPY requirements_base.txt /home/statswhale/requirements_base.txt
RUN pip3 install --no-cache-dir -r requirements_base.txt
COPY requirements.txt /home/statswhale/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Add local bin to path
ENV PATH /home/statswhale/.local/bin:$PATH

#Setting Jupyter notebook configurations 
RUN mkdir /home/statswhale/.jupyter/
RUN jupyter notebook --generate-config --allow-root
# Make connection easy
RUN echo "c.NotebookApp.token = ''" > /home/statswhale/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.password = ''" >> /home/statswhale/.jupyter/jupyter_notebook_config.py
# Make it (more) insecure to be able to use the plot function of pyntcloud in jupyther...
RUN echo "c.NotebookApp.allow_origin = '*' #allow all origins" >> /home/statswhale/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.disable_check_xsrf = True" >> /home/statswhale/.jupyter/jupyter_notebook_config.py

RUN jupyter nbextension enable --py widgetsnbextension

#Run the command to start the Jupyter server
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
