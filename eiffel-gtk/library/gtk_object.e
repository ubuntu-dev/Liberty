		-- Description

		-- GtkObject is the base class for all widgets, and for a few non-widget
		-- objects such as GtkAdjustment. GtkObject predates GObject; non-widgets
		-- that derive from GtkObject rather than GObject do so for backward
		-- compatibility reasons.

		-- The most interesting difference between GtkObject and GObject is the
		-- "floating" reference count. A GObject is created with a reference count of
		-- 1, owned by the creator of the GObject. (The owner of a reference is the
		-- code section that has the right to call g_object_unref() in order to
		-- remove that reference.) A GtkObject is created with a reference count of 1
		-- also, but it isn't owned by anyone; calling g_object_unref() on the
		-- newly-created GtkObject is incorrect. Instead, the initial reference count
		-- of a GtkObject is "floating". The floating reference can be removed by
		-- anyone at any time, by calling gtk_object_sink(). gtk_object_sink() does
		-- nothing if an object is already sunk (has no floating reference).

		-- When you add a widget to its parent container, the parent container will
		-- do this:

		--   g_object_ref (G_OBJECT (child_widget));
		--   gtk_object_sink (GTK_OBJECT (child_widget));

		-- This means that the container now owns a reference to the child widget
		-- (since it called g_object_ref()), and the child widget has no floating
		-- reference.

		-- The purpose of the floating reference is to keep the child widget alive
		-- until you add it to a parent container:
	
		-- button = gtk_button_new (); /* button has one floating reference to keep
		-- it alive */ gtk_container_add (GTK_CONTAINER (container), button); /*
		-- button has one non-floating reference owned by the container */

		-- GtkWindow is a special case, because GTK+ itself will ref/sink it on
		-- creation. That is, after calling gtk_window_new(), the GtkWindow will have
		-- one reference which is owned by GTK+, and no floating references.

		-- One more factor comes into play: the "destroy" signal, emitted by the
		-- gtk_object_destroy() method. The "destroy" signal asks all code owning a
		-- reference to an object to release said reference. So, for example, if you
		-- call gtk_object_destroy() on a GtkWindow, GTK+ will release the reference
		-- count that it owns; if you call gtk_object_destroy() on a GtkButton, then
		-- the button will be removed from its parent container and the parent
		-- container will release its reference to the button. Because these
		-- references are released, calling gtk_object_destroy() should result in
		-- freeing all memory associated with an object, unless some buggy code fails
		-- to release its references in response to the "destroy" signal. Freeing
		-- memory (referred to as finalization only happens if the reference count
		-- reaches zero.

		-- Some simple rules for handling GtkObject:

		-- * Never call g_object_unref() unless you have previously called
		-- g_object_ref(), even if you created the GtkObject. (Note: this is not true
		-- for GObject; for GObject, the creator of the object owns a reference.) 

		-- * Call gtk_object_destroy() to get rid of most objects in most cases. In
		-- particular, widgets are almost always destroyed in this way. 

		-- * Because of the floating reference count, you don't need to worry about
		-- reference counting for widgets and toplevel windows, unless you explicitly
		-- call g_object_ref() yourself.
indexing
	copyright: "(C) 2005 Paolo Redaelli <paolo.redaelli@poste.it>"
	license: "LGPL v2 or later"
	date: "$Date:$"
	revision "$REvision:$"

deferred class GTK_OBJECT

inherit
	G_OBJECT

	GTK_OBJECT_EXTERNALS

	G_SIGNALS

feature
	
	is_floating: BOOLEAN is
			-- Evaluates to TRUE if the object still has its floating reference
			-- count. See the overview documentation for GtkObject.
		do
			Result:= (gtk_object_floating(handle)).to_boolean
		end
	
	sink  is
			-- Removes the floating reference from a GtkObject, if it exists;
			-- otherwise does nothing. See the GtkObject overview documentation at
			-- the top of the page.
		do
			gtk_object_sink (handle)
		end


	destroy is
			-- Emits the "destroy" signal notifying all reference holders that they
			-- should release the GtkObject. See the overview documentation at the
			-- top of the page for more details.  The memory for the object itself
			-- won't be deleted until its reference count actually drops to 0;
			-- destroy merely asks reference holders to release their references,
			-- it does not free the object.
		do
			gtk_object_destroy (handle)
		end 
-- The "user-data" property

--   "user-data"            gpointer              : Read / Write

-- Anonymous User Data Pointer.
feature -- Signals
	-- The "destroy" signal

	-- void user_function (GtkObject *object, gpointer user_data);

	-- Signals that all holders of a reference to the GtkObject should
	-- release the reference that they hold. May result in finalization
	-- of the object if all references are released.
	
	-- object : 	the object which received the signal.
	-- user_data : 	user data set when the signal handler was connected.

	-- connect_to_destroy_signal (a_callback:
	-- 		FUNCTION[TUPLE[GTK_OBJECT],INTEGER]) is obsolete "use
	-- 		DESTROY_CALLBACK! Work In Progress: currectly it doesn't
	-- 		connect `a_callback' but invokes the fixed
	-- 		`destroy_callback' special feature."  local
	-- 		destroy_command: DESTROY_CALLBACK do create
	-- 		destroy_command.make (Current) end
	
feature {NONE} -- Signal names
	destroy_signal_name: STRING is "destroy"
end
	
