****** Fatal Error: Cannot use an uppercase letter inside such
an identifier. Yes, this rule is strict, but it is better for
all of us to be able to distinguish at a glance a CLASS_NAME from
another name. Furthermore, it would be really too bad for example
to use `IsEmpty' or `isEmpty' at one place while all other places
are using `is_empty'. Finally, this strict constraint will help
us to improve error messages of the compiler.

Line 4 column 8 in BAD_CLASS2 (/home/colnet/SmartEiffel/work/lib_test3/bad_class2.e):
class dEferred BAD_CLASS2
       ^                 
------
