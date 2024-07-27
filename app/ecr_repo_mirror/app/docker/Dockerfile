FROM public.ecr.aws/ubuntu/ubuntu:24.04

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    TZ=Etc/UTC \
    pkg='apt-get install -qqy --no-install-recommends'

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get -qq update && \
    $pkg curl less make python-is-python3 python3-pip python3-venv skopeo unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o 'awscliv2.zip' && \
    unzip -q awscliv2.zip && \
    rm awscliv2.zip && \
    aws/install && \
    rm -r aws && \
    apt-get remove -qqy curl unzip && \
    apt-get autoremove -qqy && \
    apt-get clean -qqy && \
    rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /home/ubuntu

COPY requirements/ ./requirements/
COPY Makefile ./
RUN make env-install

CMD ["make", "ecr-mirror"]
