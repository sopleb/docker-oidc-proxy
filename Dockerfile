FROM openresty/openresty:1.21.4.1-0-alpine
MAINTAINER Hans Kristian Flaatten <hans.flaatten@evry.com>

ENV \
 SESSION_VERSION=4.04 \
 HTTP_VERSION=0.17.1 \
 OPENIDC_VERSION=1.7.6 \
 JWT_VERSION=0.2.3 \
 HMAC_VERSION=0.06-1

RUN apk update && apk upgrade && apk add curl tar

RUN \
 cd /tmp && \
 curl -sSL https://github.com/bungle/lua-resty-session/archive/v${SESSION_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/pintsized/lua-resty-http/archive/v${HTTP_VERSION}.tar.gz | tar xz  && \
 curl -sSL https://github.com/pingidentity/lua-resty-openidc/archive/v${OPENIDC_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/cdbattags/lua-resty-jwt/archive/v${JWT_VERSION}.tar.gz | tar xz && \
 curl -sSL https://github.com/jkeys089/lua-resty-hmac/archive/${HMAC_VERSION}.tar.gz | tar xz && \
 cp -r /tmp/lua-resty-session-${SESSION_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-http-${HTTP_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-openidc-${OPENIDC_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-jwt-${JWT_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 cp -r /tmp/lua-resty-hmac-${HMAC_VERSION}/lib/resty/* /usr/local/openresty/lualib/resty/ && \
 rm -rf /tmp/* && \
 mkdir -p /usr/local/openresty/nginx/conf/hostsites/ && \
 true

COPY bootstrap.sh /usr/local/openresty/bootstrap.sh
COPY nginx /usr/local/openresty/nginx/

ENTRYPOINT ["/usr/local/openresty/bootstrap.sh"]
