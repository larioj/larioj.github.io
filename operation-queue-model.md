# Op Q Model

* Operation -> OperationType
  * Install
  * Uninstall
* PackageAddResult -> OperationAddResult
  * Created
  * AlreadyExists
* PackageQueueContents -> Operation
  * pc: PackageCoordinate
  * operationType: OperationType
  * data: Either[PackageDefinition, Uri]
  * failure: Option[???]
* ??? -> OperationFailure


## High level usage
generator, cosumer, and cleaner

* View
  * List of states and their status
    * Map[PC, Status]
      * Status: Either[Operation, OperationFailure]
        * Operation: 
* Generator
  * Add operation to the operation queue
    * PackageAddResult
* Consumer
  * Get the element to process
  * Remove element if success
  * Move element to fail pile
  * Check if PC in fail pile

Next element should return the operation, with an optional
failure associated with it.


  


