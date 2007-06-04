indexing
	description: "Wrapper callback for GCompareDataFunc"
	copyright: "[
					Copyright (C) 2007 Paolo Redaelli
					
					This library is free software; you can redistribute it and/or
					modify it under the terms of the GNU Lesser General Public License
					as published by the Free Software Foundation; either version 2.1 of
					the License, or (at your option) any later version.
					
					This library is distributed in the hopeOA that it will be useful, but
					WITHOUT ANY WARRANTY; without even the implied warranty of
					MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
					Lesser General Public License for more details.

					You should have received a copy of the GNU Lesser General Public
					License along with this library; if not, write to the Free Software
					Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
					02110-1301 USA
			]"

class G_COMPARE_DATA_CALLBACK

inherit GLIB_CALLBACK

insert SHARED_WRAPPERS_DICTIONARY

creation make

feature {} -- Creation
	make (a_factory: WRAPPER_FACTORY[COMPARABLE_SHARED_C_STRUCT];
			a_function: FUNCTION[ANY,TUPLE[COMPARABLE_SHARED_C_STRUCT,COMPARABLE_SHARED_C_STRUCT],INTEGER]) is
		-- `a_factory' is typically the container wrapper that creates
		-- the callback, i.e.: a G_TREE, asyncronous queues, linked
		-- lists and all Glib containers that require to compare to
		-- wrapped object.
		require
			factory_not_void: a_factory/=Void
			function_not_void: a_function/=Void
		do
			factory:=a_factory
			function:=a_function
		end

feature {WRAPPER, WRAPPER_HANDLER} -- Implementation
	factory: WRAPPER_FACTORY[COMPARABLE_SHARED_C_STRUCT]
	
	function: FUNCTION[ANY,TUPLE[COMPARABLE_SHARED_C_STRUCT,COMPARABLE_SHARED_C_STRUCT],INTEGER]

	callback (a,b: POINTER): INTEGER is
		local cscs_a, cscs_b: COMPARABLE_SHARED_C_STRUCT
		do
			-- export CECIL

			-- This callback will call FACTORY.`item_from' to build a
			-- wrapper of the correct type of an unwrapped object.

			-- `item_from' necessarly belong to FACTORY because
			-- G_COMPARE_DATA_CALLBACK has no knowledge of the effective
			-- type of the wrappers it handle.

			-- G_COMPARE_DATA_CALLBACK cannot be made generic otherwise
			-- we should declare the effective types used in the cecil
			-- file that produce the function called by Glib. A general
			-- callback class will need several version of the same
			-- function - one for each effective usage - when Glib's
			-- callback needs exactly one and only one.

			-- Therefore G_COMPARE_DATA_CALLBACK will call `item_from' on
			-- its coupled FACTORY that will create the effective
			-- wrapper.

			-- Note: feel free to ask Paolo further explanation of
			-- this. 2007-03-04
			if wrappers.has(a) then cscs_a ::= wrappers.at(a)
			else cscs_a := factory.item_from(a) end
			
			if wrappers.has(b) then cscs_b ::= wrappers.at(b)
			else cscs_b := factory.item_from(b) end
			
			Result:=(function.item([cscs_a,cscs_b]))
		end

	callback_address: POINTER is
		external "[
					 C inline use "glib-callbacks.h"
															  ]"
		alias "EiffelGCompareDataFunc"
		end
end -- class G_COMPARE_DATA_CALLBACK
