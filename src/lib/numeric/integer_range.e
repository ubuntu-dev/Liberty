-- This file is part of a Liberty Eiffel library.
-- See the full copyright at the end.
--
class INTEGER_RANGE

inherit
	TRAVERSABLE[INTEGER]

create {ANY}
	make

feature {ANY}
	lower: INTEGER
	upper: INTEGER

	count: INTEGER is
		do
			Result := upper - lower + 1
		end

	first: INTEGER is
		do
			Result := lower
		end

	last: INTEGER is
		do
			Result := upper
		end

	new_iterator: ITERATOR[INTEGER] is
		do
			create {INTEGER_RANGE_ITERATOR} Result.make(lower, upper)
		end

	item (i: INTEGER): INTEGER is
		do
			Result := i
		end

	is_empty: BOOLEAN is False

	make (low, up: INTEGER) is
		require
			low <= up
		do
			lower := low
			upper := up
		end

end -- class INTEGER_RANGE
--
-- Copyright (c) 2009 by all the people cited in the AUTHORS file.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.