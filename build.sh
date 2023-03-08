#!/usr/bin/env bash

# remove everything matching .gitignore entries
# => If an untracked directory is managed by a different git repository, it is not removed by default. Use -f option twice if you really want to remove such a directory.
git clean -Xfd 

# executa all [file].template files and save their output to [file]
find . -executable -name "*.template" -execdir \
  $SHELL -c '$0 > $(basename $0 .template)' {} \
\; 