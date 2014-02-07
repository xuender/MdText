###
background.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
chrome.app.runtime.onLaunched.addListener(->
  chrome.app.window.create('index.html',
    bounds:
      'width': 800
      'height': 600
    id: 'toolbox'
    minWidth: 770
    minHeight: 500
    singleton: true
  )
)
