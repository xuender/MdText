###
toolbox.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
TRACKER = null
$ ->
  service = analytics.getService('md_text_app')
  TRACKER = service.getTracker('UA-35761644-8')
  TRACKER.sendAppView('main')

