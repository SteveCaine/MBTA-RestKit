MBTA-APIs
=========

This repository contains code that demonstrates how to access the Boston MBTA's new RESTful web service for information about the public transit agency's routes and services.

It uses the open-source RestKit library (https://github.com/RestKit/RestKit) to access the public API provided by version 2 of the MBTA's web service (http://www.mbta.com/rider_tools/developers/). The included demo app uses this library to execute five of the 20 separate queries provided by the MBTA service.  

To use, launch the app and tap any of the five rows in the table presented. Each will execute a separate API call and display a brief summary of the response in the table cell. Detailed information about the response is written to the Xcode debugger's console. 

NOTE: This code requires you to provide your own individual key for the v2 API, free upon request from the MBTA, to access the service. 

The public key to the MBTA's test server, on which the demo was originally based, stopped working shortly before this demo project was finished. 

Theis code is structured in such a way that other APIs to access this or other web services, can be added to the app without changing the public interface this code offers to developers. 

It is intended for demonstration purposes only, to show how differing implementations can be combined in a single app while hiding implementation details from the rest of the code. 

This code is distributed under the terms of the MIT license. See file "LICENSE" in this repository for details.

Copyright (c) 2014-2015 Steve Caine.<br>
@SteveCaine on github.com
