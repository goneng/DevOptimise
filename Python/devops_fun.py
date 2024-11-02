# Perfect DevOps Utilities

import re

_trace_filter = ''  # Hide messages with a specific pattern
_trace_level = 0    # Print messages at this level or below
                    # ('2' is "verbose", '1' is "info", '0' is "normal")

# ------------------------------------------------------------------------------------- #

def do_fun_is_float( number_maybe ):
    # Check if a numeric string represents a "float" value
    # based on https://note.nkmk.me/en/python-check-int-float/
    try:
        float( number_maybe )
    except ValueError:
        return False
    else:
        return True


def do_fun_is_integer( number_maybe ):
    # Check if a numeric string represents an integer value
    # from https://note.nkmk.me/en/python-check-int-float/
    try:
        float( number_maybe )
    except ValueError:
        return False
    else:
        return float( number_maybe ).is_integer()


def do_fun_replace_from_right( string, old_txt, new_txt, max_occurrences=1 ):
    # Replace the last occurrence of an expression in a string
    # from https://stackoverflow.com/a/2556252/1390251
    list_of_parts = string.rsplit(old_txt, max_occurrences)
    return new_txt.join(list_of_parts)


def do_fun_trace_get_filter():
    return( _trace_filter )


def do_fun_trace_get_level():
    return( _trace_level )


def do_fun_trace_set_filter( trc_filter ):
    global _trace_filter
    _trace_filter = trc_filter


def do_fun_trace_set_level( level ):
    global _trace_level
    _trace_level = level


def do_fun_trace( level, *items_list ):

    if ( _trace_level > 0 ):
        #TODO Prepend a date-string to the list of items_list
        pass

    if ( level <= _trace_level ):
        # 'level' says we should print this line
        if ( _trace_filter ):
            tmp_message = ' '.join(items_list)
            if ( not re.search( _trace_filter, tmp_message ) ):
                # '_trace_filter' not found, so should print
                print( *items_list )
        else:
            # No '_trace_filter' at all, so should print
            print( *items_list )


def do_fun_trace_ast( *items_list ):
    do_fun_trace( 0, '***', *items_list )


def do_fun_trace_dbg( *items_list ):
    do_fun_trace( 2, '-D-', *items_list )


def do_fun_trace_err( *items_list ):
    do_fun_trace( 0, '-E-', *items_list )


def do_fun_trace_inf( *items_list ):
    do_fun_trace( 1, '-I-', *items_list )


def do_fun_trace_nrm( *items_list ):
    do_fun_trace( 0, '   ', *items_list )


def do_fun_trace_wrn( *items_list ):
    do_fun_trace( 0, '-W-', *items_list )

# ------------------------------------------------------------------------------------- #

