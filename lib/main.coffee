_ = require 'lodash'
_.str = require 'underscore.string'

# Load angular (globally unfortunately)
require '../node_modules/angular/lib/angular.min.js' unless angular?

_.mixin _.str.exports()

EditView = require './edit-view'
QuickOpenView = require './quick-open-view'


module.exports =
  configDefaults:
    foobar: false

  activate: ->
    atom.project.registerOpener @customOpener

    atom.workspaceView.command 'json-edit:open', =>
      # TODO: if active pane is JSON open it directly
      @quickOpenView.toggle (filePath) =>
        atom.workspaceView.open "json-edit://#{filePath}"

    atom.workspaceView.command 'json-edit:open-test', =>
      atom.workspaceView.open "json-edit://#{atom.project.getRootDirectory().getPath()}/package.json"

    @quickOpenView = new QuickOpenView

  deactivate: ->
    @builderView.destroy()
    @quickOpenViewView.destroy()

  customOpener: (uri) ->
    if match = uri?.match /^json-edit:\/\/(.*)/
      initialDirectory = match[1]
      new EditView path: initialDirectory
