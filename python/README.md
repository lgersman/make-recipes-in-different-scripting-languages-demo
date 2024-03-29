# Makefile using Python as recipe shell

## Prerequisites

- GNU make 

- Python

## Usage

Change to this directory and execute `make` 

## Example code

```make
# suppress verbose make output
MAKEFLAGS += --silent

# make python the "shell" for make recipes
SHELL != sh -c "command -v python"
# tell make which commandline options to apply for shell invocation
.SHELLFLAGS := -c
# => from now on every shell invocation by make will be python

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a recipe line by line in separate SHELL calls
.ONESHELL:

# et voilà : the recipe can now be written in pure python :-)
all: foo	
	# use some make variables
	print "# target name is '$@', depends on '$^'"

	import os
	print os.listdir ("..")

foo:
	# use some make variables
	print "# target name is '$@', depends on '$^'"

	import sys
	print 'python version is %s.%s.%s' % (sys.version_info[0], sys.version_info[1], sys.version_info[2])

# tell make that these targets are NOT meant to be files/directories
.PHONY: all foo
```

If you run the example by executing `make` in a terminal you will get the following output (Python version may differ depending on what version you've installed)

```
# target name is 'foo', depends on ''
python version is 2.7.18
# target name is 'all', depends on 'foo'
['README.md', 'recipeprefix.md', 'python', 'php', 'sqlite', '.git', 'nodejs', 'README.md.template', 'build.sh', 'LICENSE', 'make']
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
