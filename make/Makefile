# suppress verbose make output
MAKEFLAGS += --silent

# make make the "shell" for make recipes
SHELL = ./make-shell.sh
# empty default shell commandline options to apply for shell invocation
.SHELLFLAGS = make -f -
# => from now on every shell invocation by make will be make

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a recipe line by line in separate SHELL calls
.ONESHELL:

all: foo

# for some reason the sub-Makefile has to be indented with two tabs
foo:
	all:
			echo hello from makemake

.PHONY: all