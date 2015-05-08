Simple, but very useful: When an exception is thrown and not caught, BlitzMax will helpfully display the outcome of that exception's toString() method. When toString() has not been explicitly defined for such an exception its location in memory is returned. This is less helpful. Using some reflection trickery, any class inheriting from Exception will have a getname() method which retrieves the name of the class itself and its toString() method will return the same.

TODO: Is there any way to provide a stack trace as well? That would be pretty badass.
