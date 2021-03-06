'use babel'

let CompositeDisposable
let exec
let path

CompositeDisposable = require('atom').CompositeDisposable

exec = require('child_process').exec

path = require('path')

export default {
  subscriptions: null,
  config: {
    notify: {
      title: 'Show notifications',
      description: 'Enables notifications for when a file has been opened in Flash.',
      type: 'boolean',
      'default': 'false'
    },
    os_bit: {
      title: '32-bit or 64-bit',
      description: 'Choose whether you\'re running 32-bit or 64-bit Windows.',
      type: 'string',
      'default': '64-bit',
      'enum': ['64-bit', '32-bit']
    },
    flash_version: {
      title: 'Adobe Flash Version',
      description: 'Choose what version of Flash you\'re using.',
      type: 'string',
      'default': 'CS4',
      'enum': ['CS6', 'CS5', 'CS4', 'CS3', 'CS2']
    }
  },
  activate () {
    this.subscriptions = new CompositeDisposable()
    return this.subscriptions.add(atom.commands.add('atom-workspace', {
      'atom-flash-open:toggle': ((_this => () => _this.opener()))(this)
    }))
  },
  deactivate () {
    return this.subscriptions.dispose()
  },
  opener () {
    let fileName
    let flashVersion
    let listTree
    let notify
    let osBit
    let pathName
    let pieces
    let programPath
    let selected
    notify = atom.config.get('atom-flash-open.notify')
    osBit = atom.config.get('atom-flash-open.osBit')
    flashVersion = atom.config.get('atom-flash-open.flashVersion')
    programPath = 'Program Files (x86)'
    listTree = document.querySelector('.tree-view')
    selected = listTree.querySelectorAll(
      '.selected > .header > span, .selected > span')
    if (selected.length === 1) {
      pieces = selected[0].dataset.path.split(path.sep)
      fileName = pieces[pieces.length - 1]
      pieces.splice(pieces.length, 1)
      pathName = pieces.join(path.sep)
      if (path.extname(pathName).trim() === '.fla') {
        if (osBit === '32-bit') {
          programPath = 'Program Files'
        }
        if (notify) {
          atom.notifications.addSuccess(`Opening ${fileName} in Adobe Flash`, {
            'dismissable': true
          })
        }
        return exec(
          `"C:\\${programPath}\\Adobe\\Adobe Flash ${flashVersion}\\Flash.exe" "${pathName}"`)
      } else {
        if (notify) {
          return atom.notifications.addInfo('Not a Flash file.', {
            'dismissable': true
          })
        }
      }
    } else {
      if (notify) {
        return atom.notifications.addWarning(
          'Error, no/too many folders selected.', {
            'dismissable': true
          })
      }
    }
  }
}
