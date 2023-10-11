#!/bin/bash
set -e

create_pid_dir() {
  mkdir -p /run/apt-cacher-ng
  chmod -R 0755 /run/apt-cacher-ng
  chown apt-cacher-ng:apt-cacher-ng /run/apt-cacher-ng
}

create_cache_dir() {
  mkdir -p /acng/cache
  chmod -R 0755 /acng/cache
  chown -R apt-cacher-ng:apt-cacher-ng /acng/cache
}

create_log_dir() {
  mkdir -p /acng/log
  chmod -R 0755 /acng/log
  chown -R apt-cacher-ng:apt-cacher-ng /acng/log
}

create_pid_dir
create_cache_dir
create_log_dir

# allow arguments to be passed to apt-cacher-ng
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == apt-cacher-ng || ${1} == $(command -v apt-cacher-ng) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch apt-cacher-ng
if [[ -z ${1} ]]; then
  exec start-stop-daemon --start --chuid apt-cacher-ng:apt-cacher-ng \
    --exec "$(command -v apt-cacher-ng)" -- -c /etc/apt-cacher-ng ${EXTRA_ARGS}
else
  exec "$@"
fi
