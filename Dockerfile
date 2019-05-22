FROM jupyter/datascience-notebook:7f1482f

USER $NB_UID
# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

USER $NB_UID

# Additional python library
#RUN pip install --no-cache-dir pyensae

#USER ${NB_USER}
