indexing
	description: "."
	copyright: "(C) 2006 Paolo Redaelli <paolo.redaelli@poste.it>"
	license: "LGPL v2 or later"
	date: "$Date:$"
	revision: "$Revision:$"

-- A GtkToggleButton is a GtkButton which will remain 'pressed-in' when clicked. Clicking again will cause the toggle button to return to its normal state.

-- A toggle button is created by calling either gtk_toggle_button_new() or gtk_toggle_button_new_with_label(). If using the former, it is advisable to pack a widget, (such as a GtkLabel and/or a GtkPixmap), into the toggle button's container. (See GtkButton for more information).

-- The state of a GtkToggleButton can be set specifically using gtk_toggle_button_set_active(), and retrieved using gtk_toggle_button_get_active().

-- To simply switch the state of a toggle button, use gtk_toggle_button_toggled.

-- Example 2. Creating two GtkToggleButton widgets.

-- void make_toggles (void) {
--    GtkWidget *dialog, *toggle1, *toggle2;

--    dialog = gtk_dialog_new ();
--    toggle1 = gtk_toggle_button_new_with_label ("Hi, i'm a toggle button.");

--    /* Makes this toggle button invisible */
--    gtk_toggle_button_set_mode (GTK_TOGGLE_BUTTON (toggle1), TRUE);
	
--    g_signal_connect (toggle1, "toggled",
--                      G_CALLBACK (output_state), NULL);
--    gtk_box_pack_start (GTK_BOX (GTK_DIALOG (dialog)->action_area),
--                        toggle1, FALSE, FALSE, 2);

--    toggle2 = gtk_toggle_button_new_with_label ("Hi, i'm another toggle button.");
--    gtk_toggle_button_set_mode (GTK_TOGGLE_BUTTON (toggle2), FALSE);
--    g_signal_connect (toggle2, "toggled",
--                      G_CALLBACK (output_state), NULL);
--    gtk_box_pack_start (GTK_BOX (GTK_DIALOG (dialog)->action_area),
--                        toggle2, FALSE, FALSE, 2);

--    gtk_widget_show_all (dialog);
-- }

class GTK_TOGGLE_BUTTON
inherit

	GTK_BUTTON redefine make, with_label, with_mnemonic end
	GTK_TOGGLE_BUTTON_EXTERNALS
		-- GtkToggleButton implements AtkImplementorIface.
	
creation make, with_label, with_mnemonic

feature {NONE} -- Creation
	make is
			-- Creates a new toggle button. A widget should be packed
			-- into the button, as GTK_BUTTON.make.
		do
			handle :=  gtk_toggle_button_new
		end


	with_label (a_label: STRING) is
			-- Creates a new toggle button with a text `a_label'.
		do
			handle :=  gtk_toggle_button_new_with_label (a_label.to_external)
		end
	
	with_mnemonic (a_label: STRING) is
			-- Creates a new GtkToggleButton containing `a_label'. The
			-- label will be created using GTK_LABEL.with_mnemonic, so
			-- underscores in label indicate the mnemonic for the button.
		do
			handle := gtk_toggle_button_new_with_mnemonic (a_label.to_external)
		end

feature 
	draw_indicator is
			-- Makes the button displayed as a separate indicator and
			-- label. This feature only effects instances of classes like
			-- GtkCheckButton and GtkRadioButton that derive from
			-- GtkToggleButton, not instances of GtkToggleButton itself.
		do
			gtk_toggle_button_set_mode (handle, 1)
		ensure is_indicator_drawn
		end

	draw_as_button is
			-- Makes the button look like a normal button.  This function
			-- only effects instances of classes like GtkCheckButton and
			-- GtkRadioButton that derive from GtkToggleButton, not
			-- instances of GtkToggleButton itself.
		do
			gtk_toggle_button_set_mode (handle, 0)
		ensure drawn_as_button
		end

	is_indicator_drawn: BOOLEAN is
			-- is the button displayed as a separate indicator and label?
		do
			Result := (gtk_toggle_button_get_mode(handle) = 1)
		end
	
	drawn_as_button: BOOLEAN is
			-- is the toggle button drawna as a normal button?
		do
			Result := (gtk_toggle_button_get_mode(handle) = 0)
		end

	toggled is
			-- Emits the toggled signal on the GtkToggleButton. There is
			-- no good reason for an application ever to call this
			-- function.
		do
			gtk_toggle_button_toggled (handle)
		end

	is_active: BOOLEAN is
			-- Is the toggle button pressed? (False means that it is
			-- raised).
		do
			Result:=(gtk_toggle_button_get_active(handle)).to_boolean
		end

	set_active is
			-- Sets the status of the toggle button to be 'pressed
			-- in'. This action causes the toggled signal to be emitted.
		do
			gtk_toggle_button_set_active (handle,1)
		end

	set_inactive is
			-- Sets the status of the toggle button to be 'pressed out',
			-- i.e.  to raise it. This action causes the toggled signal
			-- to be emitted.
		do
			gtk_toggle_button_set_active (handle,0)
		end

	is_inconsistent: BOOLEAN is
			-- Is button inconsistent?
		do
			Result := (gtk_toggle_button_get_inconsistent (handle)).to_boolean
		end


	set_inconsistent is
			-- If the user has selected a range of elements (such as some
			-- text or spreadsheet cells) that are affected by a toggle
			-- button, and the current values in that range are
			-- inconsistent, you may want to display the toggle in an "in
			-- between" state. This function turns on "in between"
			-- display. Normally you would turn off the inconsistent
			-- state again if the user toggles the toggle button. This
			-- has to be done manually, `set_inconsistent' only affects
			-- visual appearance, it doesn't affect the semantics of the
			-- button.
		do
			gtk_toggle_button_set_inconsistent (handle,1)
		ensure is_inconsistent
		end

	set_consistent is
		do
			gtk_toggle_button_set_inconsistent (handle,0)
		ensure not is_inconsistent
		end

feature -- "active" property

--   "active"               gboolean              : Read / Write

-- If the toggle button should be pressed in or not.

	-- Default value: FALSE
feature -- The "draw-indicator" property

--   "draw-indicator"       gboolean              : Read / Write

-- If the toggle part of the button is displayed.

-- Default value: FALSE
-- The "inconsistent" property

--   "inconsistent"         gboolean              : Read / Write

-- If the toggle button is in an "in between" state.

-- Default value: FALSE
-- Signals
-- The "toggled" signal

-- void        user_function                  (GtkToggleButton *togglebutton,
--                                             gpointer user_data);

-- Should be connected if you wish to perform an action whenever the GtkToggleButton's state is changed.
-- togglebutton :	the object which received the signal.
-- user_data :	user data set when the signal handler was connected.
-- See Also

-- GtkButton	

-- a more general button.
-- GtkCheckButton	

-- another way of presenting a toggle option.
-- GtkCheckMenuItem	

-- a GtkToggleButton as a menu item.

-- << GtkRadioButton	Numeric/Text Data Entry >>
end
