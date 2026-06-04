# my_fish_shell

## `design_1`
Visual Preview of the Enhancements
When everything runs perfectly ($status = 0):
The frame renders in a smooth green palette with a sleek entry arrow, omitting the error block entirely to keep things minimal.
```text
Plaintext
    ╭─[nim@Hattori:~]─[🕒 11:39:00]─[🌿 main]
    ╰─→ $ _
When a command fails ($status = 127):
The frame structure immediately shifts to a warning red, and a designated error badge pops out instantly pinpointing what went wrong.

Plaintext
    ╭─[nim@Hattori:~]─[🕒 11:39:04]─[❌ ERR:127]
    ╰─→ $ _
When background jobs are running:
Instead of dropping raw text onto the screen, active background tasks are cleanly attached to the frame tree using active gear indicators.

Plaintext
    ╭─[nim@Hattori:~]─[🕒 11:42:15]
    ├─ ⚙️ 1 15054 0% arrêtée sleep 100000
    ╰─→ $ _
```

