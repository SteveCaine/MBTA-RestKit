MBTA-APIs
=========

This parent respository contains two independent repositories demonstrating different ways to access the Boston MBTA's new [RESTful web service](http://www.mbta.com/rider_tools/developers/) for information about the public transit agency's routes and services.

Each child repository uses a different open-source library to access the MBTA service: [RestKit](https://github.com/RestKit/RestKit) and [RZImport](https://github.com/Raizlabs/RZImport). 

Each includes a demo app that uses its library to execute the first five of the 20+ queries supported by the MBTA. Each also has its own detailed *README* file with instructions on its use. 

**NOTE** 

Both demo apps use the public API key that the MBTA has provided for developers to test their code. For any extended use of the MBTA v2 API, you should obtain your own API key. The public key may be discontinued at any time (especially likely if its use is abused).

Personal API keys are available free of charge from the MBTA's [Developer Portal](http://realtime.mbta.com/portal), one for each app that you develop.  

This code is distributed under the terms of the MIT license. See file "LICENSE" in this repository for details.

Copyright (c) 2014-2015 Steve Caine.<br>
@SteveCaine on github.com


