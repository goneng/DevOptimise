#!/usr/bin/env bash

if ! pip3 show virtualenv > /dev/null
then
  pip3 install virtualenv
fi