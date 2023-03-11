---
layout: single
title:  "NSWorkspace NotificationCenter observers in pure Swift"
date:   2023-03-10 17:49:57 -0500
categories: ios swift
---

For a recent MacOS project I had to hook into the system screen wake and sleep notifications. This is
handled with the notification center in NSWorkspace.
{% highlight swift %}
let center = NSWorkspace.shared.notificationCenter;
let mainQueue = OperationQueue.main;

center.addObserver(forName: NSWorkspace.screensDidWakeNotification, object: nil, queue: mainQueue) { notification in
    screensChangedSleepState(notification)
}

center.addObserver(forName: NSWorkspace.screensDidSleepNotification, object: nil, queue: mainQueue) { notification in
    screensChangedSleepState(notification)
}

func screenChangedSleepState(_ notification: Notification) {
  switch(notification.name) {
  case NSWorkspace.screensDidSleepNotification:
      socket?.disconnect()
  case NSWorkspace.screensDidWakeNotification:
      self.openWebsocket()
  default:
      return
  }
}
{% endhighlight %}

There are two implementations of `addObserver`. The [first](https://developer.apple.com/documentation/foundation/notificationcenter/1415360-addobserver) takes a `#selector` argument and depends on an `@objc`  callback. The [second](https://developer.apple.com/documentation/foundation/notificationcenter/1411723-addobserver) takes slightly different arguments, ending with a callback closure that does not depend on `@objc`.