-- This file have been created by eiffel-gcc-xml.
-- Any change will be lost by the next execution of the tool.
expanded class G_SEEK_TYPE
insert ENUM

create {ANY} default_create
feature {ANY} -- Validity
	is_valid_value (a_value: INTEGER): BOOLEAN
		do
			Result := ((a_value = g_seek_cur) or else 
				(a_value = g_seek_set) or else 
				(a_value = g_seek_end))
		end


feature {ANY} -- Setters
	default_create, set_g_seek_cur
		do
			value := g_seek_cur
		end

	set_g_seek_set
		do
			value := g_seek_set
		end

	set_g_seek_end
		do
			value := g_seek_end
		end


feature {ANY} -- Queries
	is_g_seek_cur: BOOLEAN
		do
			Result := (value=g_seek_cur)
		end

	is_g_seek_set: BOOLEAN
		do
			Result := (value=g_seek_set)
		end

	is_g_seek_end: BOOLEAN
		do
			Result := (value=g_seek_end)
		end


feature {WRAPPER, WRAPPER_HANDLER} -- Low level values
	g_seek_cur: INTEGER
		external "C macro use <library/externals/all-gda-includes.h>"
		alias "G_SEEK_CUR"
		end

	g_seek_set: INTEGER
		external "C macro use <library/externals/all-gda-includes.h>"
		alias "G_SEEK_SET"
		end

	g_seek_end: INTEGER
		external "C macro use <library/externals/all-gda-includes.h>"
		alias "G_SEEK_END"
		end


end

