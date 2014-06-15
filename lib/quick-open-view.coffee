{ SelectListView } = require 'atom'
fs = require 'fs-extra'
_ = require 'lodash'
glob = require 'glob'

module.exports =
class QuickOpenViewView extends SelectListView
  initialize: ->
    super
    @addClass('overlay from-top')

  viewForItem: (item) ->
    "<li>#{item.name}</li>"

  confirmed: (item) ->
    @callback? item.path
    delete @callback

  getFiles: ->
    projectPath = atom.config.settings.core.projectHome + "/"
    directory = atom.project.getRootDirectory()
    dirPath = directory.getPath()

    # TODO: ignore node_modules, bower_components, etc
    glob "#{dirPath}/**/*.{json,cson}", (err, entries) =>
      @setItems entries.map (name) =>
          name: name.replace dirPath, ''
          path: name

  toggle: (callback) ->
    @callback = callback

    if @hasParent()
      @cancel()
    else
      @getFiles()
      atom.workspaceView.append this
      @focusFilterEditor()

  getFilterKey: ->
    'name'
