#!/bin/bash

## Process C files finding enumeration and turning them into proper
## Eiffel enumeration class with the design of Eiffel Wrapper
## Libraries Collection

process_file () {
    if [ -n $1 ] ; then 
	FILE=$1
	echo Processing $FILE
        
        # Loop initialization
	PROCESSABLE=$(mktemp -t create-eiffel-enum-processable-XXXX)
	PROCESSED=$(mktemp -t partially-processed-enum-XXXX)
	# echo Processable $PROCESSABLE Processed $PROCESSED
	cp $FILE $PROCESSABLE 
	
	while csplit --quiet --prefix=$PROCESSED $PROCESSABLE "/\benum\b/" "/}/1" 2>/dev/null
	do
	    cp ${PROCESSED}02 $PROCESSABLE
	    ENUM=${PROCESSED}01
	    process_enum $ENUM
	done
	# Cleanup
	rm $PROCESSABLE ${PROCESSED} \
	    ${PROCESSED}00 ${PROCESSED}01 ${PROCESSED}02 \
	    2>/dev/null 
    else
	echo process_file got no file to work on
    fi
}

print_usage () {
    cat <<EOF
$(basename $0) OPTIONS FILES

Options:
  --header=HEADER   Use HEADER instead of current file in external features

EOF
}

eiffellize_class_name () {
    ## Eiffellize class name, i.e from GtkButton to GTK_BUTTON
    if [ -n $1 ] ; then 
	echo $1 | 
	sed 's/\B\([A-Z]\)/_\1/g' |
	tr a-z- A-Z_
    fi
}

process_enum () {
    if [ -n $1 ] ; then 
	ENUM_FILE=$1
	ENUM_NAME=$(grep ";" $ENUM_FILE | tr --delete --complement [:alnum:] )
	EIFFEL_ENUM=$(eiffellize_class_name $ENUM_NAME)
	EIFFEL_ENUM_FILE=$(echo $EIFFEL_ENUM.e | tr '[:upper:]' '[:lower:]')
	echo Converting $ENUM_NAME into $EIFFEL_ENUM, file "$EIFFEL_ENUM_FILE"
	ENUM_PART=$(mktemp)
	csplit --quiet --prefix=$ENUM_PART $ENUM_FILE "/{/1" "/}/" 
	##declare -a ENUMERATION_ITEMS
	ENUMERATION_ITEMS=$(cat ${ENUM_PART}01 | tr --delete ",")
	PREFIX=$(longest_prefix $ENUMERATION_ITEMS)
	EIFFEL_PREFIX=$(echo $PREFIX| tr '[:upper:]' '[:lower:]')
	echo Prefix \"$PREFIX\", enumerations \"${ENUMERATION_ITEMS//${PREFIX}/}\"
	
	emit_header
	emit_setters
	emit_queries
	emit_values
	emit_footer
	
	apply_patch

	rm ${ENUM_PART}* 2>/dev/null # Cleaning up
    else echo No enum file to work on
    fi
}

longest_prefix () {
    ## TODO: check number of arguments if 1 return
    ## Change space between words to linefeed, 

    LENGTH=$(for item; do echo $item;done | wc --max-line-length )
    ##echo >/dev/stderr "Prefixes (max length $LENGTH): $@"
        
    while [ -z $PREFIX ] ; do
	PREFIX=$(expr substr $1 1 $LENGTH )
	## echo >/dev/stderr "Trying $PREFIX (length $LENGTH)"
	for item; do
	    if expr match "$item" "$PREFIX" >/dev/null
	    then : # Found
	    else PREFIX="" # Not found
	    fi
	done
	LENGTH=$(( $LENGTH - 1 ))
    done
    echo $PREFIX
}

emit_header () {
    CREATION_CLAUSE=$(set_$1)
    cat >$EIFFEL_ENUM_FILE <<EOF
indexing
	description: "Enum $ENUM_NAME"
	copyright: "[
					Copyright (C) $YEARS $COPYRIGHT_HOLDER,
					
					This library is free software; you can redistribute it and/or
					modify it under the terms of the GNU Lesser General Public License
					as published by the Free Software Foundation; either version 2.1 of
					the License, or (at your option) any later version.
					
					This library is distributed in the hope that it will be useful, but
					WITHOUT ANY WARRANTY; without even the implied warranty of
					MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
					Lesser General Public License for more details.

					You should have received a copy of the GNU Lesser General Public
					License along with this library; if not, write to the Free Software
					Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
					02110-1301 USA
				]"

-- WARNING! THIS FILE IS AUTOMATICALLY GENERATED. 

-- ANY CHANGE TO THIS WILL BE OVERWRITTEN BY NEXT EXECUTION OF
-- GENERATING SCRIPT!  You can puit your changes in the patch file
-- $EIFFEL_ENUM_FILE.patch; those changes will be applied to the newly
-- generated file.

expanded class $EIFFEL_ENUM
       -- Enum $ENUM_NAME

insert ENUM

creation $CREATION_CLAUSE

EOF
}

emit_setters () {
    cat >>$EIFFEL_ENUM_FILE <<EOF
feature -- Setters

EOF
    for VALUE in $ENUMERATION_ITEMS; do
	ITEM=$(echo ${VALUE#${PREFIX}} | tr '[:upper:]' '[:lower:]')
	cat >>$EIFFEL_ENUM_FILE <<EOF
    set_$ITEM is 
       do
          value := $EIFFEL_PREFIX$ITEM 
       ensure is_$ITEM 
       end

EOF
    done
}

emit_queries () {
    cat >>$EIFFEL_ENUM_FILE <<EOF
feature -- Queries

EOF
    for VALUE in $ENUMERATION_ITEMS; do
	ITEM=$(echo ${VALUE#$PREFIX}| tr '[:upper:]' '[:lower:]')
	cat >>$EIFFEL_ENUM_FILE <<EOF
    is_$ITEM: BOOLEAN is do Result:=$EIFFEL_PREFIX$ITEM end

EOF
    done
}

emit_values () {
    cat >>$EIFFEL_ENUM_FILE <<EOF
feature {WRAPPER, WRAPPER_HANDLER} -- Low level values

EOF
    for VALUE in $ENUMERATION_ITEMS; do
	ITEM=$(echo ${VALUE}| tr '[:upper:]' '[:lower:]')
	cat >>$EIFFEL_ENUM_FILE <<EOF
    $ITEM: INTEGER is
         external "C macro use $HEADER"
         alias "$VALUE"
         end

EOF
    done
}

emit_footer () {
    cat >>$EIFFEL_ENUM_FILE <<EOF
end -- class $EIFFEL_ENUM
EOF
}

apply_patch () {
    echo TODO: patches currently not applied.
}
for FILE in $@ ; do
    process_file $FILE
done
