FROM jupyter/datascience-notebook:ae5f7e104dd5

USER $NB_UID

# Additional python library
RUN pip install --no-cache-dir pyensae
