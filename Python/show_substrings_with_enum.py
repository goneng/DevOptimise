#!env python3

import sys

myString = 'Some (string) (inside (another) string)'

def show_substrings( base_str ):

    print( "\nStr: '%s'\n" % base_str )

    base_str_as_enum_list = list( enumerate( base_str ) )

    level = 0
    start_pos_stack = []

    for idx, char in base_str_as_enum_list:

        # print("DBG: (%2d) %s" % ( idx, char ) )

        if ( char == '(' ):
            level += 1
            start_pos_stack.append( idx + 1 )

        elif ( char == ')' ):
            level -= 1
            if ( level < 0 ):
                print( "ERR: Too many closing parentheses at position %d" % idx )
                sys.exit(1)
            else:
                end_pos = idx
                print( "---: '%s'" % base_str[ start_pos_stack.pop() : end_pos ] )


show_substrings( myString )

