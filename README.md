# Audio Effects Box (App)

### The Interface for our Audio Effects Box MDE Project
- uses websockets to send new values on change to our ws server running on a raspberry pi
- knob controls sine modulation, slider controls pitch shift, text fields input filter data
- "green" indicates the effect is active
- all audio effects handled on the pi, all custom and real time using sounddevice
