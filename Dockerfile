FROM alpine:3.12
ARG BUILDPLATFORM
ARG TARGETARCH

ADD download.sh /tmp
RUN sed -e 's;^#http\(.*\)/\([^/]\+\)/community;http\1/\2/community;g' -i /etc/apk/repositories
RUN apk update \
    && apk upgrade \
    && apk add git mopidy alsa-utils alsa-lib alsaconf py3-pip snapcast-client snapcast-server shadow gst-plugins-bad gst-plugins-base \
    && pip install Mopidy-Mpd \
    && pip install Mopidy-Local \
    && pip install Mopidy-Iris \
    && pip install git+http://github.com/abates/mopidy-pandora@issue-74 \
    && /tmp/download.sh \
    && tar xzf /tmp/s6overlay.tar.gz -C / \
    && rm /tmp/s6overlay.tar.gz 
    #&& pip install git+https://github.com/mopidy/mopidy-pandora \

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

# Disable Local Sound
ENV DISABLE_LOCAL "false"

# 1704     - snapcast stream
# 1705/tcp - snapcast tcp rpc
# 1780/tcp - snapcast http
# 6600/tcp - mopidy mpd
# 6680/tcp - mopidy http
EXPOSE 1704 1705/tcp 1780/tcp 6600/tcp 6680/tcp

ENTRYPOINT ["/init"]
