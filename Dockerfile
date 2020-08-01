FROM alpine:edge
ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp
RUN /tmp/download.sh \
    && apk update \
    && apk upgrade \
    && apk add git mopidy alsa-utils alsa-lib alsaconf py3-pip snapcast-client snapcast-server shadow gst-plugins-bad gst-plugins-base \
    && tar xzf /tmp/s6overlay.tar.gz -C / \
    && rm /tmp/s6overlay.tar.gz \
    && pip install Mopidy-Mpd \
    && pip install Mopidy-Local \
    && pip install Mopidy-Iris \
    #&& pip install git+https://github.com/mopidy/mopidy-pandora \
    && pip install git+http://github.com/abates/mopidy-pandora@issue-74

COPY root/ /

VOLUME ["/config"]
VOLUME ["/data"]
VOLUME ["/media"]

# UID/GID
ENV MOPIDY_UID ""
ENV MOPIDY_GID ""
ENV AUDIO_GID ""

# Audio output config variable
ENV AUDIO_OUTPUT ""

# 1704     - snapcast stream
# 1705/tcp - snapcast tcp rpc
# 1780/tcp - snapcast http
# 6600/tcp - mopidy mpd
# 6680/tcp - mopidy http
EXPOSE 1704 1705/tcp 1780/tcp 6600/tcp 6680/tcp

ENTRYPOINT ["/init"]
