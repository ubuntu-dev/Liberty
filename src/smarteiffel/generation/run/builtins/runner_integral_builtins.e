-- This file is part of SmartEiffel The GNU Eiffel Compiler Tools and Libraries.
-- See the Copyright notice at the end of this file.
--
expanded class RUNNER_INTEGRAL_BUILTINS[E_ -> INTEGRAL]
--
-- a collection of builtins for INTEGRAL
--

insert
   RUNNER_NUMERIC_BUILTINS[E_]
      redefine
         call
      end

feature {RUNNER_BUILTINS}
   call (processor: RUNNER_PROCESSOR) is
      do
         inspect
            processor.current_frame.rf.name.to_string
         when "//" then
            builtin_infix_int_divide(processor)
         when "\\" then
            builtin_infix_int_modulo(processor)
         when "<" then
            builtin_infix_lt(processor)
         when "<=" then
            builtin_infix_le(processor)
         when ">" then
            builtin_infix_gt(processor)
         when ">=" then
            builtin_infix_ge(processor)
         else
            Precursor(processor)
         end
      end

feature {RUNNER_FACET}
   builtin_infix_divide (processor: RUNNER_PROCESSOR) is
      do
         processor.current_frame.set_return(processor.new_real_64(left(processor).item / right(processor).item))
      end

   builtin_infix_int_divide (processor: RUNNER_PROCESSOR) is
      do
         set_return(processor, left(processor).item // right(processor).item)
      end

   builtin_infix_int_modulo (processor: RUNNER_PROCESSOR) is
      do
         set_return(processor, left(processor).item \\ right(processor).item)
      end

   builtin_infix_lt (processor: RUNNER_PROCESSOR) is
      do
         processor.current_frame.set_return(processor.new_boolean(left(processor).item < right(processor).item))
      end

   builtin_infix_le (processor: RUNNER_PROCESSOR) is
      do
         processor.current_frame.set_return(processor.new_boolean(left(processor).item <= right(processor).item))
      end

   builtin_infix_gt (processor: RUNNER_PROCESSOR) is
      do
         processor.current_frame.set_return(processor.new_boolean(left(processor).item > right(processor).item))
      end

   builtin_infix_ge (processor: RUNNER_PROCESSOR) is
      do
         processor.current_frame.set_return(processor.new_boolean(left(processor).item >= right(processor).item))
      end

end -- class RUNNER_INTEGRAL_BUILTINS
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