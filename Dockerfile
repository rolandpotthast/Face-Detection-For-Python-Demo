
FROM python:3.10-slim-bookworm

# --- proxy support (REQUIRED on DWD networks) ---
ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG NO_PROXY

ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV NO_PROXY=${NO_PROXY}
# -----------------------------------------------

ARG DEBIAN_FRONTEND=noninteractive

USER root

# Run base setup
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash dwd
USER dwd

WORKDIR /home/dwd

# Set environment variables for the virtual environment
ENV VIRTUAL_ENV=/home/dwd/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m venv $VIRTUAL_ENV

COPY --chown=dwd requirements.txt .
RUN pip3 install -r requirements.txt

# Add face.py, make it executable and add it to PATH
COPY --chown=dwd face.py .
RUN chmod 775 face.py && ln -s $PWD/face.py $VIRTUAL_ENV/bin/face.py

ENTRYPOINT ["face.py"]
