indexing

	description: "The base object type of gobject library"
	long: "[
			 Currently the only wrapped features are those explicitly necessary to wrap GTK+ 2.x
			 GObject is the fundamental type providing the common attributes and methods for all object types in GTK+, Pango and other libraries based on GObject. The GObject class provides methods for object construction and destruction, property access methods, and signal support. Signals are described in detail in Signals(3).
			 ]"
	copyright: "(C) 2005 Paolo Redaelli <paolo.redaelli@poste.it>"
	license: "LGPL v2 or later"
	date: "$Date:$"
	revision "$REvision:$"

deferred class G_OBJECT
	-- GObject is the fundamental type providing the common attributes and
	-- methods for all object types in GTK+, Pango and other libraries based on
	-- GObject. The GObject class provides methods for object construction and
	-- destruction, property access methods, and signal support. Signals are
	-- described in detail in Signals(3).

inherit
	SHARED_C_STRUCT redefine from_external_pointer, dispose end
	ANY

insert
	GLIB_MEMORY_ALLOCATION export {NONE} all end
	G_OBJECT_EXTERNALS
	G_VALUE_EXTERNALS
	SHARED_EIFFEL_KEY

feature
	store_eiffel_wrapper is
			-- Store a pointer to Current into the underlying
			-- gobject. This pointer will be used to retrieve the Eiffel
			-- wrapper object when a C feature returns a generic object
			-- (i.e. the preview widget set in GTK_FILE_CHOOSER). 
		require
			not_stored: not is_eiffel_wrapper_stored
		do
			g_object_set_qdata (handle, eiffel_key.quark, to_pointer)
			-- We do the above direct call instead of using the
			-- Eiffel method "set_qdata (eiffel_key, Current)". This
			-- is to avoid an invariant check when passing Current as
			-- argument.
		ensure
			stored: is_eiffel_wrapper_stored
		end

	is_eiffel_wrapper_stored: BOOLEAN is
			-- Has a pointer to the Current Eiffel wrapper been stored
			-- into the underlying GObject's qdata property with the
			-- GQuark `eiffel_key' (which is currently "eiffel-wrapper")?
		do
			Result := has_qdata (eiffel_key)
		end

feature {WRAPPER} -- GObject type system implementation.
	type: INTEGER is
		do
			Result := g_object_type (handle)
		end
feature -- Creating

	from_external_pointer (a_ptr: POINTER) is
		require
			called_on_creation: is_null
			pointer_not_null: a_ptr.is_not_null
			not (create {G_RETRIEVER [like Current]}).has_eiffel_wrapper_stored (a_ptr)
		do
			Precursor (a_ptr)
			store_eiffel_wrapper
			ref -- Let's add a reference to the underlying g_object
		end

feature -- Disposing
	dispose is
			-- Dispose the g_object, calling unref and setting its handle to default_pointer.
		
			-- TODO: once the iusse explained in the debug tense in the implementation is 
			-- solved put a "require is_a_gobject: g_is_object (handle)" precondition
		do
			-- Note: when Eiffel dispose a G_OBJECT it just unref it and
			-- cleans its handle. The actual reclaiming of the memory
			-- alloca ted on the C side is left to gobject runtime.
			if is_g_object then unref
			else
				debug
					print ("Disposing g_object ") print (generator)
					print (" (at ") print (handle.out) print ("). handle is not a g_object.%N")
					print_notice
					-- Please see the notes in G_OBJECT.dispose
					-- Note: for the above perhaps dispose has been called
					-- after GTK libraries has already shut down. This
					-- could be a "feature" instead of a bug, since it is
					-- possible that this part of dispose won't be called
					-- if the garbage collector is called during
					-- application normal usage. Paolo 2006-04-24
				end
			end
			handle := default_pointer
		end

feature {} -- Disposing helper

	print_notice is
			-- Print once a copy of the note that has been put in 
			-- `dispose' source code.
		once
			print ("[
					  Please see the notes in G_OBJECT.dispose.
					  Perhaps dispose has been called after 
					  GTK libraries has already shut down. This
					  could be the correct behavious and not a bug, since it is
					  possible that this part of dispose  won't be called
					  if  the garbage collector is called during
					  application normal usage. 
					       Paolo 2006-04-24
					  
				  ]")
			end

	is_g_object: BOOLEAN is
			-- Is current handle a pointer to a g_object?
		do
			Result := (g_is_object (handle) /= 0)
		end

feature -- Reference count
	ref is
			-- Increases the reference count of object.
		local ptr: POINTER
		do
			ptr := g_object_ref (handle)
				check
					ptr_equals_handle: ptr = handle
				end
		end

	unref is
			-- Decreases the reference count if object. When its reference count
			-- drops to 0, the object is finalized (i.e. its memory is freed).
		do
			g_object_unref (handle)
		end

feature -- Properties

	notify (a_property_name: STRING) is
		-- Emits a "notify" signal for the property `a_property_name' on
		-- object.
		do
			g_object_notify (handle, a_property_name.to_external) 
		end

	freeze_notify is
			-- Stops emission of "notify" signals on object. The signals are queued
			-- until thaw_notify is called on object.  This is necessary for
			-- accessors that modify multiple properties to prevent premature
			-- notification while the object is still being modified.
		do
			g_object_freeze_notify (handle)
		end

	thaw_notify (object: POINTER) is 
			-- Causes all queued "notify" signals on object to be emitted. Reverts
			-- the effect of a previous call to freeze_notify.
		do
			g_object_thaw_notify (handle)
		end

	get_data (a_key: STRING): ANY is
			-- Gets a named field from the objects table of associations (see
			-- set_data).  `a_key': name of the key for that association; Void if no
			-- `a_key' field is present
		require valid_key: a_key /= Void
		local ptr: POINTER
		do
			-- Note: wrappers that needs to store C pointers and do other low-level
			-- stuff are invited to use g_object_get_data directly
			-- Note: Perhaps it is better to use GQuarks and g_object_get_qdata
			ptr := g_object_get_data (handle, a_key.to_external)
			if ptr.is_not_null then Result:=ptr.to_any end
		end
	
	set_data (a_key: STRING; data: ANY) is
			-- Store a reference to `data' under the name `a_key'. Each object
			-- carries around a table of associations from strings to pointers. If
			-- the object already had an association with that name, the old
			-- association will be destroyed.

			-- a_key : 	name of the key
			-- data : 	data to associate with that key
		require
			valid_key: a_key /= Void
			data_not_expanded: not data.is_expanded_type
		do
			-- Note: a_key is not duplicated since g_object_set_data requires a const
			-- gchar *;
			g_object_set_data (handle,a_key.to_external, data.to_pointer)
		end

	steal_data (a_key: STRING): ANY is
			-- Remove a specified datum from the object's data associations, --
			-- without invoking the association's destroy handler. Void if there's
			-- no data with `a_key'
		require valid_key: a_key /= Void
		local ptr: POINTER
		do
			ptr := g_object_steal_data (handle, a_key.to_external)
			if ptr.is_not_null then Result:=ptr.to_any end
		end

feature -- Quark-based data storing and retrieving
	has_qdata (a_key: G_QUARK): BOOLEAN is
			-- Is `a_key' field present in table of associations (see
			-- set_qdata)? `a_key': a GQuark, naming the user data
			-- pointer
		do
			Result := (g_object_get_qdata (handle, a_key.quark).is_not_null)
		end

	get_qdata (a_key: G_QUARK): ANY is
			-- Gets a named field from the objects table of associations
			-- (see set_data). `a_key': a GQuark, naming the user data
			-- pointer; Void if no `a_key' field is present
		local ptr: POINTER
		do
			ptr := g_object_get_qdata (handle, a_key.quark)
			if ptr.is_not_null then Result:=ptr.to_any end
		ensure 
			result_not_expanded: not Result.is_expanded_type
		end
	
	set_qdata (a_key: G_QUARK; data: ANY) is
			-- Store a reference to `data' under the GQuark `a_key'. Each
			-- object carries around a table of associations from strings
			-- to pointers. If the object already had an association with
			-- that name, the old association will be destroyed.

			-- a_key : 	name of the key
			-- data : 	data to associate with that key
		require
			data_not_expanded: not data.is_expanded_type
		do
			g_object_set_qdata (handle,a_key.quark, data.to_pointer)
		end
	
feature -- Properties query
	find_property (a_property_name: STRING): G_PARAM_SPEC is
			-- Find the parameter's spec for `a_property_name'. Can be
			-- Void if the class doesn't have a property of that name.
		require valid_name: a_property_name /= Void
		local ptr: POINTER
		do
			ptr:=g_object_class_find_property (handle,a_property_name.to_external)
			if ptr.is_not_null then
				create Result.from_external_pointer (ptr)
			end
		end

	has_property (a_property_name: STRING): BOOLEAN is
			-- Does Current has a property named `a_property_name'?
		require valid_name: a_property_name /= Void
		local ptr: POINTER
		do
			Result:= (g_object_class_find_property
						 (g_object_get_class(handle),a_property_name.to_external).is_not_null)
		end
	
	properties: FAST_ARRAY[G_PARAM_SPEC] is
		obsolete "TODO: entirely!"
		do
			-- TODO: using g_object_class_list_properties (oclass,n_properties:
			-- POINTER): POINTER is Returns an array of GParamSpec* for
			-- all properties of a class.  oclass: a GObjectClass
			-- n_properties: return location for the length of the
			-- returned array (i.e. a guint *). Returns: an array of
			-- GParamSpec* (i.e. a GParamSpec**) which should be freed
			-- after use
		ensure implemented: False
		end
	

feature -- Property getter/setter

	set_property (a_property_name: STRING; a_value: G_VALUE) is
			-- Sets `a_property_name' property on Current object to `a_value'
		require 
			valid_name: a_property_name /= Void
			valid_value: a_value /= Void
		do
			g_object_set_property (handle, a_property_name.to_external, a_value.handle)
		end
	
	get_property (a_property_name: STRING): G_VALUE is
			-- Gets the property name `a_property_name' of an object.
		require 
			valid_name: a_property_name /= Void
		local ptr: POINTER
		do
			ptr := malloc_g_value
			g_object_get_property (handle,a_property_name.to_external,ptr)
			create Result.from_external_pointer (ptr)
		end

	-- TODO: implement has_property  (a_property_name: STRING): BOOLEAN is
	-- require  valid_name: a_property_name /= Void do	end

	set_string_property (a_property_name, a_value: STRING) is
		require 
			valid_name: a_property_name /= Void
			valid_value: a_value /= Void
		do
			g_object_set_string_property (handle,a_property_name.to_external, a_value.to_external)
		end
	
	get_string_property (a_property_name: STRING): STRING is
			-- Gets the property named `a_property_name' of an
			-- object. Can be Void. TODO: this is complemetely untested!
			-- Test it, for example in GTK_CELL_RENDERER_PROGRESS
		require 
			valid_name: a_property_name /= Void
			has_property: has_property (a_property_name)
		local ptr: POINTER
		do
			g_object_get_one_property (handle,a_property_name.to_external,address_of (ptr))
			if ptr.is_not_null then
				create Result.from_external (ptr) 
			end
		end

	-- TODO: provide get_[string|integer|real|...]_property that does
	-- not allocate a temporary G_VALUE
invariant
	stored_eiffel_wrapper: is_not_null implies is_eiffel_wrapper_stored
end

