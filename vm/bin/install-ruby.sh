#!/usr/bin/env bash

source ~/.rvm/scripts/rvm

rvm use --install $1

shift

if (( $# ))
then rvm gemset create $@
fi

