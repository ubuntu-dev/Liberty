indexing

	description: "The GtkAlignment widget controls the alignment and size of its child widget. It has four settings: xscale, yscale, xalign, and yalign."
	copyright: "(C) 2006 Paolo Redaelli <paolo.redaelli@poste.it>"
	license: "LGPL v2 or later"
	date: "$Date:$"
	revision: "$REvision:$"

			-- Description
	
			-- The scale settings are used to specify how much the child
			-- widget should expand to fill the space allocated to the
			-- GtkAlignment. The values can range from 0 (meaning the
			-- child doesn't expand at all) to 1 (meaning the child
			-- expands to fill all of the available space).
	
			-- The align settings are used to place the child widget
			-- within the available area. The values range from 0 (top or
			-- left) to 1 (bottom or right). Of course, if the scale
			-- settings are both set to 1, the alignment settings have no
			-- effect.

class GTK_ALIGNMENT
inherit
	GTK_BIN rename make as make_bin end
	GTK_ALIGNMENT_EXTERNALS
		-- TODO: GtkAlignment implements AtkImplementorIface.
	--SHARED_C_STRUCT
	
creation make

feature {NONE} -- size
	size: INTEGER is
		external "C inline use <gtk/gtk.h>"
		alias "sizeof(GtkAlignment)"
		end

feature {NONE} -- Creation
	make (xalign, yalign, xscale, yscale: REAL) is
			-- Creates a new GtkAlignment.  `xalign' : the horizontal
			-- alignment of the child widget, from 0 (left) to 1 (right).
			-- `yalign' : the vertical alignment of the child widget,
			-- from 0 (top) to 1 (bottom).  `xscale' : the amount that
			-- the child widget expands horizontally to fill up unused
			-- space, from 0 to 1. A value of 0 indicates that the child
			-- widget should never expand. A value of 1 indicates that
			-- the child widget will expand to fill all of the space
			-- allocated for the GtkAlignment.  `yscale' : the amount
			-- that the child widget expands vertically to fill up unused
			-- space, from 0 to 1. The values are similar to xscale.
		do
			handle := gtk_alignment_new (xalign,yalign,xscale,yscale)
			store_eiffel_wrapper
		end
feature
	set (xalign, yalign, xscale, yscale: REAL) is
			-- Sets the GtkAlignment values.  xalign : the horizontal
			-- alignment of the child widget, from 0 (left) to 1 (right).
			-- yalign : the vertical alignment of the child widget, from
			-- 0 (top) to 1 (bottom).  xscale : the amount that the child
			-- widget expands horizontally to fill up unused space, from
			-- 0 to 1. A value of 0 indicates that the child widget
			-- should never expand. A value of 1 indicates that the child
			-- widget will expand to fill all of the space allocated for
			-- the GtkAlignment.  yscale : the amount that the child
			-- widget expands vertically to fill up unused space, from 0
			-- to 1. The values are similar to xscale.
		do
			gtk_alignment_set (handle,xalign,yalign,xscale,yscale)
		end
	
feature -- paddings
	paddings: TUPLE[REAL,REAL,REAL,REAL] is
			-- Top, bottom, left and right padding. TODO shall be NATURAL
		local guint_padding_top,guint_padding_bottom,guint_padding_left,guint_padding_right: INTEGER
		do
			gtk_alignment_get_padding (handle,
												guint_padding_top,guint_padding_bottom,
												guint_padding_left,guint_padding_right)
			create Result.make_4 (guint_padding_top,guint_padding_bottom,
										 guint_padding_left,guint_padding_right)
		end

	-- TODO: implement
	top_padding: INTEGER is
			-- Top padding
		do
			gtk_alignment_get_padding (handle,$Result, default_pointer, default_pointer, default_pointer)
		ensure positive: Result>=0
		end
	
	bottom_padding: INTEGER is
			-- Bottom padding
		do
			gtk_alignment_get_padding (handle, default_pointer,$Result, default_pointer, default_pointer)
		ensure positive: Result>=0
		end

	left_padding: INTEGER is
			-- Left padding
		do
			gtk_alignment_get_padding (handle, default_pointer, default_pointer,$Result, default_pointer)
		ensure positive: Result>=0
		end
	right_padding: INTEGER is
			-- Right padding
		do
			gtk_alignment_get_padding (handle, default_pointer, default_pointer, default_pointer, $Result)
		ensure positive: Result>=0
		end


	set_paddings (padding_top,padding_bottom,padding_left,padding_right: INTEGER) is
		-- Sets the padding on the different sides of the widget. The
		-- padding adds blank space to the sides of the widget. For
		-- instance, this can be used to indent the child widget towards
		-- the right by adding padding on the left.  TODO
		-- padding_top,padding_bottom,padding_left,padding_right are
		-- guint therefore shall be NATURAL
		do
			gtk_alignment_set_padding (handle, padding_top,padding_bottom,padding_left,padding_right)
		end

	-- TODO: (perhaps sometimes unnecessary) wrap properties
	
-- Property Details
-- The "bottom-padding" property

--   "bottom-padding"       guint                 : Read / Write

-- The padding to insert at the bottom of the widget.

-- Allowed values: <= G_MAXINT

-- Default value: 0

-- Since 2.4
-- The "left-padding" property

--   "left-padding"         guint                 : Read / Write

-- The padding to insert at the left of the widget.

-- Allowed values: <= G_MAXINT

-- Default value: 0

-- Since 2.4
-- The "right-padding" property

--   "right-padding"        guint                 : Read / Write

-- The padding to insert at the right of the widget.

-- Allowed values: <= G_MAXINT

-- Default value: 0

-- Since 2.4
-- The "top-padding" property

--   "top-padding"          guint                 : Read / Write

-- The padding to insert at the top of the widget.

-- Allowed values: <= G_MAXINT

-- Default value: 0

-- Since 2.4
-- The "xalign" property

--   "xalign"               gfloat                : Read / Write

-- Horizontal position of child in available space. 0.0 is left aligned, 1.0 is right aligned.

-- Allowed values: [0,1]

-- Default value: 0.5
-- The "xscale" property

--   "xscale"               gfloat                : Read / Write

-- If available horizontal space is bigger than needed for the child, how much of it to use for the child. 0.0 means none, 1.0 means all.

-- Allowed values: [0,1]

-- Default value: 1
-- The "yalign" property

--   "yalign"               gfloat                : Read / Write

-- Vertical position of child in available space. 0.0 is top aligned, 1.0 is bottom aligned.

-- Allowed values: [0,1]

-- Default value: 0.5
-- The "yscale" property

--   "yscale"               gfloat                : Read / Write

-- If available vertical space is bigger than needed for the child, how much of it to use for the child. 0.0 means none, 1.0 means all.

-- Allowed values: [0,1]

-- Default value: 1
end
