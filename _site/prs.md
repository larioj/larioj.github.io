# PR improvements

* Make sure there are no typos
* If you are doing something you are not familiar with ask
* Double check APIs
  * Returning an Foo rather than an Option[Foo]
  * Make sure inputs to functions are non-redundant
* Make sure imports are expanded
* Always do the hard parts first
* Make constructor private if providing a companion object apply
* Move all fields that don't depend on the class to the component object
* Don't duplicate documentation
* Full variable names
* If something looks complicated try making an object that reduces the complexity
* Check line lengths
* Make sure all files end in newline
* Make all types as specific as possible
* Don't pass in items, even wrapped in other object, that you are not using
* Put tests first in the file
* Inline simple test objects
* One commit per PR comment
* Add comment when it's not immediately obvious why a method exists
* Make class auto closable when opening curator resources
