FROM jupyter/base-notebook:python-3.9

USER jovyan

RUN python -m pip install --upgrade pip

RUN pip install --find-links=https://girder.github.io/large_image_wheels --no-cache GDAL==3.8.0
RUN pip install localtileserver==0.7.2
RUN pip install geopandas==0.14.0
RUN pip install leafmap==0.27.0
RUN pip install scikit-learn==1.1.1
RUN pip install pyarrow==13.0.0
RUN pip install jupyter-server-proxy==4.1.0

ENV JUPYTER_ENABLE_LAB=yes

ARG LOCALTILESERVER_CLIENT_PREFIX='proxy/{port}'
ENV LOCALTILESERVER_CLIENT_PREFIX=$LOCALTILESERVER_CLIENT_PREFIX