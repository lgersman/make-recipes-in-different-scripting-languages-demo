# suppress verbose make output
MAKEFLAGS += --silent

# make nodejs the "shell" for make recipes
# (this requires a moddest nodejs version to be installed - in my case )
SHELL != sh -c "command -v node"
# tell make which commandline options to apply for shell invocation
.SHELLFLAGS := --experimental-modules --input-type=module -e
# => now every shell invocation make by make will be nodejs 

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a receipt line by line in single SHELL calls
.ONESHELL:

# et voilà : the receipt can now be written in plain modern javascript :-)
all: foo
	// access make target name
	console.log("target name is '$@', depends on '$^'");

	import {readdir } from 'node:fs/promises';
	console.log(await readdir('..'));

foo:
	// access make target name
	console.log("target name is '$@', depends on '$^'");

	console.log("node version is ", process.version);

# tell make that these targets are NOT meant to be files/directories
.PHONY: all foo