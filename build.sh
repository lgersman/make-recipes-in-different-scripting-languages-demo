#!/usr/bin/env bash

# executa all [file].template files and save their output to [file]

find . -executable -name "*.template" -execdir \
  $SHELL -c '$0 > $(basename $0 .template)' {} \
\; 