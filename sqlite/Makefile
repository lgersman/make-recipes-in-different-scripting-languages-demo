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