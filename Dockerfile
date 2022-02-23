FROM python:3.10-bullseye
ENV PYTHONUNBUFFERED=1
WORKDIR /app 

ARG USER=vscode
ARG UID=1000
ARG GID=${UID}
RUN groupadd --gid ${GID} ${USER} \
  && useradd --uid ${UID} --gid ${GID} -m ${USER} \
  && apt-get update \
  && apt-get install -y sudo \
  && echo ${USER} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USER} \
  && chmod 0440 /etc/sudoers.d/${USER} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 

COPY pyproject.toml* poetry.lock* ./
RUN pip install --upgrade pip \
  && pip install poetry \
  && poetry config virtualenvs.in-project true \
  && if [ f pyproject.toml ]; then poetry install; fi \
  && pip cache purge 