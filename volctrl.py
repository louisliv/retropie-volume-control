import alsaaudio

def set_volume(mixer, increment, direction):
    m = alsaaudio.Mixer(mixer)

    if direction in ['up']:
        next_vol = m.getvolume()[0] + increment

        if next_vol > 100:
            next_vol = 100
        
        m.setvolume(next_vol)
    elif direction in ['down']:
        next_vol = m.getvolume()[0] - increment

        if next_vol < 0:
            next_vol = 0
        
        m.setvolume(next_vol)