FROM continuumio/miniconda3:latest

RUN git clone https://github.com/broadinstitute/cds-ensemble.git 

RUN cd cds-ensemble && \ 
    pip install -r requirements.txt

RUN python setup.py install

