#!/usr/bin/env bash

# Copyright (C) 2011 Rogério Carvalho Schneider <stockrt@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#
# gplfy.sh
#
# Created:  Nov 25, 2011
# Author:   Rogério Carvalho Schneider <stockrt@gmail.com>


##############
## MESSAGES ##
##############

format_error_msg="Error: Wrong format:"
license_error_msg="Error: License files already there.
Please remove them or use -o to overwrite."


##########
## ARGS ##
##########

usage () {
    echo "
Usage: gplfy.sh -a <author_name> -e <author_email> -f <c|sh> [-o] [-s] <program_file> [program_name]
    -a Author name.
    -e Author e-mail.
    -f Comment format.
        c: for C code.
        sh: for Shell script code.
    -o Overwrite existing files.
    -s Sublicense note.

Examples:
    gplfy.sh -a \"Rogério Carvalho Schneider\" -e stockrt@gmail.com -f sh mycode.sh
    gplfy.sh -a \"Rogério Carvalho Schneider\" -e stockrt@gmail.com -f c mycode.c
    gplfy.sh -a \"Rogério Carvalho Schneider\" -e stockrt@gmail.com -f c mycode.c \"My Program\"
    gplfy.sh -a \"Rogério Carvalho Schneider\" -e stockrt@gmail.com -f c mycode.c MyProgram
    gplfy.sh -a \"Rogério Carvalho Schneider\" -e stockrt@gmail.com -f c -o mycode.c MyProgram
    gplfy.sh -a \"Rogério Carvalho Schneider\" -e stockrt@gmail.com -f c -o -s mycode.c \"My Program\"
"
}

overwrite=0
sublicense=0
while getopts a:e:f:osh name
do
    case $name in
        a)
            author_name="$OPTARG"
            ;;
        e)
            author_email="$OPTARG"
            ;;
        f)
            format="$OPTARG"

            if [[ "$format" == "c" ]]
            then
                formatter="c_format"
            elif [[ "$format" == "sh" ]]
            then
                formatter="sh_format"
            else
                echo
                echo "$format_error_msg $format"
                usage
                exit 1
            fi
            ;;
        o)
            overwrite=1
            ;;
        s)
            sublicense=1
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $(($OPTIND - 1))

program_file="$1"
program_name="$2"

if [[ -z "$author_name" || -z "$author_email" || -z "$formatter" || -z "$program_file" ]]
then
    usage
    exit 1
fi


#############
## CONFIGS ##
#############

# Exit on command or variable expansion errors
set -e -u

year="$(date +"%Y")"
month="$(date +"%b")"
day="$(date +"%d")"


#############
## DEFINES ##
#############

author="$author_name <$author_email>"

copyright="Copyright (C) $year $author"

generic_license_template="$copyright

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>."

specific_license_template="$copyright

This file is part of $program_name.

$program_name is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

$program_name is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with $program_name.  If not, see <http://www.gnu.org/licenses/>."

specific_license_rootfile_template="$copyright

$program_name is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

$program_name is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with $program_name.  If not, see <http://www.gnu.org/licenses/>."

authorship_template="


$program_file

Created:  $month $day, $year
Author:   $author"

sublicense_generic_template="

All files in this program are under GPL unless otherwise noted in
file's header.  Some files may be sublicensed."

sublicense_specific_template="

All files in $program_name are under GPL unless otherwise noted in
file's header.  Some files may be sublicensed."


###########
## FUNCS ##
###########

c_format () {
    echo "/*"
    while read line
    do
        if [[ ! -z "$line" ]]
        then
            echo " * $line"
        else
            echo " *"
        fi
    done <<< "$1"
    echo " *"
    echo " */"
}

sh_format () {
    while read line
    do
        if [[ ! -z "$line" ]]
        then
            echo "# $line"
        else
            echo "#"
        fi
    done <<< "$1"
}


##########
## MAIN ##
##########

if [[ $overwrite -eq 0 ]]
then
    if [[ -f AUTHOR || -f COPYING || -f LICENSE ]]
    then
        echo
        echo "$license_error_msg"
        usage
        exit 1
    fi
fi

# AUTHOR
echo "Creating AUTHOR file..."
echo "$author" > AUTHOR

# COPYING
echo "Creating COPYING file..."
wget -q -c -N http://www.gnu.org/licenses/gpl.txt -O COPYING

# LICENSE
echo "Creating LICENSE file..."
if [[ -z "$program_name" ]]
then
    # Generic license
    if [[ $sublicense -eq 1 ]]
    then
        license_output="$generic_license_template$sublicense_generic_template"
    else
        license_output="$generic_license_template"
    fi

    echo "$license_output" > LICENSE

    echo
    echo "Copy and paste this is your file's header:"
    echo "------------------------------------------------------------------------"
    $formatter "$generic_license_template$authorship_template"
    echo "------------------------------------------------------------------------"
else
    # Specific license
    if [[ $sublicense -eq 1 ]]
    then
        license_output="$specific_license_rootfile_template$sublicense_specific_template"
    else
        license_output="$specific_license_rootfile_template"
    fi

    echo "$license_output" > LICENSE

    echo
    echo "Copy and paste this is your file's header:"
    echo "------------------------------------------------------------------------"
    $formatter "$specific_license_template$authorship_template"
    echo "------------------------------------------------------------------------"
fi
