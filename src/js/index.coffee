###
index.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
$ ->
  $('title').text(chrome.i18n.getMessage('title'))
  $('#input').focus()
  $(window).resize(->
    doResize()
  )
  $('ol').resize(->
    doResize()
  )


doResize = (one = $('ol').is(":visible"))->
  if one
    $('#input').height($(document).height() - 140)
  else
    $('#input').height($(document).height() - 80)

angular.module('mdtext', [
  'ngSanitize'
  'ui.bootstrap'
  'hotkey'
])
MdTextCtrl = ($scope, $modal)->
  $scope.md = ->
    console.info $scope.input
    $scope.output = markdown.toHTML($scope.input)
    console.info $scope.output
  $scope.showAbout = false
  $scope.about = ->
    if $scope.showAbout
      return
    $scope.showAbout = true
    d = $modal.open
      backdrop: true
      keyboard: true
      backdropClick: true
      templateUrl: 'about.html'
      controller: 'AboutCtrl'
    d.result.then(->
      $scope.showAbout = false
    ,->
      $scope.showAbout = false
    )
    TRACKER.sendEvent('command', 'sys', 'about')
  $scope.show = true

MdTextCtrl.$inject = ['$scope', '$modal']
