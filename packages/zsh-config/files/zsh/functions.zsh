#!/usr/bin/env bash

source /usr/share/makepkg/util/message.sh

function md2html() {
  if [ "$1" = "-h" -o "$1" = "--help" -o -z "$1" ]
  then
    printf "This function takes one argument: The markdown file to convert to html\n"
  else
    md_name="$1"
    html_name="$(echo "$md_name" | sed -e 's/\.md$/.html/g')"
    if [ "$html_name" = "$md_name" ]
    then
      printf "File does not end in .md!\n"
    else
      printf "Converting '$md_name' to '$html_name'...\n"
      if [ -e "$md_name" ]
      then
        pandoc -o "$html_name" "$md_name" --standalone --mathjax
      else
        prinf "Sorry, $md_name does not exist!\n"
      fi
    fi
  fi
}

function nginx-start {
  local config
  config=$(mktemp)
  cat > $config <<EOF
server {
    listen       8080;
    listen  [::]:8080;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
        autoindex on;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF

  printf "\033[0;1m\033[0;96mStarting nginx on port 8080 in the current directory.\nPress Ctrl+C to exit.\033[0;0m\n"
  podman run --rm -it \
    --name nginx \
    -v "$(pwd):/usr/share/nginx/html:ro" \
    -v "$config:/etc/nginx/conf.d/default.conf:ro"\
    -p "8080:8080" \
    docker.io/library/nginx:latest
}

function hugo-proxy {
  local config
  config=$(mktemp)
  cat > $config <<EOF
server {
    listen       8080;
    listen  [::]:8080;
    server_name  localhost;

    location / {
        proxy_pass http://localhost:1313;
    }

    # redirect server error pages to the static page /50x.html
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
EOF

  printf "\033[0;1m\033[0;96mStarting nginx on port 8080 as a proxy to port 1313.\nPress Ctrl+C to exit.\033[0;0m\n"
  podman run --rm -it \
    --name hugo-proxy \
    -v "$(pwd):/usr/share/nginx/html:ro" \
    -v "$config:/etc/nginx/conf.d/default.conf:ro"\
    --network=host \
    docker.io/library/nginx:latest
}

