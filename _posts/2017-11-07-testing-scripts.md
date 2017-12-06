---
layout: post
title:  "Testing scripts"
date:   2017-11-07 17:00:00 +0200
author: Tom Baeyens
categories:
---

Scripts are software and hence it should be easy to write automated test suites.  
While that sounds trivial, it’s lacking in many of the alternative orchestration 
technologies.

In RockScript we took this design consideration seriously from the start.  We 
are creating a `rockscript.io/test` component which allows to test your scripts.  
The test component exposes activities that 
* Start a script 
* Stub activities easily.  
* Assert expectations including script execution status

We defined a default extensions for test scripts `.rst`.  And we have a test 
runner that can run a test suite from the command line.  This way it’s easy to 
build it into your continuous integration pipeline.  

In the examples, there is a script `list-trains.rs` and two test scripts 
`list-trains-test-nok.rst` and `list-trains-test-ok.rst`.  Given those names
it will probably not surprise you that the first one will fail and the 
second one will succeed.

Here's the script we want to test.  It fetches the next trains leaving from 
some train station in Belgium.   

```javascript
var http = system.import('rockscript.io/http');

var stations = http.get({
  url: 'https://'+system.input.host+'/stations/NMBS?q=Turnhout',
  headers: {
    Accept: 'application/json'
  }
});
```

The host is an input parameter.  This will only work with the 
host being `irail.be`.

So the first test provides a wrong host name as input:

```javascript
var test = system.import('rockscript.io/test');

test.start({
  script: '.*/list-trains.rs',
  input: {
    host: 'irailWithATypo.be'
  }
});
``` 

While the second test provides the right host name.

```javascript
var test = system.import('rockscript.io/test');

test.start({
  script: '.*/list-trains.rs',
  input: {
    host: 'irail.be'
  }
});
```

When you run the test suite from the command line, you first get to see 
the HTTP request to the RockScript server.  The response is rather lengthy 
and it contains all the events for test executions.
And at the end, there is an easy-to-read summary of the test results.

```bash
$ rock test
  > POST http://localhost:3652/command
    Content-Type: application/json
    {"runTests":{}}
  < HTTP/1.1 200 OK
    Access-Control-Allow-Origin: *
    Content-Type: application/json
    Content-Length: 9737
[
  {
    "testName": "./docs/examples/test/list-trains-test-nok.rst",
    "events": [
      ...normal script execution events...
      { "serviceFunctionError": {
          "time": "2017-11-07T16:04:30.574Z",
          "scriptExecutionId": "se2",
          "executionId": "e7",
          "line": 3.0,
          "error": "Couldn\u0027t execute request https://irailWithATypo.be/stations/NMBS?q\u003dTurnhout: irailWithATypo.be: nodename nor servname provided, or not known",
          "scriptId": "sv4"
        }
      },
      { "serviceFunctionError": {
          "time": "2017-11-07T16:04:30.575Z",
          "scriptExecutionId": "se1",
          "executionId": "e7",
          "line": 3.0,
          "error": "Script start failed: Couldn\u0027t execute request https://irailWithATypo.be/stations/NMBS?q\u003dTurnhout: irailWithATypo.be: nodename nor servname provided, or not known",
          "scriptId": "sv2"
        }
      }
    ]
  },
  { "testName": "./docs/examples/test/list-trains-test-ok.rst",
    "events": [
      ...normal script execution events...
    ]
  }
]

XXX ./docs/examples/test/list-trains-test-nok.rst
XXX    [scriptId:sv4,line:3] Couldn't execute request https://irailWithATypo.be/stations/NMBS?q=Turnhout: irailWithATypo.be: nodename nor servname provided, or not known
XXX    [scriptId:sv2,line:3] Script start failed: Couldn't execute request https://irailWithATypo.be/stations/NMBS?q=Turnhout: irailWithATypo.be: nodename nor servname provided, or not known
 ✓  ./docs/examples/test/list-trains-test-ok.rst

Damn! 1 tests failed :(
```

 