# suppress verbose make output
MAKEFLAGS += --silent

# make python the "shell" for make recipes
SHELL != sh -c "command -v python"
# tell make which commandline options to apply for shell invocation
.SHELLFLAGS := -c
# => from now on every shell invocation by make will be python

# .ONESHELL tells make to execute a target recipe as a single SHELL call
# (by default make would execute a receipt line by line in separate SHELL calls
.ONESHELL:

# et voilà : the receipt can now be written in plain modern javascript :-)
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