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
# output-test.sh
#
# Created:  Nov 25, 2011
# Author:   Rogério Carvalho Schneider <stockrt@gmail.com>


#############
## DEFINES ##
#############

tool="../gplfy.sh"
author_name="Rogério Carvalho Schneider"
author_email="stockrt@gmail.com"

year="$(date +"%Y")"
month="$(date +"%b")"
day="$(date +"%d")"


###########
## FUNCS ##
###########

filter_file () {
    sed \
        -e "s/@@year@@/$year/g" \
        -e "s/@@month@@/$month/g" \
        -e "s/@@day@@/$day/g" \
        "$1"
}


###########
## TESTS ##
###########

after () {
    rm -f AUTHOR COPYING LICENSE
}

it_creates_generic_c_license () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE)"
    license_output_content="$(filter_file files/generic-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c mycode.c | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_c_license_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE)"
    license_output_content="$(filter_file files/generic-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c -o mycode.c | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_c_sublicense () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE.sublicense)"
    license_output_content="$(filter_file files/generic-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c -s mycode.c | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_c_sublicense_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE.sublicense)"
    license_output_content="$(filter_file files/generic-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c -o -s mycode.c | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_c_license () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE)"
    license_output_content="$(filter_file files/specific-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c mycode.c "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_c_license_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE)"
    license_output_content="$(filter_file files/specific-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c -o mycode.c "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_c_sublicense () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE.sublicense)"
    license_output_content="$(filter_file files/specific-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c -s mycode.c "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_c_sublicense_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE.sublicense)"
    license_output_content="$(filter_file files/specific-output-LICENSE.c)"
    ret="$($tool -a "$author_name" -e $author_email -f c -o -s mycode.c "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_sh_license () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE)"
    license_output_content="$(filter_file files/generic-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh mycode.sh | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_sh_license_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE)"
    license_output_content="$(filter_file files/generic-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh -o mycode.sh | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_sh_sublicense () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE.sublicense)"
    license_output_content="$(filter_file files/generic-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh -s mycode.sh | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_generic_sh_sublicense_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/generic-LICENSE.sublicense)"
    license_output_content="$(filter_file files/generic-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh -o -s mycode.sh | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_sh_license () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE)"
    license_output_content="$(filter_file files/specific-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh mycode.sh "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_sh_license_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE)"
    license_output_content="$(filter_file files/specific-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh -o mycode.sh "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_sh_sublicense () {
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE.sublicense)"
    license_output_content="$(filter_file files/specific-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh -s mycode.sh "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}

it_creates_specific_sh_sublicense_overwrite () {
    touch AUTHOR COPYING LICENSE
    author_content="$(filter_file files/AUTHOR)"
    copying_content="$(filter_file files/COPYING)"
    license_content="$(filter_file files/specific-LICENSE.sublicense)"
    license_output_content="$(filter_file files/specific-output-LICENSE.sh)"
    ret="$($tool -a "$author_name" -e $author_email -f sh -o -s mycode.sh "My Program" | tail -n +7 | head -n -1)"
    a="$(< AUTHOR)"
    c="$(< COPYING)"
    l="$(< LICENSE)"
    test "$ret" = "$license_output_content"
    test "$a" = "$author_content"
    test "$c" = "$copying_content"
    test "$l" = "$license_content"
}
