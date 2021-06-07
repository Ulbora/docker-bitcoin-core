FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

ENV BITCOIN_PGP_KEY 01EA5486DE18A882D4C2684590C8019E36C2E964

ENV BITCOIN_URL https://bitcoin.org/bin/bitcoin-core-0.21.1/
ENV BITCOIN_FILE bitcoin-0.21.1-x86_64-linux-gnu.tar.gz

ENV BITCOIN_ASC_URL https://bitcoin.org/bin/bitcoin-core-0.21.1/SHA256SUMS.asc


RUN apt-get update  
RUN apt-get install -y wget
RUN apt-get install -y ca-certificates

RUN apt-get install -y gpg

RUN set -ex \
    && cd /tmp \
    && wget "$BITCOIN_URL$BITCOIN_FILE" \
    && wget "$BITCOIN_ASC_URL" \
    && gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$BITCOIN_PGP_KEY" \
    && sha256sum --ignore-missing --check SHA256SUMS.asc \
    && gpg --verify SHA256SUMS.asc \
    && sha256sum "$BITCOIN_FILE" \
    && sha256sum --ignore-missing --check SHA256SUMS.asc \
    && tar -xzvf "$BITCOIN_FILE" -C /usr/local --strip-components=1 --exclude=*-qt \
    && rm -rf /tmp/* 



RUN set -ex ls -l

RUN set -ex ls -l /tmp

RUN set -ex ls -l /usr/local

RUN set -ex ls -l /usr/local/bin

RUN set -ex ls -l /usr/local/lib




ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" 
RUN chown -R bitcoin:bitcoin "$BITCOIN_DATA" 
RUN ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin 
RUN chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin
VOLUME /data

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333 18443 18444
CMD ["bitcoind"]

