Distributed Publish
================================================================================
This document outlines the operation and organization of the publishing
mechanism for cosmos. At a high level this mechanism must provide the following
operations:

1. Universe Install
2. CLI Install
3. Uninstall
4. Show System State

### Show System State ##########################################################
This operation shows the state of the system. It must show which packages have
been installed, are pending installation, are pending uninstallation, and have
failed an operation.

### Universe Install ###########################################################
This operation attempts to make a package in the universe available in the local
repository of the cluster. In order for the package to be available it must move
to the Successfully Installed state. This means that all files
associated with the package must be present in S3, and there must be no errors
associated with the operation.

### CLI Install ################################################################
This operation attempts to make a package in a local computer available to the
cluster through the local repository. It must satisfy all the requirements of
the Universe Install.

### Uninstall ##################################################################
This operation removes a package from the local repository of the cluster. In
order for a package to be considered Not Installed (#0 in table). It must have
no files in S3 and there must be no errors associated with the operation.

System State
--------------------------------------------------------------------------------
The system's state is stored in two places: S3 and zookeeper. We follow the DRY
principle and try to keep orthogonality in the data stored in these two places.
Zookeeper stores the metadata about operations that need to be performed while
S3 stores the final installation. At any point in the life of an installation
data relating to its state may reside in 3 data structures: Install Queue, Error
Queue, or Storage.

### Operation Queue ###########################################################
The install queue resides in zookeeper. It contains information about requested
operations. When a user wants to install or Uninstall a package, they add a node
to the Operation Queue.

Each element of this queue must contain the operation type, which could be one
of Universe Install, CLI Install or Uninstall, and the @package-metadata.
In the case that the operation is Install Local a Uri to the package must also
be provided.

Figure 1 shows what an operation queue may look like.

Figure 1:

	/Operations
		|-- A {TODO: Add node definition here}
		|-- B
		|-- C
		|-- D 

### Error Queue ################################################################
The error queue resides in zookeeper. It contains information about operations
that have encountered errors while being processed. The system adds nodes to
this queue. If while processing a operation in the operations queue it
encounters an error, it will move the data from the operations queue to the
errors queue.

Each element of this queue contains the same type of data found in the
operations queue.

Figure 2 shows what an error queue may look like.

Figure 2:

	/Errors
		|-- E {TODO: Add node definition here}
		|-- A
		|-- B


### Storage ####################################################################
In this document we assume that the storage is S3. This storage contains the
installation. All the resources that an application needs in order to run must
be stored here.

Figure 3 shows what storage may look like.

Figure 3:

	/Storage
		|-- E {TODO: Add node definition here}
		|-- A
		|-- B

Package Lifecycle
--------------------------------------------------------------------------------
At any point in the life of a package it can be in 20 states. The state of the
package is determined by it's data in the 3 data structures defined above.

	Table 1
	|------------------|-------|------|--------------------------------------|----|
	| Operation        | Error | S3   | State                                | #  |
	|------------------|-------|------|--------------------------------------|----|
	| None             | None  | None | Not Installed                        | 0  |
	| None             | Error | None | Failed                               | 1  |
	| CLI Install      | None  | None | CLI Install Pending                  | 2  |
	| CLI Install      | Error | None | CLI Install Reattempt                | 3  |
	| Universe Install | None  | None | Universe Install Pending             | 4  |
	| Universe Install | Error | None | Universe Install Reattempt           | 5  |
	| Uninstall        | None  | None | User Error: Package is not installed | 6  |
	| Uninstall        | Error | None | Abort Failed Install                 | 7  |
	| None             | None  | Some | *Corrupted*: Should not be possible  | 8  |
	| None             | Error | Some | Failed                               | 9  |
	| CLI Install      | None  | Some | *Corrupted*: Should not be possible  | 10 |
	| CLI Install      | Error | Some | CLI Install Reattempt                | 11 |
	| Universe Install | None  | Some | *Corrupted*: Should not be possible  | 12 |
	| Universe Install | Error | Some | Universe Install Reattempt           | 13 |
	| Uninstall        | None  | Some | *Corrupted*: Should not be possible  | 14 |
	| Uninstall        | Error | Some | Abort Failed Install                 | 15 |
	| None             | None  | All  | Successfully Installed               | 16 |
	| None             | Error | All  | Failed: Cosmos crashed               | 17 |
	| CLI Install      | None  | All  | User Error: Already installed        | 18 |
	| CLI Install      | Error | All  | CLI Install Reattempt                | 19 |
	| Universe Install | None  | All  | User Error: Already installed        | 20 |
	| Universe Install | Error | All  | Universe Install Reattempt           | 21 |
	| Uninstall        | None  | All  | Uninstall Pending                    | 22 |
	| Uninstall        | Error | All  | Abort Failed Install                 | 23 |
	|------------------|-------|------|--------------------------------------|----|

As elucidated by table 1 above. Even if all the data in package has been
persisted to S3, the package cannot be considered installed if there are errors
pending for it in the error queue. This indicates that in order to answer the
query "What packages are installed?" we must look at both the error queue and
S3, however we may ignore the operation queue.

Note that a failed unistall is equivalent to a falied install. From table 1 we
can see that there is no way to disambiguate them. This is fine, since the user
gets to decide how to proceed in the case of a failure.


Installation Subsystem
--------------------------------------------------------------------------------
The installation subsystem is responsible for moving packages between the
various states outline in table 1 in order to accomplish any one of the
operations outlined in above. It will be decomposed into 3 cooperating systems:
the operation producer, the operation processor and the garbage collector. 

### Producer ###################################################################
The producer is responsible for adding operations to the operation queue.
Depending on the operation the producer may have to do extra work besides
adding a node to the operation queue.

For each operation the producer will have to do the following work:

* CLI Install
	* Store package file in temporary S3 path
	* Add node to operation queue with the operation type, the package information, and the location of
	  the package i.e. the URI of the package in S3.
* Universe Install
	* Add node to operation	queue with the operation type, and the package
	  information.
* Uninstall
	* Add node to operation queue with the operation type, and the package
	  information
* Show System State
	* Nothing to do

### Processor ##################################################################


### Garbage Collector ##########################################################
The garbage collector is responsible for cleaning up files in S3 that are no
longer needed. As a prerequisite for the Processor to do its job, in the case of
a CLI install, it needs to have the package data available in a temporary
location in S3. Once the package has been installed, this data is no longer
necessary. This component cleans up this unnecessary data.

The operation of this component is as follows:

1. Get list of packages that are in the Successfully Installed state.
2. Remove any files in the temporary S3 directory that are duplicates of the
   list computed in step 1.

Note that while the order of operations above is safe, it may not get all the
garbage. It does not handle the case in which we attempt an install, but it
fails and then the user chooses to uninstall. We cannot safely handle this case
because we cannot disambiguate the scenario just mentioned from the scenario in
which the producer uploads a package to S3, gets delayed, and then adds the
operation to the operation queue. In the time between the upload to S3 and the
creation of the operation node, the state of the system is identical to a failed
install, followed by a user requested abort. There are bits in the temporary
folder, without a corresponding operation node.

One resolution to this issue is to delete nodes that do not have a corresponding
operation node, or error node after they have aged for a set amount of time. We
could say that if after a day there does not exist a operation node or error
node the temporary files are safe to be deleted. This would give us a very high
probability that we are not in the case where the producer got delayed between
the S3 upload and the node publish.

The above discussion suggests the following extension to the algorithm:

3. Get list of packages in the install pending, or error states.
4. Remove all packages that are greater than N hours old and do not appear in
   the list computed in 3.









Package Coordinate
--------------------------------------------------------------------------------
TODO: Package Coordinate Discussion

Package Definition
--------------------------------------------------------------------------------
TODO: Define package
Package Definition
--------------------------------------------------------------------------------
At a high level a package consists of a file called package.json which includes
the metadata associated with the package, and a, possibly empty, list of resources
that need to be uploaded to storage. This package constitutes the input to the
system.

TODO: This still needs more clarity on what a package definition contains

### Release Version ###########################################################
Another thorny issue with package definition is the presence of the release
version. This release version


