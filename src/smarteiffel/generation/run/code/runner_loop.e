-- This file is part of Liberty Eiffel The GNU Eiffel Compiler Tools and Libraries.
-- See the Copyright notice at the end of this file.
--
class RUNNER_LOOP
   --
   -- a specific instruction for a running loop
   --

inherit
   INSTRUCTION

insert
   RUNNER_FACET

create {RUNNER_INSTRUCTIONS}
   make

feature {ANY}
   start_position: POSITION is
      do
         Result := loop_instruction.start_position
      end

   specialize_in (type: TYPE): like Current is
      do
         check False end
      end

   has_been_specialized: BOOLEAN is True

   specialize_thru (parent_type: TYPE; parent_edge: PARENT_EDGE; new_type: TYPE): like Current is
      do
         check False end
      end

   specialize_2 (type: TYPE): INSTRUCTION is
      do
         check False end
      end

   collect (type: TYPE): TYPE is
      do
         check False end
      end

   side_effect_free (type: TYPE): BOOLEAN is
      do
         Result := loop_instruction.side_effect_free(type)
      end

   use_current (type: TYPE): BOOLEAN is
      do
         Result := loop_instruction.use_current(type)
      end

   end_mark_comment: BOOLEAN is False

   compile_to_jvm (type: TYPE) is
      do
         check False end
      end

   adapt_for (type: TYPE): like Current is
      do
         check False end
      end

   safety_check (type: TYPE) is
      do
         check False end
      end

   pretty (indent_level: INTEGER) is
      do
         check False end
      end

   accept (visitor: VISITOR) is
      local
         v: RUNNER_LOOP_VISITOR
      do
         v ::= visitor
         v.visit_runner_loop(Current)
      end

feature {CODE, EFFECTIVE_ARG_LIST, NO_INVARIANT_WRAPPER}
   inline_dynamic_dispatch_ (code_accumulator: CODE_ACCUMULATOR; type: TYPE) is
      do
         check False end
      end

feature {ANONYMOUS_FEATURE, CODE, INTROSPECTION_HANDLER}
   simplify (type: TYPE): INSTRUCTION is
      do
         check False end
      end

feature {}
   make (a_loop: like loop_instruction) is
      require
         a_loop /= Void
      do
         loop_instruction := a_loop
      ensure
         loop_instruction = a_loop
      end

feature {RUNNER_LOOP_VISITOR}
   loop_instruction: LOOP_INSTRUCTION

end -- class RUNNER_LOOP
--
-- ------------------------------------------------------------------------------------------------------------------------------
-- Copyright notice below. Please read.
--
-- Liberty Eiffel is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License,
-- as published by the Free Software Foundation; either version 2, or (at your option) any later version.
-- Liberty Eiffel is distributed in the hope that it will be useful but WITHOUT ANY WARRANTY; without even the implied warranty
-- of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have
-- received a copy of the GNU General Public License along with Liberty Eiffel; see the file COPYING. If not, write to the Free
-- Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
--
-- Copyright(C) 2011-2012: Cyril ADRIAN, Paolo REDAELLI
--
-- http://liberty-eiffel.blogspot.com - https://github.com/LibertyEiffel/Liberty
--
--
-- Liberty Eiffel is based on SmartEiffel (Copyrights below)
--
-- Copyright(C) 1994-2002: INRIA - LORIA (INRIA Lorraine) - ESIAL U.H.P.       - University of Nancy 1 - FRANCE
-- Copyright(C) 2003-2006: INRIA - LORIA (INRIA Lorraine) - I.U.T. Charlemagne - University of Nancy 2 - FRANCE
--
-- Authors: Dominique COLNET, Philippe RIBET, Cyril ADRIAN, Vincent CROIZIER, Frederic MERIZEN
--
-- ------------------------------------------------------------------------------------------------------------------------------
