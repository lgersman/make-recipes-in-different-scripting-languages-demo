# Makefile using PHP as recipe shell

_This example was contributed by [Thomas Rose/codeispoetry](https://github.com/codeispoetry)._

## Prerequisites

- GNU make 

- PHP

## Usage

Change to this directory and execute `make` 

## Example code

```make
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
```

If you run the example by executing `make` in a terminal you will get the following output (PHP version may differ depending on what version you've installed)

```
Hello, world!
PHP version is 8.2.4

# target name is 'all', depends on 'foo'Array
(
    [0] => ../LICENSE
    [1] => ../README.md
    [2] => ../README.md.template
    [3] => ../build.sh
    [4] => ../make
    [5] => ../nodejs
    [6] => ../php
    [7] => ../python
    [8] => ../recipeprefix.md
    [9] => ../sqlite
)
```

# Opinionated tip: use `.RECIPEPREFIX`

make is a impressive but stone age old tool with a long history.

At the time of development (=> some decades ago 😅) their authors thought it's a good idea to use `'\t'` as recipe prefix.

The result is one of the most asked questions from `make` novices : 

> When executing my Makefile I get the following error
> 
> ```
> Makefile:xx: *** missing separator.  Stop.
> ```
>
> What does that error mean ? 

## What is the recipe prefix ?

A Makefile consists mostly of targets and their recipes. 

A target is usually a file/directory to be generated by the target recipe. 

An example: 

```make
foo.exe: foo.c
  cc -o foo.exe foo.c
```

The recipe prefix is the prefix starting each recipe line. 

__By default it is `'\t'`.__

And that's often a problem - because depending of the used editor / settings tabs may be converted to spaces. 

If you use spaces instead of tabs you get this mysterious error message : 

```
Makefile:xx: *** missing separator.  Stop.
```

## Solution

A solution to workaround that potential issue is to change the recipe prefix to something different : 

```make
# tell make to use '>' as recipe prefix
.RECIPEPREFIX = >

foo.exe: foo.c
> cc -o foo.exe foo.c
```

Now we have a visible character as recipe prefix which is much less error prone.

_The `.RECIPEPREFIX` directive is available since `make` version 4.0._
