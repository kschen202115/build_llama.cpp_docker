ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION as build

RUN apt-get update && \
    apt-get install -y build-essential python3 python3-pip git libcurl4-openssl-dev



WORKDIR /app

RUN git clone https://github.com/ggerganov/llama.cpp.git .

RUN pip install --upgrade pip setuptools wheel \
    && pip install -r requirements.txt

ENV LLAMA_CURL=1


RUN make -j$(nproc)

ENV LC_ALL=C.utf8

ENTRYPOINT ["/app/.devops/tools.sh"]
