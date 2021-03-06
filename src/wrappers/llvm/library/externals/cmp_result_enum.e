-- This file have been created by wrapper-generator.
-- Any change will be lost by the next execution of the tool.

expanded class CMP_RESULT_ENUM

insert ENUM

creation {ANY} default_create
feature {ANY} -- Validity
    is_valid_value (a_value: INTEGER): BOOLEAN
        do
            Result := ((a_value = equal_value_low_level)  or else
				(a_value = greater_than_low_level)  or else
				(a_value = less_than_low_level)  or else
				(a_value = unordered_low_level) )
		end

feature {ANY} -- Setters
	default_create,
	set_equal_value
		do
			value := equal_value_low_level
		end

	set_greater_than
		do
			value := greater_than_low_level
		end

	set_less_than
		do
			value := less_than_low_level
		end

	set_unordered
		do
			value := unordered_low_level
		end

feature {ANY} -- Queries
	is_equal_value: BOOLEAN
		do
			Result := (value=equal_value_low_level)
		end

	is_greater_than: BOOLEAN
		do
			Result := (value=greater_than_low_level)
		end

	is_less_than: BOOLEAN
		do
			Result := (value=less_than_low_level)
		end

	is_unordered: BOOLEAN
		do
			Result := (value=unordered_low_level)
		end

feature {WRAPPER, WRAPPER_HANDLER} -- Low level values
	equal_value_low_level: INTEGER
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "cmpEqual"
 			}"
 		end

	greater_than_low_level: INTEGER
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "cmpGreaterThan"
 			}"
 		end

	less_than_low_level: INTEGER
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "cmpLessThan"
 			}"
 		end

	unordered_low_level: INTEGER
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "cmpUnordered"
 			}"
 		end


end -- class CMP_RESULT_ENUM
