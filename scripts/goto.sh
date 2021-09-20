#!/bin/bash
##################################
# Usage: goto keyword
#################################

keyword=$1

pushd $(locate $keyword|head -1)
$SHELL
