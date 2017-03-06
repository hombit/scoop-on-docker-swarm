#!/usr/bin/env python

import random, bottle
from scoop import futures

data = [random.randint(-1000, 1000) for r in range(1000)]


if __name__ == '__main__':
    import bottle

    @bottle.route('/')
    def index():
         # Python's standard serial function
        dataSerial = list(map(abs, data))

        # SCOOP's parallel function
        dataParallel = list(futures.map(abs, data))

        if dataSerial == dataParallel:
            return('dataSerial and dataParallel are equal')

        return('dataSerial and dataParallel are different')

    bottle.run(host='0.0.0.0', port=8000, debug=True)
