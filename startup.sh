#!/bin/bash -x

# wait for sonic-pi to start
sleep 20

# set the default audio output to be the headphone jack
amixer cset numid=3 1

# set audio volume to full
amixer sset PCM 100%

# play our tune
cat /home/pi/world-o-techno/world-o-techno.rb|sonic_pi
