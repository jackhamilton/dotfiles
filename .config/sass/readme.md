'sass -c' will execute any scripts defined in startup_scripts.config after the
clean step. Files should be defined one per line with no separator or quotes,
and the filepath should be relative to the project's root git dir.

Example: 
'''
scripts/install.sh
scripts/build-api.sh
'''

Possible issue: the script may currently only read the first line.
