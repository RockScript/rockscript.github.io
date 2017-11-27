#### Prerequisites

To run the server and the command line interface (CLI)
 * Java 8 SE JRE

To build RockScript
 * Java 8 JDK
 * Maven 3.3.9

### Build rockscript.jar 

Open a terminal in the root folder and run

```
mvn -Pizza clean install
```

You eventually should see output like 

```
[INFO] rockscript-parent .................................. SUCCESS [  0.446 s]
[INFO] rockscript-gson-poly ............................... SUCCESS [  2.656 s]
[INFO] rockscript-netty-router ............................ SUCCESS [  0.460 s]
[INFO] rockscript-http-test ............................... SUCCESS [  0.455 s]
[INFO] rockscript ......................................... SUCCESS [  5.757 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
```
 
That means you have successfully created `rockscript/target/rockscript.jar`
 
### The rock executable

**`rock`** will be a convenient way to invoke the command line interface. It's a 
shortcut for `java -jar rockscript/target/rockscript.jar`

On Mac OS X, you can use the script `./install.sh` to create 
the `rock` executable bash script in `/usr/local/bin`.  

On Linux or Unix, [let me know](https://github.com/rockscript/rockscript/issues/new) if 
the above procedure works or if you prefer a different way of installing.

On Windows, create a `rock.bat` file in any directory specified in your `%path%` environment 
variable.  And put this content in the `rock.bat`
```
@echo off
java -jar rockscript/target/rockscript.jar %*
```  

### Starting the RockScript server

Start the RockScript server with 

```
rock server
```

You should see output like this

```
 ____            _     ____            _       _    
|  _ \ ___   ___| | __/ ___|  ___ _ __(_)_ __ | |_  
| |_) / _ \ / __| |/ /\___ \ / __| '__| | '_ \| __| 
|  _ < (_) | (__|   <  ___) | (__| |  | | |_) | |_  
|_| \_\___/ \___|_|\_\|____/ \___|_|  |_| .__/ \__| 
                                        |_|         
Server started on port 3652
```

**Limitation**: Bear in mind that for now, the server only has an in-memory event store.
So each time you reboot the server, it looses all it's scripts and script executions._

You can test your connection with the server by doing a ping like this

```
rock ping
> GET http://localhost:3652/ping ...
< 200 OK
< pong
```

### Command line interface

To get an overview of all the commands, just type `rock <Enter>` 

```
> rock
Usage: rock [command] [command options]

rock help [command]          | Shows help on a particular command
rock server [server options] | Start the rockscript server
rock ping [ping options]     | Test the connection with the server
rock deploy [deploy options] | Deploy script files to the server
rock start [start options]   | Starts a new script execution
rock end [end options]       | Ends a waiting activity
rock                         | Shows this help message

More details at https://github.com/rockscript/rockscript/wiki/RockScript-API
```

To get help on a specific command, type `rock help <command>`  Eg

```
> rock help deploy
rock deploy : Deploys script files to the server

usage: rock deploy [deploy options] [file or directory]
 -n <arg>   Script file name pattern used for scanning a directory.
            Default is *.rs  Ignored if a file is specified. See also
            https://docs.oracle.com/javase/tutorial/essential/regex/index.
            html
 -q         Quiet.  Don't show the HTTP requests to the server.
 -r         Scan directory recursive. Default is not recursive. Ignored if
            specified with a file.
 -s         The server URL.  Default value is http://localhost:3652

Example:
  rock deploy -r .
Deploys all files ending with extension .rs or .rst 
located in the current directory or one of it's nested
directories
```

Next, take the 5 minute [[Tutorial by example]]