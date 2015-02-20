# Installation
* Use [CocoaPods](http://www.cocoapods.org), navigate to the project folder containing the podfile and run `pod install`
* Open the workspace in either XCode or AppCode, compile and run the app

**Warning**
Please note that running this application on your device will take up approximately 360MB of disk space. The entire set of League of Legends images are cached. You should make sure that you run this application while connected to WiFi or you will use 350MB of data as soon as the app launches.

# Introduction
LoL Book of Champions is an iOS application that is more a playground for some key tech I wanted to play with than anything else. However, it is a simple League of Legends Champion Browser. I am fortunate to work at Riot Games and this application also shows off the champion imagery from the talented artists at Riot Games. It uses the [Riot Games Developer API](http://developer.riotgames.com) to obtain champion data.

**NOTE**
The application uses my personal Riot Games Developer API key to access the service to retrieve champion data. If you do anything more than run the app once to see it, please register for your own key at [http://developer.riotgames.com](http://developer.riotgames.com). It's free. If you already have a League of Legends account, just login with your LoL credentials to get your key.

The application has only two screens:

##Champions
A UICollectionViewController-based screen which shows a list of champions for the latest released version of League of Legends

![Champions Screen](documentation/championPage.gif)

##Champion Skins
A UICollectionViewController-based screen which shows a list of skins for the selected champion. If you switch between portrait and landscape orientations, the images show the loading skin image (portrait) and the splash screen skin image (landscape)

![Champion Skins Screen](documentation/championSkinScreenshot.jpg)

#Goals
* Build an iOS application using a best of breed tech stack (more on this below)
* Try out a compelling mobile application architecture (more on this below)
* Find a way to somehow use SceneKit
* Have fun!

All of my goals were met. Most of the code was written over a weekend. I plan on continuing to tinker with it, slowly adding more features, but mainly use it as a playground for a tech stack that I'm interested in.

#Tech Stack (in no particular order)
* [Typhoon](https://github.com/appsquickly/Typhoon) : A very nice dependency injection library for iOS (Objective-C and Swift)
* [FMDB](https://github.com/ccgus/fmdb) : A clean and simple Objective-C wrapper around SQLite
* [AFNetworking](https://github.com/AFNetworking/AFNetworking) : The defacto standard networking library for iOS
* [Bolts Framework](https://github.com/BoltsFramework/Bolts-iOS) : An implementation of [Futures and Promises](http://en.wikipedia.org/wiki/Futures_and_promises)
* [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack) : Logging (duh, what else do lumberjacks do?)
* [SceneKit](https://developer.apple.com/library/ios/documentation/SceneKit/Reference/SceneKit_Framework/) : To add a little ambient magic to the application

# Application Architecture
While the application architecture may not be all the novel, it is based upon some simple principles:

* Persist early and often, enabling offline use once all images are cached
* Stay off of the main thread so the application always remains responsive
* Code is unit testable (not yet unit tested, though)

The application is split into three "modules". There is a Typhoon assembly for each. Much of the core is an implementation of some concepts that should be familiar if you are an Android developer, namely [Services](http://developer.android.com/guide/components/services.html) and [Content Providers](http://developer.android.com/guide/topics/providers/content-providers.html). Additionally, I wrote a thin wrapper around the [FMDB FMResultSet class](http://ccgus.github.io/fmdb/html/Classes/FMResultSet.html) that allows for moving forward, backward or to any position within the result set.

I want to give a special shoutout to [Jasper Blues](https://github.com/jasperblues) who is the Project Lead for the [Typhoon Framework](https://github.com/appsquickly/Typhoon) and spent some of his valuable weekend time helping me with Typhoon.
