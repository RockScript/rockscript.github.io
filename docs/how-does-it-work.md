---
layout: docs
title: How does it work
---

When RockScript executes a script, it persists the execution state. This is done for 2 reasons:

1. **Resilience and crash recovery**: Once a script is started, you can be sure it is monitored and survives 
crashes.  The execution state includes variables, call stack etc and is stored with event sourcing.
In case something goes wrong, you can inspect the runtime state and what happened from persistent 
storage.   
 
2. **Long running service functions**: The RockScript engine executes service functions non-blocking.
Script executions are persisted because while waiting for a service function to complete, the 
engine doesn't have to keep the script execution in memory.  So it doesn't matter if service functions 
take a long time to complete.  The runtime execution state can be reloaded from the event store and 
no memory resources are consumed while waiting.  

You can think of RockScript as a combination of a script engine and a state machine.  During 
service functions, the execution itself is in a wait state.  And when the service function 
completes, the script execution resumes.  

## Script store

Scripts are stored in text form and parsed on the fly when needed.  Scripts have [versions](script-versioning).
All changes to scripts are persisted through events.

To rebuild the execution state, the events are replayed.

## Script execution store

The script executions store a number of events.  A crucial thing the engine needs must be able to do is 
rebuild the execution state when a service function completes.    

## Executing service functions

Service functions are the only functions with side effects and they are executed by separate components 
called service function executors.  Some core service function executors are located inside the 
RockScript server, but your custom executors will be microservices hosted outside of the RockScript 
engine.  

The engine will talk to external service function executors over a HTTP protocol that is designed for 
non-blocking execution.  This protocol is described in [Service Provider Interface](service-spi).

## Replication

Replication can be done with Event Carried State Transfer.  This means that 
a replica server can build up its own database from listening to events coming from 
a master server.

> Limitation: Replication is not yet implemented.