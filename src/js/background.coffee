###
background.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
chrome.app.runtime.onLaunched.addListener(->
  chrome.app.window.create('index.html',
    frame: "none"
    bounds:
      'width': 800
      'height': 550
    minWidth: 770
    minHeight: 500
  )
)
