#############
## DEFINES ##
#############

tool="../gplfy.sh"
author_name="Rogério Carvalho Schneider"
author_email="stockrt@gmail.com"


##############
## MESSAGES ##
##############

usage_msg="Usage: gplfy.sh -a <author_name> -e <author_email> -f <c|sh> [-o] [-s] <program_file> [program_name]"
format_error_msg="Error: Wrong format:"
license_error_msg="Error: License files already there.
Please remove them or use -o to overwrite."
creating_msg="Creating AUTHOR file...
Creating COPYING file...
Creating LICENSE file..."


###########
## TESTS ##
###########

it_displays_usage1 () {
    ret="$($tool | head -n 2 | tail -n 1)"
    test "$ret" = "$usage_msg"
}

it_displays_usage2 () {
    ret="$($tool -h | head -n 2 | tail -n 1)"
    test "$ret" = "$usage_msg"
}

it_validates_format1 () {
    wrong_arg="qwerty"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg mycode.c | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format2 () {
    wrong_arg="qwerty"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg mycode.c "My Program" | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format3 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg mycode.c | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format4 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg mycode.c "My Program" | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format5 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg -o mycode.c | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format6 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg -o mycode.c "My Program" | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format7 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg -s mycode.c | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format8 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg -s mycode.c "My Program" | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format9 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg -o -s mycode.c | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_validates_format10 () {
    wrong_arg="x"
    ret="$($tool -a "$author_name" -e $author_email -f $wrong_arg -o -s mycode.c "My Program" | head -n 2 | tail -n 1)"
    test "$ret" = "$format_error_msg $wrong_arg"
}

it_plays_nicely_with_files1 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c mycode.c | head -n 3 | tail -n 2)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$license_error_msg"
}

it_plays_nicely_with_files2 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c mycode.c "My Program" | head -n 3 | tail -n 2)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$license_error_msg"
}

it_plays_nicely_with_files3 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c -s mycode.c | head -n 3 | tail -n 2)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$license_error_msg"
}

it_plays_nicely_with_files4 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c -s mycode.c "My Program" | head -n 3 | tail -n 2)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$license_error_msg"
}

it_recreates_files1 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c -o mycode.c | head -n 3)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$creating_msg"
}

it_recreates_files2 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c -o mycode.c "My Program" | head -n 3)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$creating_msg"
}

it_recreates_files3 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c -o -s mycode.c | head -n 3)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$creating_msg"
}

it_recreates_files4 () {
    touch AUTHOR COPYING LICENSE
    ret="$($tool -a "$author_name" -e $author_email -f c -o -s mycode.c "My Program" | head -n 3)"
    rm -f AUTHOR COPYING LICENSE
    test "$ret" = "$creating_msg"
}
