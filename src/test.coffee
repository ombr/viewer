import 'mocha'
mocha.setup('bdd')

import test from '../test/viewer.coffee'
test()

mocha.globals(['test'])
mocha.checkLeaks()
mocha.run()
