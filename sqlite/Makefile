# suppress verbose make output
MAKEFLAGS += --silent

# make sqlite the "shell" for make recipes
SHELL != sh -c "command -v sqlite3"
# empty default shell commandline options to apply for shell invocation
.SHELLFLAGS := -bail -separator ; -batch -header db.sqlite3 
# => from now on every shell invocation by make will be sqlite

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a receipt line by line in separate SHELL calls
.ONESHELL:

# et voilà : receipts can now be written in pure sqlite syntax :-)
all: create insert import report
	.print "# target name is '$@', depends on '$^'\n"

report: 
	SELECT * FROM foo

merge_data: import_data
	INSERT INTO foo(name, familyname) 
		SELECT * FROM data;
	DROP TABLE IF EXISTS data

import_data: create data.csv 
	.import data.csv data
	
import: import_data merge_data;

insert: create
	INSERT INTO foo 
		(name, familyname) 
	VALUES 
		('Erika', 'Mustermann'),
		('Max', 'Mustermann');

	INSERT INTO foo (name, familyname) VALUES ('John', 'Doe')

create: 
	CREATE TABLE 
		IF NOT EXISTS 
	foo 
		(id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, familyname STRING)

clean:
	DROP TABLE IF EXISTS foo
	DROP TABLE IF EXISTS data

# tell make that these targets are NOT meant to be files/directories
.PHONY: all create insert import clean import import_data merge_data