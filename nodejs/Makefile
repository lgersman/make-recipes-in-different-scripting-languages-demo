# suppress verbose make output
MAKEFLAGS += --silent

# make nodejs the "shell" for make recipes
# (this requires a modern nodejs version to be installed - in my case )
SHELL != sh -c "command -v node"
# tell make which commandline options to apply for shell invocation
.SHELLFLAGS := --experimental-modules --input-type=module -e
# => from now on every shell invocation by make will be nodejs

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a recipet line by line in separate SHELL calls
.ONESHELL:

# et voilà : the recipe can now be written in plain modern javascript :-)
all: foo	
	// use some make variables
	console.log("# target name is '$@', depends on '$^'");

	import {readdir } from 'node:fs/promises';
	console.log(await readdir('..'));

foo:
	// use some make variables
	console.log("# target name is '$@', depends on '$^'");

	console.log("node version is ", process.version);

# tell make that these targets are NOT meant to be files/directories
.PHONY: all foo