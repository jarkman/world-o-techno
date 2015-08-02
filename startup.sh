#!/bin/bash -x

sleep 20
amixer cset numid=3 1
amixer sset PCM 100%
cat acid2.rb|sonic_pi
