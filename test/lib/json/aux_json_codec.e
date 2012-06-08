class AUX_JSON_CODEC

inherit
   JSON_CODEC[JSON_VALUE]

feature {JSON_HANDLER}
   build (data: JSON_VALUE): JSON_TEXT is
      do
         Result ::= data
      end

feature {JSON_DECODER}
   create_array: JSON_DATA is
      do
         create {AUX_JSON_DATA} Result.make(create {JSON_ARRAY}.make(create {FAST_ARRAY[JSON_VALUE]}.make(0)))
      end

   add_to_array (array, value: AUX_JSON_DATA) is
      local
         json_array: JSON_ARRAY; json_array_data: FAST_ARRAY[JSON_VALUE]
      do
         json_array ::= array.item
         json_array_data ::= json_array.array
         json_array_data.add_last(value.item)
      end

   create_object: JSON_DATA is
      do
         create {AUX_JSON_DATA} Result.make(create {JSON_OBJECT}.make(create {HASHED_DICTIONARY[JSON_VALUE, JSON_STRING]}.make))
      end

   add_to_object (object, key, value: AUX_JSON_DATA) is
      local
         json_object: JSON_OBJECT; json_members: HASHED_DICTIONARY[JSON_VALUE, JSON_STRING]
         json_key: JSON_STRING
      do
         json_object ::= object.item
         json_key ::= key.item
         json_members ::= json_object.members
         json_members.add(value.item, json_key)
      end

   create_string (string: JSON_STRING): JSON_DATA is
      do
         create {AUX_JSON_DATA} Result.make(create {JSON_STRING}.make(string.string))
      end

   create_number (number: JSON_NUMBER): JSON_DATA is
      do
         create {AUX_JSON_DATA} Result.make(create {JSON_NUMBER}.make(number.int, number.frac, number.frac_exp, number.exp))
      end

   true_value: JSON_DATA is
      once
         create {AUX_JSON_DATA} Result.make(create {JSON_TRUE}.make)
      end

   false_value: JSON_DATA is
      once
         create {AUX_JSON_DATA} Result.make(create {JSON_FALSE}.make)
      end

   null_value: JSON_DATA is
      once
         create {AUX_JSON_DATA} Result.make(create {JSON_NULL}.make)
      end

end -- class AUX_JSON_CODEC
