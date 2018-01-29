---
layout: docs
title: Language
---

RockScript is a subset of JavaScript (ECMAScript 5.1).   The main goal of 
RockScript is to support resilient, non-blocking script execution. We aim 
to implement the most used constructs to enable the stitching of service 
functions.   

This page documents which subset of JavaScript is supported. We leverage 
JavaScript for developers to  reduce the learning curve and it's the perfect 
language to [juggle with JSON](why-and-when#juggle-with-json), which most API's 
use these days.  But we do not aim to cover the complete language syntax. If 
you wonder why RockScript doesn't just use Node.js, [see at the bottom of this 
page](#rockscript-vs-nodejs).  

See the [Roadmap](roadmap) for what's next.

## System variable
The `system` variable is made available to every script.  It provides a mechanism 
to import activities, access the script input and (over time) other interactions 
with the runtime server environment.

#### system.import
E.g.
```javascript
var http = system.import('rockscript.io/http');
```

`system.import(url)` returns a script object that exposes activities as functions.

To learn about how to add activities to the engine, see [Services](services)

#### system.input

When starting a script, you can pass in data.  That input data 
is made available in the script under the `system.input` property.

An example:

```
POST http://localhost:3652/command 
Content-Type: application/json
{ "startScript" : {
    "scriptId": "s726",
    "input": {
      "orderId": "9sdf8",
      "countryCode": "01" 
    }
}}
```

You can access the countryCode in the script like this:

`var countryCode = system.input.countryCode;`

## Script block

Just like in JavaScript environments, the full script text itself is considered a block and 
the list of statements are executed sequential.

## Variable declaration

Examples
```javascript
var variableName;
var variableName = 'initial value';
var variableName = system.import('rockscript.io/http');
```

## Assignment

Examples
```javascript
result = 'initial value';
result.message = 'hello';
result.message['firstName'] = 'John';
```

## If-then-else

The condition expression will be converted to a boolean.  See also 
[Comparison operator expressions](#comparison-operator-expressions) for which comparators are supported.

Examples
```javascript
if (msg=='call') http.get({url: '...'});

var someVar = {thisConverts:'to boolean true'};
if (someVar) http.get({url: '...'});

if (flipper==='on') {
  http.get({url: '...'});
  flipper = 'off';
} else {
  flipper = 'on';
}
```

## Loops

TODO (not implemented yet)

## Functions

At the moment we don't support declaration of functions in the script.  We're believe it's best to leave 
out functions so that each script remains the scope of 1 function.  But this is still a hypothesis that 
we're seeking validation on.  So [your input](https://github.com/rockscript/rockscript/issues/new?title=Function+declarations) 
is greatly appreciated.

## Expressions

#### Literals

Examples
```javascript
'some text'
1
5.0
true
false
{ country: 'US' }
[ 'a', 'b', 'c']
```

#### Variable expressions
Examples
```javascript
variableName
variableName.propertName;
variableName.propertyName(arg0, arg1);
variableName[propertyName];
```
Or a combination of the above like eg
```
variableName.propertyName(arg0, arg1)['field'].anotherPropertyName;
```
Note that for service function invocations, any number of args is allowed.

#### Comparison operators

All of [Equality comparisons and sameness](https://developer.mozilla.org/nl/docs/Web/JavaScript/Equality_comparisons_and_sameness) 
is implemented 

> Limitation: While all automatic type conversions are implemented, object conversion functions like `toString ` and `valueOf` are not invoked yet.

Examples
```javascript
text=='some text'
'25' != service.getSomeNumber()
text==='some text'
5 < totalAmount
true > 0
customer.getAge() <= 25
'hello' >= company.getName()
```

#### Arithmic operators

All the addition conversions are correctly applied like in Node.js 

> Limitation: While all automatic type conversions are implemented, object conversion functions like `toString ` and `valueOf` are not invoked yet.

For now, only the addition `+` is supported:

Examples
```javascript
'hello' + ' world' 
5 + ' EUR'
'Formula ' + true
```

> TODO: -, *, /, %. **, ++, --

#### Logical operators and parenthesis

Examples
```javascript
!(true || false) && true
```

## RockScript vs Node.js

The purpose of RockScript is resilient script execution.  In order to do this, we 
need continuations.  This means that need the ability to serialize the complete 
runtime state of a script execution when the script is waiting for external 
callbacks.  And when the server gets a callback, we need to restore the 
runtime state from the persisted state and then resume execution at that 
position in the script.  Serializing and deserializing execution state 
and resuming an execution after deserializing it is something that other 
script engines can't do so that's why we created RockScript.

