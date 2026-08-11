# This file is managed with Terraform!
FROM ${image_source_uri} AS base

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive \
    TERM=xterm-256color \
    TZ=Etc/UTC \
    pkg='apt-get install -qqy --no-install-recommends'

# Upgrade because openvpn-as is not updated often and will have vulnerabilties
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get -qq update && \
    apt-get -yqq upgrade && \
    $pkg curl unzip && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o 'awscliv2.zip' && \
    unzip -q awscliv2.zip && \
    rm awscliv2.zip && \
    aws/install && \
    rm -r aws && \
    apt-get remove -qqy curl unzip && \
    apt-get autoremove -qqy && \
    apt-get clean -qqy && \
    rm -rf /var/lib/apt/lists/*

COPY --chown=root:root ./docker/entry_point.sh /entry_point.sh
# Copy factory config into read-only location
RUN chmod 755 /entry_point.sh && \
    mkdir -p /var/opt/openvpn_as && \
    cp -a /usr/local/openvpn_as/* /var/opt/openvpn_as/ && \
    chown -R openvpn_as:openvpn_as /var/opt/openvpn_as

ENTRYPOINT ["/entry_point.sh"]
CMD ["/usr/local/openvpn_as/scripts/openvpnas", "--nodaemon", "--pidfile=/ovpn/tmp/openvpn.pid"]

FROM base AS local

FROM base AS remote
