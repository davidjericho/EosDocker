CERN EOS Citrine demonstration container
========================================

# Requirements

- Hostname must have two or more parts to the name. For example "foo.blah", or "this.domain.works". Default docker hostnames will not work.

# Building

```docker build --tag eosdocker .```

# Running

This proposed command for running will delete the container on exit.

```docker run -ti --rm -h eos.mydomain eosdocker```

# Origin

Forked from work by Elvin Sindrilaru, esindril@cern.ch, CERN 2017, https://github.com/esindril/EosDocker

See https://eos.web.cern.ch/ for more information and documentation on EOS.
