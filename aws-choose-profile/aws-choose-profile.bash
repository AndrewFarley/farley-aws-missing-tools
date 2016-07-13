#!/bin/bash
#
###############################################################################
#
#    aws-choose-profile.bash         Written by Farley <farley@neonsurge.com>
#
# This helper scans for profiles defined in ~/.aws/credentials and in 
# ~/.aws/config and asks you to choose one of them, and then sets the 
# AWS_PROFILE and AWS_DEFAULT_PROFILE environment variables.  This is ONLY
# possible if you `source` this program in the `bash` shell, for other
# shell wrappers, see the other files with different extensions, if you don't
# see a shell you want, ask me and I'll add it!
#
# Usage example: 
#    source aws-choose-profile
# or
#    . aws-choose-profile
# 
# If you do not source it, this script will detect this state
# and warn you about it, and not allow you to choose (since it's)
# useless
#
# I recommend you symlink this into your user or system bin folder
# Please note: if you choose to install (aka cp) this, you must also install
# the file "aws-choose-profile-helper.py" along side it, which has the the 
# aws profile selection logic
#
###############################################################################

# Get actual folder this script is in, resolving all symlinks to files/folders
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Always print our current profile
if [[ $AWS_DEFAULT_PROFILE != '' ]]; then
    echo "Current AWS Profile: $AWS_DEFAULT_PROFILE"
else
    echo "Current AWS Profile: none"
fi

# Simple check if sourced...
if [ "$0" = "$BASH_SOURCE" ]; then
    echo "ERROR: Not sourced, please run source $0"
else
    unlink /tmp/aws-choose-profile.temp 2>/dev/null
    $DIR/aws-choose-profile-helper.py /tmp/aws-choose-profile.temp
    CHOSENPROFILE=`tail -n1 /tmp/aws-choose-profile.temp 2>/dev/null`
    unlink /tmp/aws-choose-profile.temp
    if [[ $CHOSENPROFILE = '' ]]; then
        echo ""
    else
        echo "Chosen Profile: $CHOSENPROFILE"
        export AWS_DEFAULT_PROFILE=$CHOSENPROFILE
        export AWS_PROFILE=$CHOSENPROFILE
        echo "Exported AWS_PROFILE and AWS_DEFAULT_PROFILE to $CHOSENPROFILE"
        echo ""
    fi
fi



