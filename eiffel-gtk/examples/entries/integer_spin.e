class INTEGER_SPIN
inherit GTK_SPIN_BUTTON rename make as make_spin end
creation make
feature make is
		do
			with_range (0.0, 5.0, 1.0)
			connect (Current, "changed", $on_changed)
		end

	on_changed is
		do
			print(value.out) print (" Eiffel projects%N")
		end
	
end

