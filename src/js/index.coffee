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

doResize = ->
    $('#input').height($(document).height() - 135)
    $('#preview').height($(document).height() - 135)

angular.module('mdtext', [
  'ngSanitize'
  'ui.bootstrap'
  'hotkey'
])
MdTextCtrl = ($scope, $modal)->
  $scope.i18n = (key)->
    chrome.i18n.getMessage(key)
  $scope.input = ''
  $scope.isPreview = false
  $scope.$watch('isPreview',(n, o)->
    $scope.output = markdown.toHTML($scope.input)
  )
  $scope.preview = ->
    $scope.isPreview = !$scope.isPreview
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
  doResize()

MdTextCtrl.$inject = ['$scope', '$modal']
