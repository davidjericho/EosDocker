CERN EOS Citrine demonstration container
========================================

# Requirements

* Hostname of the container must be set to _eostest.cern.ch_

# Building

```docker build --tag eosdocker .```

# Running

This proposed command for running will delete the container on exit.

```docker run -ti --rm -h eostest.cern.ch eosdocker```

# Origin

Forked from work by Elvin Sindrilaru, esindril@cern.ch, CERN 2017, https://github.com/esindril/EosDocker

See https://eos.web.cern.ch/ for more information and documentation on EOS
