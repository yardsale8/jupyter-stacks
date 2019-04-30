FROM jupyter/scipy-notebook:f646d2b2a3af

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    libapparmor1 \
		libedit2 \
		lsb-release \
		psmisc \
    libssl1.0.0 \
    gcc && \
    rm -rf /var/lib/apt/lists/*


USER $NB_UID


# R packages
RUN conda install --quiet --yes \
    'r-base=3.5.1' \
    'r-rodbc=1.3*' \
    'unixodbc=2.3.*' \
    'r-irkernel=0.8*' \
    'r-plyr=1.8*' \
    'r-devtools=2.0*' \
    'r-tidyverse=1.2*' \
    'r-shiny=1.2*' \
    'r-rmarkdown=1.11*' \
    'r-forecast=8.2*' \
    'r-rsqlite=2.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=1.0*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' \
    'r-htmltools=0.3*' \
    'r-sparklyr=0.9*' \
    'r-htmlwidgets=1.2*' \
    'r-hexbin=1.27*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

USER root

# You can use rsession from rstudio's desktop package as well.
ENV RSTUDIO_PKG=rstudio-server-1.0.136-amd64.deb

RUN wget -q http://download2.rstudio.org/${RSTUDIO_PKG}
RUN dpkg -i ${RSTUDIO_PKG}
RUN rm ${RSTUDIO_PKG}

RUN apt-get clean && \
rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

USER $NB_UID

RUN pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy

# Additional python library
RUN pip install --no-cache-dir pyensae

# The desktop package uses /usr/lib/rstudio/bin
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"
ENV LD_LIBRARY_PATH="/usr/lib/R/lib:/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server:/opt/conda/lib/R/lib"

