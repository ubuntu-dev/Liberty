-- This file is part of SmartEiffel The GNU Eiffel Compiler Tools and Libraries.
-- See the Copyright notice at the end of this file.
--
class TEST_DIRECTORY02

insert
   EIFFELTEST_TOOLS

create {}
   make

feature {ANY}
   make
      local
         d: DIRECTORY; directory_path, s: ABSTRACT_STRING; f: TEXT_FILE_READ
      do
         directory_path := "."
         create d.scan(directory_path)
         assert(directory_path.is_equal("."))
         s := d.path
         assert(not s.is_equal(directory_path))
         assert(s.count > 1)
         d := d.parent
         s := d.path.twin
         assert(s.is_equal(d.path))
         create f.make
         d.connect_to_file_stream(f, "test_basic_directory.e")
         assert(f.is_connected)
         f.disconnect
      end

end -- class TEST_DIRECTORY02
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
-- Copyright(C) 2003-2006: INRIA - LORIA (INRIA Lorraine) - I.U.T. Charlemagne - University of Nancy 2 - FRANCE
--
-- Authors: Dominique COLNET, Philippe RIBET, Cyril ADRIAN, Vincent CROIZIER, Frederic MERIZEN
--
-- http://SmartEiffel.loria.fr - SmartEiffel@loria.fr
-- ------------------------------------------------------------------------------------------------------------------------------
