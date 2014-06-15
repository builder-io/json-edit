_ = require 'lodash'
fs = require 'fs-extra'
CSON = require 'season'
{ View, $ } = require 'atom'

jsonEdit = angular.module 'jsonEdit', []


class EditView extends View

  @content: -> @div class: 'json-edit-view-container'

  initialize: (options) ->
    @append @template
    @listenForEvents()
    filePath = @filePath = options.path
    @fileName = _.last @filePath.split '/'

    jsonEdit
      .run(($templateCache) ->
        tpl = fs.readFileSync __dirname + '/../templates/recurse.tpl.html', 'utf8'
        $templateCache.put 'recurse.tpl.html', tpl
      )
      .controller 'EditViewCtrl', ($scope, $sce) =>

        _.extend $scope,
          view:
            searchJson: ''

          json: CSON.readFileSync filePath

          remove: =>
            @remove()

          typeof: (item) ->
            if _.isArray(item) then 'array' else typeof item

          setupRecursiveScope: (scope, type) ->
            scope.parent = scope.subject
            scope.subject = scope.value
            scope.path = if type is 'array' then scope.$index else scope.key


        $scope.$watch 'json', (newVal) =>
          CSON.writeFile filePath, newVal
        , true

      angular.bootstrap @, ['jsonEdit']

  getTitle: ->
    @fileName

  listenForEvents: ->
    atom.workspaceView.command 'json-edit:foobar', =>
      builderScope.$apply =>
        # Do someting

  template: fs.readFileSync __dirname + '/../templates/edit-view.tpl.html', 'utf8'


module.exports = EditView
