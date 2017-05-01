import 'mocha'
import 'expect.js'
mocha.setup('bdd')

import helper from '../test/helper.coffee'
import test from '../test/viewer.coffee'
test()

mocha.globals(['test'])
mocha.checkLeaks()
mocha.run()
