-- This file have been created by wrapper-generator.
-- Any change will be lost by the next execution of the tool.

expanded class GTKIMSTATUSSTYLE_ENUM

-- TODO emit_description(class_descriptions.reference_at(an_enum_name))

insert ENUM

creation default_create
feature -- Validity
    is_valid_value (a_value: INTEGER): BOOLEAN is
        do
            Result := ((a_value = gtk_im_status_callback_low_level)  or else
				(a_value = gtk_im_status_none_low_level)  or else
				(a_value = gtk_im_status_nothing_low_level) )
		end

feature -- Setters
	default_create,
	set_gtk_im_status_callback is
		do
			value := gtk_im_status_callback_low_level
		end

	set_gtk_im_status_none is
		do
			value := gtk_im_status_none_low_level
		end

	set_gtk_im_status_nothing is
		do
			value := gtk_im_status_nothing_low_level
		end

feature -- Queries
	is_gtk_im_status_callback: BOOLEAN is
		do
			Result := (value=gtk_im_status_callback_low_level)
		end

	is_gtk_im_status_none: BOOLEAN is
		do
			Result := (value=gtk_im_status_none_low_level)
		end

	is_gtk_im_status_nothing: BOOLEAN is
		do
			Result := (value=gtk_im_status_nothing_low_level)
		end

feature {WRAPPER, WRAPPER_HANDLER} -- Low level values
	gtk_im_status_callback_low_level: INTEGER is
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "GTK_IM_STATUS_CALLBACK"
 			}"
 		end

	gtk_im_status_none_low_level: INTEGER is
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "GTK_IM_STATUS_NONE"
 			}"
 		end

	gtk_im_status_nothing_low_level: INTEGER is
		external "plug_in"
 		alias "{
 			location: "."
 			module_name: "plugin"
 			feature_name: "GTK_IM_STATUS_NOTHING"
 			}"
 		end


end -- class GTKIMSTATUSSTYLE_ENUM
