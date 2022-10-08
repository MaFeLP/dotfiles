#!/usr/bin/env bash

function md2html() {
  if [ "$1" = "-h" -o "$1" = "--help" -o -z "$1" ]
  then
    echo "This function takes one argument: The markdown file to convert to html"
  else
    md_name="$1"
    html_name="$(echo "$md_name" | sed -e 's/\.md$/.html/g')"
    if [ "$html_name" = "$md_name" ]
    then
      echo "File does not end in .md!"
    else
      echo "Converting '$md_name' to '$html_name'..."
      if [ -e "$md_name" ]
      then
        pandoc -o "$html_name" "$md_name" --standalone --mathjax
      else
        echo "Sorry, $md_name does not exist!"
      fi
    fi
  fi
}

function nginx-start {
  local config
  config=$(mktemp)
  cat > $config <<EOF
server {
    listen       80;
    listen  [::]:80;
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

  echo -e "\033[0;1m\033[0;96mStarting nginx on port 80 in the current directory.\nPress Ctrl+C to exit.\033[0;0m"
  docker run --rm -it \
    --name nginx \
    -v "$(pwd):/usr/share/nginx/html:ro" \
    -v "$config:/etc/nginx/conf.d/default.conf:ro"\
    -p "80:80" \
    nginx:latest
}

function wayd {
  case "$1" in
    start)
      echo -e "\033[0;1m\033[0;96mStarting waydroid...\nenter 'wayd exit' to exit.\033[0;0m"
      sudo systemctl start waydroid-container.service
      waydroid session start &
      ;;
    stop)
      echo -e "\033[0;1m\033[0;96mStarting waydroid...\nenter 'wayd exit' to exit.\033[0;0m"
      waydroid session stop
      sudo systemctl stop waydroid-container.service
      ;;
    ui)
      waydroid show-full-ui
      ;;
    *)
      cat <<EOF
wayd is a Waydroid helper function. Avaliable options:

  wayd start      Starts the Waydroid session
  wayd stop       Stops the Waydroid session
  wayd ui         Shows the full UI of waydroid
  wayd help       Displays this help text
EOF
      ;;
  esac
}

function hugo-new {
  name="$(date +'%Y-%m-%d')-$1"
  echo "Creating new blog entry: $name"
  hugo new "blog/$name.md"
  mkdir -v "content/blog/$name/"
  mv "content/blog/$name.md" "content/blog/$name/index.md"
  $EDITOR "content/blog/$name/index.md"
}

function stfu {
  echo "Command:"
  echo $@
  $@ &> /dev/null &
  echo "Process ID:"
  disown
}
