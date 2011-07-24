-- This file is part of SmartEiffel The GNU Eiffel Compiler Tools and Libraries.
-- See the Copyright notice at the end of this file.
--
deferred class C_HEADER_PASS

inherit
   TYPE_MARK_VISITOR
      undefine
         is_equal
      end

insert
   C_LIVE_TYPE_MIXIN
      undefine
         is_equal
      end
   SINGLETON

feature {C_PRETTY_PRINTER}
   compile is
      do
         out_h.copy(header_comment)
         flush_out_h
         pre_compile
         smart_eiffel.live_type_map.do_all(agent compile_live_type)
      end

feature {}
   header_comment: STRING is
      deferred
      end

   pre_compile is
      deferred
      end

feature {}
   frozen standard_c_struct (type_mark: TYPE_MARK) is
         -- Produce C code for the standard C struct (for user's
         -- expanded or reference as well).
      require
         type_mark.is_static
         type_mark.need_c_struct
      local
         wa: ARRAY[RUN_FEATURE_2]; i, mem_id: INTEGER; a: RUN_FEATURE_2; t: TYPE_MARK
      do
         mem_id := type_mark.id
         wa := type_mark.type.live_type.writable_attributes
         out_h.copy(once "struct S")
         mem_id.append_in(out_h)
         out_h.extend('{')
         if type_mark.is_reference then
            if type_mark.type.live_type.is_tagged then
               out_h.append(once "Tid id;")
            end
         end
         if wa /= Void then
            from
               i := wa.upper
            until
               i = 0
            loop
               a := wa.item(i)
               t := a.result_type
               t.c_type_for_result_in(out_h)
               out_h.append(once " _")
               out_h.append(a.name.to_string)
               out_h.extend(';')
               i := i - 1
            end
         end
         out_h.append(once "};%N")
         flush_out_h
         if type_mark.is_expanded then
            -- For expanded comparison:
            cpp.prepare_c_function
            function_signature.append(once "int se_cmpT")
            mem_id.append_in(function_signature)
            function_signature.append(once "(T")
            mem_id.append_in(function_signature)
            function_signature.append(once "* o1,T")
            mem_id.append_in(function_signature)
            function_signature.append(once "* o2)")
            function_body.append(once "int R=0;%N")
            if wa /= Void then
               from
                  i := wa.upper
               until
                  i = 0
               loop
                  a := wa.item(i)
                  if not a.result_type.is_empty_expanded then
                     if a.result_type.is_expanded and then not a.result_type.is_kernel_expanded then
                        function_body.append(once "R = R || se_cmpT")
                        a.result_type.id.append_in(function_body)
                        function_body.append(once "(&(o1->_")
                        function_body.append(a.name.to_string)
                        function_body.append(once "), &(o2->_")
                        function_body.append(a.name.to_string)
                        function_body.append(once "));%N")
                     else
                        function_body.append(once "R = R || ((o1->_")
                        function_body.append(a.name.to_string)
                        function_body.append(once ") != (o2->_")
                        function_body.append(a.name.to_string)
                        function_body.append(once "));%N")
                     end
                  end
                  i := i - 1
               end
            end
            function_body.append(once "return R;%N")
            cpp.dump_pending_c_function(True)
         end
      end

   frozen standard_c_object_model (type_mark: TYPE_MARK) is
         -- Produce C code to define the model object.
      require
         type_mark.is_static
      local
         mem_id: INTEGER; lt: LIVE_TYPE
      do
         lt := type_mark.type.live_type
         mem_id := lt.id
         out_h.clear_count
         out_h.extend('T')
         mem_id.append_in(out_h)
         out_h.append(once " M")
         mem_id.append_in(out_h)
         out_c.clear_count
         c_object_model_in(lt)
         cpp.write_extern_2(out_h, out_c)
      end

   c_object_model_in (live_type: LIVE_TYPE) is
      local
         wa: ARRAY[RUN_FEATURE_2]; i: INTEGER; rf2: RUN_FEATURE_2; t: TYPE_MARK
      do
         wa := live_type.writable_attributes
         if wa = Void then
            if live_type.is_tagged then
               out_c.extend('{')
               live_type.id.append_in(out_c)
               out_c.extend('}')
            else
               live_type.canonical_type_mark.c_initialize_in(out_c)
            end
         else
            out_c.extend('{')
            if live_type.is_tagged then
               live_type.id.append_in(out_c)
               out_c.extend(',')
            end
            from
               i := wa.upper
            until
               i < wa.lower
            loop
               rf2 := wa.item(i)
               t := rf2.result_type
               t.c_initialize_in(out_c)
               i := i - 1
               if i >= wa.lower then
                  out_c.extend(',')
               end
            end
            out_c.extend('}')
         end
      end

invariant
   compiled /= Void

end -- class C_HEADER_PASS
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
