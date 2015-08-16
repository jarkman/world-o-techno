require '/home/pi/world-o-techno/gps/gps.rb'
use_debug true

gps = Gps::Receiver.create('gpsd',:host => 'localhost', :port => 2947)

gps.start

define :gpsSatelliteCount do
  s = 0;
  if gps != nil && gps.satellites != nil &&  gps.satellites != 0
    s = gps.satellites.count
  end
  print "Satellites: #{s}"
  return s;
end

define :gotFix do
  g = false;

  print gps

  if gps != nil 
    g = gps.latitude != nil
  end

  return g
end

define :lat do
  l = 0.0
  if gps != nil && gps.latitude != nil
    l = gps.latitude
  end
  return l
end


define :lon do
  l = 0.0
  if gps != nil && gps.longitude != nil
    l = gps.longitude
  end
  return l
end


define :speed do
  l = 0.0
  if gps != nil && gps.speed != nil
    l = gps.speed
  end
  return l
end

sleep 2
load_sample :bd_fat
load_sample :bd_boom
load_sample :bd_haus

define :playSatelliteCount do
  
    i = 0
    print "loop"
    4.times do
      c = gpsSatelliteCount()
      if i == 0
        sample :bd_boom, amp:10
      else
        if i <= c
          sample :bd_fat, amp: 6
        else
          sample :bd_haus, amp: 1
        end
      end

      sleep 0.5
      i = i+1
    end

end

define :playTune do
  cue :foo
  4.times do |i|
    long = (lon().abs * 10**9) % 100
    use_random_seed long
    4.times do
      sample :bd_fat, amp: 5
      4.times do
        use_synth :tb303
        play chord(:e5, :minor).choose, attack: 0, release: 0.1, cutoff: rrand_i(50, 90) + i * 10
        sleep 0.125
      end
    end
  end

  if ! gotFix()
    return
  end

  cue :bar
  use_synth :tb303
  8.times do |i|
    sample :bd_fat, amp: 5
    4.times do
      gspeed = speed().modulo(1)
      puts gspeed
      play chord(:b4, :minor).choose, attack: 0, release: 0.05, cutoff: rrand_i(70, 98) + i, res: gspeed
      sleep 0.125
    end
  end

  if ! gotFix()
    return
  end

  cue :baz
  with_fx :reverb, mix: 0.3 do |r|
    8.times do |m|
      sample :bd_fat, amp: 5
      4.times do
        control r, mix: 0.3 + (0.5 * (m.to_f / 32.0)) unless m == 0 if m % 8 == 0
        use_synth :prophet
        play chord(:e6, :minor).choose, attack: 0, release: 0.08, cutoff: rrand_i(110, 130)
        sleep 0.125
      end
    end
  end

  if ! gotFix()
    return
  end

  cue :quux
  in_thread do
    use_random_seed 668
    slat = (lat().abs * 10**7).modulo(1) + 0.1
    with_fx :slicer, mix: 0.75, wave: 3, phase: slat do
      4.times do
        sample :bd_fat, amp: 5
        4.times do
          use_synth :tb303
          play chord(:d3, :major).choose, attack: 0, release: 0.1, cutoff: rrand(50, 100)
          sleep 0.25
        end
      end
    end
  end

  if ! gotFix()
    return
  end
 
    sleep 4
  end
 


loop do
  if gotFix() 
    playTune()
  else
    playSatelliteCount()
  end
end