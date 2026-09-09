# Site image. Unlike the blog and website repos this one builds Hugo in a
# stage instead of copying a prebuilt public/: the repo has no host
# toolchain by design (everything runs in containers), so a two-stage
# build is the same tooling locally and in CI. Cuts and originals are
# not in the image; see nginx/default.conf.
FROM alpine:3.22 AS build
RUN apk add --no-cache hugo
WORKDIR /src
COPY . .
RUN hugo --minify

FROM nginxinc/nginx-unprivileged:1.29-alpine
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/public/ /usr/share/nginx/html/
