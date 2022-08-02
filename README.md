# Deep Learning and Statistical Analysis Jupyter design environment 

This docker is intended to be used as a design/test environment for deep learning projects. It is statistical analysis oriented but it also contains many other libraries that I find useful. The highlights are:

### General stuff
- **TensorFlow 2.9** : Backbone for DL with tensorflow-hub for transfer learning.
- **Scikit** : Always useful.
- **pandas** : Essential for data handling (and uninstalling Excel).
- **pydot** and **scikit-multilearn** : Useful for multi-label problems and graph analysis. The pydot plot function is working with *cairo*.
- **BeautifulSoup4** : Along with **html5lib** for data extraction.
- **pymongo**, **psycopg2-binary** : For Mongo and PostgreSQL reading.

### Stats stuff
- **tensorflow-probability 0.17.0** : For probabilistic design.

## Other characteristics of the system:

- Ubuntu 20.04
- CUDA 11.2.2
- CUDNN 8.1.1
- Python 3.8.10

# Usage

### Build

`docker build -t statswhale:tf-2.9 .`

### Single Jupyter service

`docker run -u $UID:$UID --gpus all -v <path to code folder>:/home/statswhale/code -v <path to datasets folder (optional)>:/home/statswhale/datasets -p 8888:8888 -p 6006:6006 -it statswhale:tf-2.9`

Happy codding!
