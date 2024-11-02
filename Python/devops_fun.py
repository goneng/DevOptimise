# Perfect DevOps Utilities

import re

_trace_filter = ''  # Hide messages with a specific pattern
_trace_level = 0    # Print messages at this level or below
                    # ('2' is "verbose", '1' is "info", '0' is "normal")

# ------------------------------------------------------------------------------------- #

def is_float( number_maybe ):
    # Check if a numeric string represents a "float" value
    # based on https://note.nkmk.me/en/python-check-int-float/
    try:
        float( number_maybe )
    except ValueError:
        return False
    else:
        return True


def is_integer( number_maybe ):
    # Check if a numeric string represents an integer value
    # from https://note.nkmk.me/en/python-check-int-float/
    try:
        float( number_maybe )
    except ValueError:
        return False
    else:
        return float( number_maybe ).is_integer()


def replace_from_right( string, old_txt, new_txt, max_occurrences=1 ):
    # Replace the last occurrence of an expression in a string
    # from https://stackoverflow.com/a/2556252/1390251
    list_of_parts = string.rsplit(old_txt, max_occurrences)
    return new_txt.join(list_of_parts)


def trace_get_filter():
    return( _trace_filter )


def trace_get_level():
    return( _trace_level )


def trace_set_filter( trc_filter ):
    global _trace_filter
    _trace_filter = trc_filter


def trace_set_level( level ):
    global _trace_level
    _trace_level = level


def trace( level, *items_list ):

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


def trace_ast( *items_list ):
    trace( 0, '***', *items_list )


def trace_dbg( *items_list ):
    trace( 2, '-D-', *items_list )


def trace_err( *items_list ):
    trace( 0, '-E-', *items_list )


def trace_inf( *items_list ):
    trace( 1, '-I-', *items_list )


def trace_list_items( is_counter:bool=False, is_quoted:bool=False, *items_list ):
    quote_char = "'" if is_quoted else ""

    for i, item in enumerate( items_list, 1 ):
        if is_counter:
            trace_nrm( f"[{i:2}] {quote_char}{item}{quote_char}" )
        else:
            trace_nrm( f"{quote_char}{item}{quote_char}" )


def trace_nrm( *items_list ):
    trace( 0, '   ', *items_list )


def trace_sanitize( original_string, *terms_to_hide ):
    if not original_string:
        return original_string

    sanitized = str( original_string )
    for term in terms_to_hide:
        if term:
            sanitized = sanitized.replace( str( term ), "*******" )
    return sanitized


def trace_wrn( *items_list ):
    trace( 0, '-W-', *items_list )


def trace_xpn( message, exception_type = None ):
    """Log message then raise exception with original stack trace"""
    trace_err( message )
    if exception_type is None:
        exception_type = RuntimeError
    raise exception_type( message ) from None

# ------------------------------------------------------------------------------------- #

