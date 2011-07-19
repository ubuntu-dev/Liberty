-- This file is part of SmartEiffel The GNU Eiffel Compiler Tools and Libraries.
-- See the Copyright notice at the end of this file.
--
class INDEX_LIST
	--
	-- For the indexing clause in the heading part of a class.
	--

inherit
	VISITABLE
insert
	GLOBALS

creation {CLASS_TEXT}
	make

feature {ANY}
	pretty is
		local
			i: INTEGER
		do
			pretty_printer.set_indent_level(0)
			pretty_printer.put_string(once "indexing")
			pretty_printer.set_indent_level(1)
			from
				i := list.lower
			until
				i > list.upper
			loop
				list.item(i).pretty
				i := i + 1
			end
			pretty_printer.set_indent_level(0)
		end

	accept (visitor: INDEX_LIST_VISITOR) is
		do
			visitor.visit_index_list(Current)
		end

feature {INDEX_LIST_VISITOR}
	list: ARRAY[INDEX_CLAUSE]

feature {}
	make (first: INDEX_CLAUSE) is
		require
			first /= Void
		do
			create list.with_capacity(4, 1)
			list.add_last(first)
		ensure
			list.first = first
		end

feature {CLASS_TEXT}
	add_last (ic: INDEX_CLAUSE) is
		require
			ic /= Void
		do
			list.add_last(ic)
		end

invariant
	list.lower = 1

	not list.is_empty

end -- class INDEX_LIST
--
-- ------------------------------------------------------------------------------------------------------------------------------
-- Copyright notice below. Please read.
--
-- SmartEiffel is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License,
-- as published by the Free Software Foundation; either version 2, or (at your option) any later version.
-- SmartEiffel is distributed in the hope that it will be useful but WITHOUT ANY WARRANTY; without even the implied warranty
-- of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have
-- received a copy of the GNU General Public License along with SmartEiffel; see the file COPYING. If not, write to the Free
-- Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
--
-- Copyright(C) 1994-2002: INRIA - LORIA (INRIA Lorraine) - ESIAL U.H.P.       - University of Nancy 1 - FRANCE
-- Copyright(C) 2003-2004: INRIA - LORIA (INRIA Lorraine) - I.U.T. Charlemagne - University of Nancy 2 - FRANCE
--
-- Authors: Dominique COLNET, Philippe RIBET, Cyril ADRIAN, Vincent CROIZIER, Frederic MERIZEN
--
-- http://SmartEiffel.loria.fr - SmartEiffel@loria.fr
-- ------------------------------------------------------------------------------------------------------------------------------