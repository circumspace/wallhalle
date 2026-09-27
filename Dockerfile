# One Dockerfile, four targets:
#   dev    tooling for dev.sh; the repo is bind-mounted, nothing is copied
#   tools  the cluster Job (scripts/cluster-sync.sh): fetches originals and
#          derives thumbnails, previews and cuts onto the shared volume
#   build  Hugo build plus link check; this is the CI gate
#   site   (default) nginx serving the Hugo output
# No painting file enters an image. Originals, cuts, thumbnails and previews
# live on the volume the Job fills and the site pod mounts; see
# nginx/default.conf.

ARG ALPINE=3.22

FROM alpine:${ALPINE} AS base
RUN apk add --no-cache vips-tools yq curl

FROM base AS dev
RUN apk add --no-cache hugo libqrencode-tools
WORKDIR /src
EXPOSE 6131

# uid 101 is the nginx-unprivileged user of the site image, so files the Job
# writes are readable by the site pod without fsGroup, which local-path
# volumes do not apply anyway.
FROM base AS tools
RUN adduser -D -u 101 -h /app app
WORKDIR /app
COPY bundled/ bundled/
COPY scripts/ scripts/
COPY content/ content/
USER 101
ENTRYPOINT ["scripts/cluster-sync.sh"]

FROM alpine:${ALPINE} AS build
RUN apk add --no-cache hugo
WORKDIR /src
COPY config/ config/
COPY layouts/ layouts/
COPY assets/ assets/
COPY static/ static/
COPY scripts/check-links.sh scripts/
COPY data/ data/
COPY content/ content/
RUN hugo && scripts/check-links.sh

FROM nginxinc/nginx-unprivileged:1.29-alpine AS site
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/public/ /usr/share/nginx/html/
