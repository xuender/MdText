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
  window.onfocus = ->
    console.log("focus")
    focusTitlebars(true)

  window.onblur = ->
    console.log("blur")
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
    dlg = $dialogs.confirm('系统信息','是否退出?')
    dlg.result.then((btn)->
      window.close()
    ,(btn)->
      console.info 'no'
    )
  $scope.i18n = (key)->
    chrome.i18n.getMessage(key)
  $scope.doSave = ->
    $scope.fileEntry.createWriter((writer)->
      writer.onerror  = ->
        $scope.fileEntry = null
        $dialogs.error('保存错误', '文件无法保存.')
      writer.onwriteend = ->
        console.info 'save'
      writer.write(new Blob([$scope.input]))
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
  $scope.open = ->
    chrome.fileSystem.chooseEntry({
      type: 'openWritableFile'
      accepts: CHOOSE_ACCEPTS
    }, (fileEntry)->
      $scope.fileEntry = fileEntry
      fileEntry.file((file)->
        reader = new FileReader()
        reader.onerror = ->
          $scope.fileEntry = null
          $dialogs.error('读取错误', '文件无法打开.')
        reader.onloadend = (e)->
          $scope.input = e.target.result
          $scope.$apply()
        reader.readAsText(file)
      )
    )
  $scope.input = ''
  $scope.new = ->
    $scope.input = ''
    $scope.isLivePreview = false
    $scope.isEdit = true
    $scope.isPreview = false
  $scope.$watch('input', (n, o)->
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
    $scope.isEdit = true
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
  $scope.new()
  doResize()

MdTextCtrl.$inject = ['$scope', '$modal', '$dialogs']
