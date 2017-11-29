---
layout: post
title:  "CQRS, subscriptions and triggers"
date:   2017-11-08 09:00:00 +0200
author: Tom Baeyens
categories:
---

I think there is something missing in how we think about API’s and CQRS.  It came to my mind again when I was reading the InfoQ 
[Virtual Panel: Microservices Interaction and Governance Model - Orchestration v Choreography](https://www.infoq.com/articles/vp-microservices-orchestration-choreography).

The article mentions CQRS a few times, and Chris Richardson gives a concise description : *One simple way to think about 
microservice interaction is in terms of commands and queries*.  This has become a the common way to think about an API: 
“An API has queries and commands”.  I think it makes sense to add subscriptions on the same level.

Subscriptions are also known as webhooks or event listeners.  I believe that is also a fundamental concept in an API.  
We describe API’s too much in combination with the underlying technology like eg a REST API or messaging.  I think it 
helps to consider the conceptual level of an API first and subscriptions should be a part of it.  In my opinion, any 
API consists conceptually of 

* Queries
* Commands
* Subscriptions

These concepts are to be considered apart from the underlying technology which are used.  Queries, commands and 
subscriptions can be implemented as REST over HTTP, over messages, GraphQL and many more concrete combinations. 

I believe that if APIs would be described in terms of queries, commands and subscriptions, that it would be more natural 
build [Event Driven Architectures](https://en.wikipedia.org/wiki/Event-driven_architecture).  GraphQL is 
[moving in that direction](http://graphql.org/blog/subscriptions-in-graphql-and-relay/ ).

Let’s zoom in on the subscriptions for a minute. Event Driven Architecture means to me the realization that you can move 
a large part of the logic of your application into subscriptions.  If this event happens, do this action.  Sounds 
familiar?  

I think that [IFTTT](https://ifttt.com/), [Zapier](https://zapier.com/) and their clones show the 
value of subscriptions for consumers.  That is exactly one of the use cases that 
RockScript envisions, but than for developers.  An event triggers a script.  The script calls out to a number of 
commands in other services.  API Commands should be mapped to RockScript activities.  Either by yourself or by using 
an existing serviceFunction worker. And we also envision the addition of a trigger as a reusable, configurable subscription 
that starts a RockScript.   
