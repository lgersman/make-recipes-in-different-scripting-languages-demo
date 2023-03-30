# Makefile recipes in various languages

Using make does not mean that you have to learn shell scripting 
(although it's always a good idea to have at least basic knowledge about it).

__The important point is : You can use almost any scripting language for make recipes, not just shell scripts !__ 

- Thats how a Makefile looks using NodeJS as make `SHELL` : 

```make
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
```

- Do you prefer Python ? Yes, it's possible ! 

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

- What about PHP ? Yes, you can : 

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

- How about something special ... let's say we want use SQL (SQLite in this case) as make SHELL:

```make
# suppress verbose make output
MAKEFLAGS += --silent

# sqlite database file name
DB := db.sqlite3

# make sqlite the "shell" for make recipes
SHELL = ./sqlite-shell.sh
# empty default shell commandline options to apply for shell invocation
.SHELLFLAGS = sqlite3 $(DB) 
# => from now on every shell invocation by make will be sqlite

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a recipe line by line in separate SHELL calls
.ONESHELL:

# et voilà : recipes can now be written in pure sqlite syntax :-)
all: create insert import
	.print "# target name is '$@', depends on '$^'\n"
	.headers ON
	.mode columns
	SELECT * FROM foo;

import: create data.csv
	.print "# target name is '$@', depends on '$^'\n"
	.separator ;
	.import data.csv data
	INSERT INTO foo(name, familyname) 
		SELECT * FROM data;
	DROP TABLE IF EXISTS data;

insert: create
	INSERT INTO foo 
		(name, familyname) 
	VALUES 
		('Erika', 'Mustermann'),
		('Max', 'Mustermann');

	INSERT INTO foo (name, familyname) VALUES ('John', 'Doe');

create: clean
	CREATE TABLE 
		IF NOT EXISTS 
	foo 
		(id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, familyname STRING);

clean:
	DROP TABLE IF EXISTS foo;
	DROP TABLE IF EXISTS data;

# tell make that these targets are NOT meant to be files/directories
.PHONY: all create insert import clean import
```
---

Make is a tool following the classic Unix philosophy : 

> Make each program do one thing well.

Make does 

- resolve tasks (aka targets) and their dependencies

- execute target recipe if a target is not build/out-of-date

The recipe target can be written in whatever scripting language you want. 

It is configurable using make variables `SHELL` and `.SHELLFLAGS`

## configuration 

- make takes the `SHELL` defined in your makefile for executing target recipes. 

  make will replace all [make variables](https://ftp.gnu.org/old-gnu/Manuals/make-3.79.1/html_chapter/make_6.html) used in a target recipe before delegating them to the declared `SHELL`

- the `.SHELLFLAGS` directive can be used to customize the commandline parameters used for SHELL execution.

## Examples

This repo provides some examples using make with pure 

- NodeJS
- Python
- SQLite3
- PHP
- and even make in make 🤯

__If you have some more ideas to showcase - create a pull request !__

### Usage

The execute an example

- `cd` into the desired example directory

- execute `make`

# Some more helpful `make` settings

- `.ONESHELL` tells make to execute target recipe lines in a single SHELL invocation. 
  That is what most people want !

  _By default, every recipe line would be executed in a separate SHELL call._

- `MAKEFLAGS` can be used to customize make behaviour. 
  I personally prefer to set `MAKEFLAGS+=--no-builtin-rules --no-builtin-variables` disable stone age old buil-tin rules/variables of make dedicated to c/c++ development of the eighties.
  
  - `--no-builtin-variables` tells make to not create out of the box variables like $(CC), $(YACC) and stuff

  - `--no-builtin-rules` tells make to not create c/c++ standard rules for targeting yacc/c/cc++ files 

- `.SECONDEXPANSION` is pure magic. It makes make target dependencies dynamic. Read more here : https://www.cmcrossroads.com/article/making-directories-gnu-make

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
