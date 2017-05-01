import '../node_modules/mocha/mocha.js'
import '../node_modules/mocha/mocha.css'
mocha.setup('bdd')

import test from '../test/viewer.coffee'
test()

mocha.globals(['test'])
mocha.checkLeaks()
mocha.run()
