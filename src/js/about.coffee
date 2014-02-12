###
about.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
AboutCtrl = ($scope, $log, $modalInstance)->
  $scope.close = ->
    $modalInstance.close('close')
  $scope.i18n = (key)->
    chrome.i18n.getMessage(key)
  TRACKER.sendAppView('about')
AboutCtrl.$inject = ['$scope', '$log', '$modalInstance']

AlertCtrl = ($scope, $log, $modalInstance, title, message)->
  $scope.title = title
  $scope.message = message
  $scope.close = ->
    $modalInstance.close('close')
  $scope.i18n = (key)->
    chrome.i18n.getMessage(key)
  TRACKER.sendAppView('about')
AlertCtrl.$inject = ['$scope', '$log', '$modalInstance', 'title', 'message']
