#!/bin/bash
( sleep 0; /usr/bin/make-call-context "$1" super-alarm start "ARRAY(TARGET,CODE)" "$1\\,$2" ) &
