RockScript is a subset of JavaScript (ECMAScript 5.1)

TODO document or reference to explanation on how this is different from node or other javascript platforms

At the moment, only a very limited subset is supported.  We are working hard to expand.

### `system` variable
The `system` variable is made available to every script.  It provides a mechanism to import activities, access the script input and (over time) other interactions with the runtime server environment.

### `system.import`
E.g.
```javascript
var http = system.import('rockscript.io/http');
```

`system.import(url)` returns a script object that exposes activities as functions.

To learn about how to add activities to the engine, see

 * [[Activities over HTTP]]
 * [[Activities in Java]]

### `system.input`

When starting a script, you can pass in data.  That input data 
is made available in the script under the `system.input` property.

An example:

When starting a script like this, 
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

### Script

Just like in JavaScript environments, the full script text itself is considered a block and 
the list of statements are executed sequential.

### Variable declaration
Examples
```javascript
var variableName;
var variableName = 'initial value';
var variableName = system.import('rockscript.io/http');
```

### Expression

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
Note that for function/activity invocations, any number of args is allowed.

#### Literal expressions

Examples

```javascript
'some text'
5.0
true
false
{ country: 'US' }
[ 'a', 'b', 'c']
```