FROM alpine:edge
ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp
RUN /tmp/download.sh \
    && apk update \
    && apk upgrade \
    && apk add mopidy alsa-utils alsa-lib alsaconf py3-pip snapcast-server shadow \
    && tar xzf /tmp/s6overlay.tar.gz -C / \
    && rm /tmp/s6overlay.tar.gz \
    && pip install Mopidy-Local \
    && pip install Mopidy-Iris \
    && pip install Mopidy-Pandora \
    && mkdir -p /config /data/cache /data/data /data/local /data/log /data/media /data/playlists

COPY root/ /

VOLUME ["/config"]
VOLUME ["/data"]
VOLUME ["/media"]

# UID/GID
ENV MOPIDY_UID ""
ENV MOPIDY_GID ""
ENV AUDIO_GID ""

# Audio output config variable
ENV AUDIO_OUTPUT autoaudiosink


ENTRYPOINT ["/init"]
