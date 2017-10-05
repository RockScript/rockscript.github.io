---
layout: post
title:  "The RockScript idea explained"
date:   2017-10-02 11:04:22 +0200
author: Tom Baeyens
categories:
---

After building workflow engines [jBPM](https://www.jbpm.org) 
(JBoss / Red Hat), [Activiti](http://activiti.org) (Alfresco) and SaaS BPM product [Workflow 
Accellerator](https://www.signavio.com/products/workflow-accelerator/) (Signavio) for more then a 
[decade](https://sourceforge.net/p/jbpm/mailman/jbpm-users/?viewmonth=200304), I made the observation that the need 
for microservice integration is growing fast. It's one of the more technical use cases of workflows. And I saw a 
exciting potential for offering a scripting language for a broad range of developers that focuses on 
those use cases.

## RockScript for workflow developers   

The workflow diagram is typically expressed in 
[BPMN](https://en.wikipedia.org/wiki/Business_Process_Model_and_Notation), but there are numerous other flowchart like 
flavours around. Those workflow diagrams specify an execution flow. The execution flow is expressed with arrows 
connecting activities that are usually displayed as boxes.  RockScript also adopts the notion of an activity, but 
completely removes the diagram from the solution and expresses the execution flow in a scripting language with 
JavaScript syntax.  It turns out that most developers feel more in control when they edit a piece of JavaScript text 
in contrast to authoring a workflow diagram.

## RockScript for all developers

An activity is any interaction outside the RockScript execution engine.  Any interaction with an SaaS HTTP web API, 
a microservice, a database, filesystem or a cloud service are all examples of activities.  Also any request-response 
exchange pattern based on message queues fits perfect on an activity.  Activities look like 
JavaScript function invocations but the engine executes them asynchronous.  Most reactive frameworks are bolted as an 
afterthought on top of existing programming languages.  RockScript takes this a core design principle: any side effect 
is executed asynchronous.

Script executions are persisted with event sourcing. So while activities are waiting for a callback, no resources 
like memory or threads are consumed for that script execution. A single activity may take seconds, days or months 
to complete.  Once it is done, the runtime state of the script execution can be recreated from the event store.

## An example

Here's what a script will look like:
   
```javascript
var approvalService = system.import('example.com/approvals'); 
var notificationService = system.import('example.com/notifications');

var approvalResponse = approvalService.approve({
  approver: 'john.doe@example.com',
  question: 'Do you accept a raise?'
});

notificationService.notify({
  email: 'ross.the.boss@example.com',
  message: 'Joe '+(approvalResponse.ok ? 'approved' : 'declined')
});
```

Stored events for an execution of this script look like this

* Script with id `xyz` was started
* Variable `approvalService` was created and initialized with value v1
* Variable `notificationService` was created and initialized with value v2
* Activity `approve` of _example.com/approvals_ was started with input `{...}`
* Activity `approve` of _example.com/approvals_ is waiting for a callback
* Activity `approve` of _example.com/approvals_ ended with result value `{...}`
* Activity `notify` of _example.com/notifications_ was started with input `{...}`
* ...

The RockScript server can resume or recover an execution after every event.

## Use cases

In distributed systems, any system can fail, this includes your app, the RockScript server as well as any service 
that you use. This gradually introduces a lot of error handling complexity into the business logic code.  It doesn't 
have to be that way. RockScript keeps track and persists the execution state so that you can inspect exactly what went 
wrong in case of failures. 

Since the rise of open SaaS HTTP API's and microservices, this is more relevant then ever.  That's because most web 
API's are built on HTTP and 
don't support transactions.  RockScript is an alternative for transactions that at least ensures traceability so that 
you know exactly which requests completed and which were started but may or may not have finished.  RockScript itself 
will include features find script executions based on the error and resume execution after the root cause is 
fixed. That kind of resilient execution is what you need when working with microservices and SaaS web API's

The activity abstraction makes the resulting script code a lot easier to read. The potential is 
tremendous.  It's a simpler synchronization model in comparison to reactive approaches 
in existing programming languages and actor systems.

## See for yourself

On GitHub there is a lot more [background information](https://github.com/rockscript/rockscript/wiki).
 
You can also [run an example on your own machine](https://github.com/rockscript/rockscript/wiki/Tutorial-by-example) 
to get a good feel of how things works.
