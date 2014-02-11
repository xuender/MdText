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
  $scope.isLivePreview = false
  $scope.isEdit = true
  $scope.isPreview = false
  $scope.$watch('input',(n, o)->
    $scope.output = markdown.toHTML($scope.input)
  )
  $scope.$watch('isPreview', (n, o)->
    if !n
      $scope.isLivePreview = n
    if $scope.isLivePreview
      $scope.isEdit = true
    else
      $scope.isEdit = !n
  )
  $scope.preview = ->
    $scope.isPreview = !$scope.isPreview
  $scope.livePreview = ->
    $scope.isLivePreview = !$scope.isLivePreview
    $scope.isPreview = $scope.isLivePreview
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
