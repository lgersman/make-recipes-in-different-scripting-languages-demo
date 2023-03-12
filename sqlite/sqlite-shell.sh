#!/bin/env bash
# A bash utility script which pipes its last argument to a
# process gained by executing all but its last argument.  Useful in
# Makefiles where you want the recipes to appear on stdin of some
# command other than the usual bash shell.  For example, to write
# recipes in sqlite3 (allowing dot-commands), include the following in your 
# Makefile:
#   SHELL:=sqlite-shell.sh
#   .SHELLFLAGS:=sqlite3 $(DB)
#   .ONESHELL:
# 
# see https://mail.gnu.org/archive/html/help-make/2015-05/msg00017.html
# 
cat <<< "${@:$#}" | "${@:1:$(($# - 1))}"