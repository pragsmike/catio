radio = require('radio')

local sr = 44100

-- blocks
local source1 = radio.SignalSource('cosine', 127e3, sr)
local source2 = radio.SignalSource('cosine', 75e3, sr)
local audio_in = radio.PulseAudioSource(1, sr)
local mixer = radio.MultiplyBlock()
local throttle = radio.ThrottleBlock()
local sink = radio.GnuplotSpectrumSink()
local top = radio.CompositeBlock()

-- Connections
top:connect(source1,  'out', mixer, 'in1')
top:connect(audio_in, 'out', mixer, 'in2')

top:connect(mixer, throttle, sink)

top:run()
