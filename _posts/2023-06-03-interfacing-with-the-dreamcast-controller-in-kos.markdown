---
layout: single
title: Interfacing with the Dreamcast Controller in KallistiOS
date: Sun Jun  3 2023
categories: homebrew dreamcast
---

I've been doing some Dreamcast homebrew this weekend, using the great
[KallistiOS](https://github.com/KallistiOS/KallistiOS/) as well as 
[dcload-ip](https://github.com/sizious/dcload-ip). Together they make
for a great development environment, and the [Dreamcast](https://en.wikipedia.org/wiki/Dreamcast)
itself is the easiest console I've ever worked with to homebrew.

This is an example I put together to show how to poll the controller for
button presses, and use it to update the VMU. It's really just what I've learned
so far about KOS.

# Technical Stuff

This example is a modified lcd.c from the KallistiOS `examples/` folder.
It uses the maple API to poll for that status, using `maple_dev_status()`,
which returns a struct. This is just added as part of the main loop logic.
The `status` struct's button member is checked against the defined bit values
for the buttons we're interested in.

The rest of the VMU code from lcd.c is used to animate a breakout-style
paddle that moves to the left and right. Start quits the program.

{% highlight c linenos %}

#include <dc/vmu_fb.h>
#include <kos.h>

#include <stdint.h>

static const char paddle[] = {
  0b11111111,
};

static vmufb_t vmufb;

KOS_INIT_FLAGS(INIT_DEFAULT | INIT_MALLOCSTATS);

/* Your program's main entry point */
int main(int argc, char **argv) {
    unsigned int x, y;
    maple_device_t *vmu;

    cont_btn_callback(0, CONT_START,
                      (cont_btn_callback_t)arch_exit);

    // Controller status
    maple_device_t *device = maple_enum_dev(0, 0);

    x = 20;
    y = 30;

    // Main Loop
    while(1==1) {
      cont_state_t *status = maple_dev_status(device);
      if(status->buttons & CONT_DPAD_LEFT) {
        if(x > 0) {
          x -= 1;
        }
      } else if(status->buttons & CONT_DPAD_RIGHT) {
        if(x < 40) {
          x += 1;
        }
      }

      vmufb_clear(&vmufb);

      vmufb_paint_area(&vmufb, x, y, 8, 1, paddle);

      vmu = maple_enum_type(0, MAPLE_FUNC_LCD);
      vmufb_present(&vmufb, vmu);

    }

    return 0;
}

{% endhighlight %}
