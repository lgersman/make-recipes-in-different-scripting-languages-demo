# suppress verbose make output
MAKEFLAGS += --silent

# make sqlite the "shell" for make recipes
SHELL != sh -c "command -v sqlite3"
# empty default shell commandline options to apply for shell invocation
.SHELLFLAGS := -echo -bail -separator ; -header -interactive db.sqlite3
# => from now on every shell invocation by make will be sqlite

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a receipt line by line in separate SHELL calls
.ONESHELL:

# et voilà : the receipt can now be written in plain modern javascript :-)
all: insert import create
	.mode column
	SELECT * FROM foo

# .mode csv
# .separator ;
# .import ./data.csv tmp_foo
# INSERT INTO foo(name, familyname) SELECT * FROM tmp_foo
import: create data.csv 
	DROP TABLE IF EXISTS data;
	.import data.csv data
	INSERT INTO foo(name, familyname) SELECT * FROM data;

insert: create
	INSERT INTO foo 
		(name, familyname) 
	VALUES 
		('Erika', 'Mustermann'),
		('Max', 'Mustermann');

	INSERT INTO foo (name, familyname) VALUES ('John', 'Doe')

create: 
	CREATE TABLE IF NOT EXISTS foo (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING, familyname STRING)

clean:
	DROP TABLE IF EXISTS foo

# tell make that these targets are NOT meant to be files/directories
.PHONY: all create insert import clean