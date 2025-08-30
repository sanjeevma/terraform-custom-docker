# docker-entrypoint.sh
#!/bin/sh
if [ "$1" = "debug" ]; then
  exec /bin/sh
else
  exec /bin/terraform "$@"
fi
