#!/bin/bash

# Initializations
# ...

# Services start
service ssh start
service mysql start

# Run Bash
/bin/bash -l
