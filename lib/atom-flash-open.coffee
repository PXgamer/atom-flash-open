CompositeDisposable = require('atom').CompositeDisposable
exec = require('child_process').exec
path = require('path')
module.exports =
    subscriptions: null
    activate: ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add('atom-workspace', 'atom-flash-open:toggle': ((_this) ->
            ->
                _this.opener()
        )(this))
    deactivate: ->
        @subscriptions.dispose()
    opener: ->
        editor = atom.workspace.getActivePaneItem()
        listTree = document.querySelector('.tree-view')
        selected = listTree.querySelectorAll('.selected > .header > span, .selected > span')
        if selected.length == 1
            pieces = selected[0].dataset.path.split(path.sep)
            fileName = pieces[pieces.length - 1]
            name = pieces[pieces.length - 1].replace('.', '-')
            pieces.splice pieces.length, 1
            pathName = pieces.join(path.sep)
            extname = path.extname(pathName).trim()
            if extname == '.fla'
                atom.notifications.addSuccess 'Opening ' + fileName + ' in Adobe Flash', { 'dismissable': true }
                exec '"C:\\Program Files (x86)\\Adobe\\Adobe Flash CS4\\Flash.exe" "' + pathName + '"'
            else
                console.log 'Not a Flash file.'
        else
            console.log 'Error, no/too many folders selected.'
