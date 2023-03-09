# suppress verbose make output
MAKEFLAGS += --silent

# make php the "shell" for make recipes
SHELL != sh -c "command -v php"
# tell php within make to take the following as php code
.SHELLFLAGS := -r
# => from now on every shell invocation by make will be php

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a recipe line by line in separate SHELL calls
.ONESHELL:

# et voilà : the recipe can now be written in pure php :-)
all: foo	
	# use some make variables
	echo PHP_EOL . "# target name is '$@', depends on '$^'";

	print_r(glob('../*'));

foo:
	# to use variables, escape the $ with a second $ like this
	$$greetings= 'world';
	printf("Hello, %s!\n", $$greetings);

	echo 'PHP version is '. phpversion() . PHP_EOL;

# tell make that these targets are NOT meant to be files/directories
.PHONY: all foo
