Distributed Publish
================================================================================
This document outlines the operation and organization of the publishing
mechanism for cosmos. At a high level this mechanism provide the following
operations:

1. Universe Install
2. CLI Install
3. Uninstall
4. Show System State

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
		|-- A {"data": { "operation": "installing" }}
		|-- B {"data": { "operation": "installing" }}
		|-- C {"data": { "operation": "installing" }}
		|-- D {"data": { "operation": "installing" }}

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
		|-- E
		|-- A
		|-- B


### Storage  ###################################################################
In this document we assume that the storage is S3. This storage contains the
installation. All the resources that an application needs in order to run must
be stored here.

Figure 3 shows what storage may look like.

Figure 3:

	/Storage
		|-- E
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

Operation Requirements
--------------------------------------------------------------------------------

### Show System State #########################################################
This operation shows the state of the system. It must show which packages have
been installed, are pending installation, are pending uninstallation, and have
failed to be installed.

### Universe Install ##########################################################
This operation attempts to make a package in the universe available in the local
repository of the cluster. In order for the package to be avaible it must move
to Successfully Installed state (#16 in the table). This means that all files
associated with the package must be present in S3, and there must be no errors
associated with the package in the error queue.

### CLI Install ###############################################################
This operation attempts to make a package in a local computer available to the
cluster through the local repository. It must satisfy all the requirements of
the Universe Install.

### Uninstall #################################################################
This operation removes a package from the local repository of the cluster. In
order for a package to be considered Not Installed (#0 in table). It must have
no files in S3 and there must be no errors associated with the package in the
error queue.

Package Coordinate
--------------------------------------------------------------------------------
TODO: Package Coordinate Discussion

Package Definition
--------------------------------------------------------------------------------
TODO: Define package

Installation Subsystem
--------------------------------------------------------------------------------
TODO: Define installation subsystem

