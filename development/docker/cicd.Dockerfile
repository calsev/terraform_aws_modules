FROM public.ecr.aws/lts/ubuntu:latest

SHELL ["/bin/bash", "-c"]
ARG TF_VER=1.5.7
ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV TZ=Etc/UTC
ENV pkg='apt-get install -qqy --no-install-recommends'

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -qq update
RUN $pkg binutils ca-certificates curl dpkg-dev git unzip wget
RUN wget -q "https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_$(dpkg-architecture -q DEB_BUILD_ARCH).zip" -O tf.zip && \
    unzip -q tf.zip -d /usr/local/bin && \
    rm tf.zip
RUN git clone https://github.com/aws/efs-utils && \
    cd efs-utils && \
    ./build-deb.sh && \
    $pkg ./build/amazon-efs-utils*deb && \
    cd .. && \
    rm -rf efs-utils
RUN wget -q "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -O 'awscliv2.zip' && \
    unzip -q awscliv2.zip && \
    rm awscliv2.zip && \
    aws/install && \
    rm -r aws
