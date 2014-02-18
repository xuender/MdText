###
index.coffee
Copyright (C) 2014 ender xu <xuender@gmail.com>

Distributed under terms of the MIT license.
###
$ ->
  $('title').text(chrome.i18n.getMessage('title'))
  $('#input')[0].focus()
  $(window).resize(->
    doResize()
  )
  window.onfocus = ->
    focusTitlebars(true)
    $('#input')[0].focus()

  window.onblur = ->
    focusTitlebars(false)

focusTitlebars = (focus)->
  bg_color = if focus then "#3a3d3d" else "#7a7c7c"
  titlebar = document.getElementById("title")
  titlebar.style.backgroundColor = bg_color

doResize = ->
    $('#input').height($(document).height() - 140)
    $('#preview').height($(document).height() - 140)

angular.module('mdtext', [
  'ngSanitize'
  'ui.bootstrap'
  'dialogs'
  'hotkey'
])
CHOOSE_ACCEPTS = [
  {
    description: 'Markdown(*.md)'
    mimeTypes: ['text/plain']
    extensions: ['md']
  }
]

MdTextCtrl = ($scope, $modal, $dialogs)->
  $scope.close = ->
    if $scope.isUpdate
      dlg = $dialogs.confirm($scope.i18n('prompted'), $scope.i18n('dyq'))
      dlg.result.then((btn)->
        TRACKER.sendEvent('command', 'sys', 'close')
        window.close()
      ,(btn)->
        console.info 'no'
        $('#input')[0].focus()
      )
    else
      TRACKER.sendEvent('command', 'sys', 'close')
      window.close()

  $scope.i18n = (key)->
    if chrome.i18n.getMessage(key) then chrome.i18n.getMessage(key) else key
  $scope.doSave = ->
    $scope.fileEntry.createWriter((writer)->
      writer.onerror  = ->
        $scope.fileEntry = null
        $dialogs.error($scope.i18n('prompted'), $scope.i18n('save_error'))
      writer.onwriteend = ->
        $('#input')[0].focus()
      writer.write(new Blob([$scope.input]))
      $scope.isUpdate = false
    )
  $scope.save = ->
    if $scope.fileEntry
        $scope.doSave()
    else
      chrome.fileSystem.chooseEntry({
        type: 'saveFile'
        accepts: CHOOSE_ACCEPTS
      }, (fileEntry)->
        $scope.fileEntry = fileEntry
        $scope.doSave()
      )
    TRACKER.sendEvent('command', 'sys', 'save')
  $scope.open = ->
    if $scope.isUpdate
      dlg = $dialogs.confirm($scope.i18n('prompted'), '是否放弃尚未保存的修改?')
      dlg.result.then((btn)->
        $scope.openFile()
      ,(btn)->
        1
      )
    else
      $scope.openFile()
  $scope.openFile = ->
    chrome.fileSystem.chooseEntry({
      type: 'openWritableFile'
      accepts: CHOOSE_ACCEPTS
    }, (fileEntry)->
      $scope.fileEntry = fileEntry
      fileEntry.file((file)->
        reader = new FileReader()
        reader.onerror = ->
          $scope.fileEntry = null
          $dialogs.error($scope.i18n('prompted'), $scope.i18n('open_error'))
        reader.onloadend = (e)->
          $scope.input = e.target.result
          $scope.$apply()
        reader.readAsText(file)
      )
    )
    TRACKER.sendEvent('command', 'sys', 'open')
    $('#input')[0].focus()
  $scope.input = ''
  $scope.new = ->
    chrome.app.window.create('index.html',
      frame: "none"
      bounds:
        'width': 800
        'height': 550
      minWidth: 770
      minHeight: 500
    )
  $scope.newFile = ->
    $scope.input = ''
    $scope.isLivePreview = false
    $scope.isEdit = true
    $scope.isUpdate = false
    $scope.isPreview = false
    $('#input')[0].focus()
  $scope.$watch('input', (n, o)->
    $scope.output = markdown.toHTML($scope.input)
    if n != o
      $scope.isUpdate = true
  )
  $scope.$watch('isPreview', (n, o)->
    if !n
      $scope.isLivePreview = n
    if $scope.isLivePreview
      $scope.isEdit = true
    else
      $scope.isEdit = !n
    $('#input')[0].focus()
  )
  $scope.preview = ->
    $scope.isPreview = !$scope.isPreview
    $('#input')[0].focus()
    TRACKER.sendEvent('command', 'sys', 'preview')
  $scope.livePreview = ->
    $scope.isLivePreview = !$scope.isLivePreview
    $scope.isEdit = true
    $scope.isPreview = $scope.isLivePreview
    TRACKER.sendEvent('command', 'sys', 'livePreview')
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
    $('#input')[0].focus()
    TRACKER.sendEvent('command', 'sys', 'about')
  $scope.show = true
  $scope.newFile()
  doResize()
  $('#input')[0].focus()

MdTextCtrl.$inject = ['$scope', '$modal', '$dialogs']
