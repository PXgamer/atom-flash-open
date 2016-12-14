CompositeDisposable = require('atom').CompositeDisposable
exec = require('child_process').exec
path = require('path')
module.exports =
    subscriptions: null
    config: {
        notify: {
          title: 'Show notifications',
          description: 'Enables notifications for when a file has been opened in Flash.',
          type: 'boolean',
          default: 'false'
        },
        os_bit: {
            title: '32-bit or 64-bit',
            description: 'Choose whether you\'re running 32-bit or 64-bit Windows.',
            type: 'string',
            default: '64-bit'
            enum: ['64-bit', '32-bit']
        }
    }
    activate: ->
        @subscriptions = new CompositeDisposable
        @subscriptions.add atom.commands.add('atom-workspace', 'atom-flash-open:toggle': ((_this) ->
            ->
                _this.opener()
        )(this))
    deactivate: ->
        @subscriptions.dispose()
    opener: ->
        notify = atom.config.get('atom-flash-open.notify');
        os_bit = atom.config.get('atom-flash-open.os_bit');
        program_path = 'Program Files (x86)'
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
              	if os_bit == '32-bit'
                		program_path = 'Program Files'
              	if notify
                		atom.notifications.addSuccess 'Opening ' + fileName + ' in Adobe Flash', { 'dismissable': true }
                exec '"C:\\' + program_path + '\\Adobe\\Adobe Flash CS4\\Flash.exe" "' + pathName + '"'
            else
                if notify
                    atom.notifications.addInfo 'Not a Flash file.', { 'dismissable': true }
        else
            if notify
                atom.notifications.addWarning 'Error, no/too many folders selected.', { 'dismissable': true }
