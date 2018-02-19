---
layout: docs
title: Roadmap
---

This page documents the goals and tasks we plan to do next, without guarantees.  

Updated: 15 Feb 2018 

## Concurrency support

* system.resolveConcurrent({
  responseOne: http.get({...}),
  responseTwo: http.post({...})
}); 
* array.forEachConcurrent(function)  (this requires functions)

## Out-of-the-box service function implementations

TODO: identify which service functions make most sense.  Options are:

* Developer platform functions like Amazon, Google, Azure or Cloud Foundry 
* Product API functions like Salesforce, Google Apps
* On-premise connector functions for relational DBs etc 

## Persistence 

## Replication 
