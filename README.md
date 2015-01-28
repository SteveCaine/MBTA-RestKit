MBTA-APIs
=========

This repository contains code that demonstrates how to access the Boston MBTA's new [RESTful web service](http://www.mbta.com/rider_tools/developers/) for information about the public transit agency's routes and services.

It uses the open-source [RestKit](https://github.com/RestKit/RestKit) library to access the public API provided by version 2 of the MBTA web service. The included demo app uses this library to execute the first five of the 20 queries provided by the MBTA service.  

It also uses the [RKXMLReaderSerialization](https://github.com/RestKit/RKXMLReaderSerialization) and the [XML-to-NSDictionary](https://github.com/blakewatters/XML-to-NSDictionary) open source libraries to support parsing responses delivered as XML rather than JSON (when the compile-time flag 'CONFIG_useXML' is set to a non-zero value in file "MBTA-APIs-Prefix.pch"). 

The raw XML or JSON can be written to NSLog() by setting the compile-time flag 'DEBUG_logRawResponse' to a non-zero value in file "Pods-RestKit-prefix.pch" (under the 'Pods' Xcode project at "Pods/RestKit/Support Files/").

To use this code, launch the app and tap any of the five rows in the table presented. Each will execute a separate API call and display a brief summary of the response in the table cell. Detailed information about the response is written to the Xcode debugger's console. 

**NOTE** 

This code uses the public API key that the MBTA has provided for developers to test their code. For any extended use of the MBTA v2 API, you should obtain your own API key. The public key may be discontinued at any time (especially likely if its use is abused).

Personal API keys are available free of charge from the MBTA's [Developer Portal](http://realtime.mbta.com/portal), one for each app that you develop.  

This code is structured in such a way that other APIs, to access this or other web services, can be added to the app without changing the public interface this code offers to developers. 

It is intended for demonstration purposes only, to show how differing implementations can be combined in a single app while hiding implementation details from the rest of the code. 

This code is distributed under the terms of the MIT license. See file "LICENSE" in this repository for details.

Copyright (c) 2014-2015 Steve Caine.<br>
@SteveCaine on github.com
