FROM public.ecr.aws/lts/ubuntu:latest

SHELL ["/bin/bash", "-c"]
ARG aws_account
ENV AWS_ACCOUNT=$aws_account
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV TZ=Etc/UTC
ENV pkg='apt-get install -qqy --no-install-recommends'

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -qq update
RUN $pkg ca-certificates curl make python-is-python3 python3-pip python3-venv skopeo unzip
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o 'awscliv2.zip' && \
    unzip -q awscliv2.zip && \
    rm awscliv2.zip && \
    aws/install && \
    rm -r aws

COPY requirements/ ./requirements/
COPY Makefile ./
RUN make env-install

CMD ["make", "ecr-mirror"]
