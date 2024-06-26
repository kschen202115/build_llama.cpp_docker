ARG UBUNTU_VERSION=22.04

FROM ubuntu:$UBUNTU_VERSION as build

RUN apt-get update && \
    apt-get install -y build-essential git libcurl4-openssl-dev

WORKDIR /app

# Clone the git repository directly to the current directory and enter the llama.cpp directory
RUN git clone https://github.com/ggerganov/llama.cpp.git . 



ENV LLAMA_CURL=1

RUN make -j$(nproc)

FROM ubuntu:$UBUNTU_VERSION as runtime

RUN apt-get update && \
    apt-get install -y libcurl4-openssl-dev libgomp1

COPY --from=build /app/server /server

ENV LC_ALL=C.utf8

ENTRYPOINT [ "/server" ]
