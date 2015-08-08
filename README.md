# world-o-techno
Location-based techno with Sonic Pi and gpsd

Getting started:

Check this out into /home/pi

Install gpsd (thanks to http://blog.retep.org/2012/06/18/getting-gps-to-work-on-a-raspberry-pi/) with
pi@raspberrypi:~$ sudo apt-get install gpsd gpsd-clients python-gps
and start it with
pi@raspberrypi:~$ sudo gpsd /dev/ttyUSB0 -F /var/run/gpsd.sock

Check it works with
pi@raspberrypi:~$ cgps -s

Install sonic-pi-cli to give Sonic Pi a command line (via https://github.com/Widdershin/sonic-pi-cli)

pi@raspberrypi:~$ gem install sonic-pi-cli

Make your pi start Sonic Pi and play our tune on boot (thanks to
https://rbnrpi.wordpress.com/autoboot-for-telegram-and-sonic-pi-jukebox/)

pi@raspberrypi:~$ sudo vi /etc/xdg/lxsession/LXDE-pi/autostart

and add these lines at the end:

@sonic-pi
lxterminal --command "/home/pi/world-o-techno/startup.sh"

