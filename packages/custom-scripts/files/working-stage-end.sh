#!/usr/bin/bash

notify-send \
        --icon="io.github.diegoivanme.flowtime" \
        --app-name="Flowtime" \
        --expire-time=5000 \
        --urgency=critical \
        "Flowtime" \
        "It's Time to take a break\!"

cvlc --play-and-exit \
        /usr/share/sounds/kapman/bonus.ogg \
        /usr/share/sounds/kapman/bonus.ogg \
        /usr/share/sounds/kapman/bonus.ogg \
        /usr/share/sounds/kapman/bonus.ogg \
        /usr/share/sounds/kapman/bonus.ogg

