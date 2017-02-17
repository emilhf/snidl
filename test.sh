#!/usr/bin/env sh

# curl -L -v -k -I --resolve www.vg.no:443:127.0.0.1 https://www.vg.no
curl -k -L -v --resolve www.vg.no:443:127.0.0.1 https://www.vg.no
