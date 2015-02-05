# DRRevealViewController

[![CI Status](http://img.shields.io/travis/David Runemalm/DRRevealViewController.svg?style=flat)](https://travis-ci.org/David Runemalm/DRRevealViewController)
[![Version](https://img.shields.io/cocoapods/v/DRRevealViewController.svg?style=flat)](http://cocoadocs.org/docsets/DRRevealViewController)
[![License](https://img.shields.io/cocoapods/l/DRRevealViewController.svg?style=flat)](http://cocoadocs.org/docsets/DRRevealViewController)
[![Platform](https://img.shields.io/cocoapods/p/DRRevealViewController.svg?style=flat)](http://cocoadocs.org/docsets/DRRevealViewController)

## Demo

![alt tag](https://raw.githubusercontent.com/runemalm/DRRevealViewController/develop/Example/demo.gif)

## Description

Use the DRRevealViewController when you want a way of revealing view controllers that exists behind a front view controller.
Typical use case includes a "sliding menu" like in the Eurosport iPhone app (see demo above).

* Implement menu similar to Facebook's or Eurosport's iPhone apps.
* Easily customize the reveal animations by implementing delegate 'revealWithPercent' method.

## Version

Version 0.0.1

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Below is a quick example how your instantiation might look like:

```objc      
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    DRFrontViewController<DRRevealWrappedFrontControllerDelegate> *frontViewController = [storyBoard instantiateViewControllerWithIdentifier:@"FrontView"];
    DRMenuViewController<DRRevealSideControllerDelegate> *menuViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MenuView"];

    DRRevealViewController *revealViewController = [[DRRevealViewController alloc] initWithLeftViewController:menuViewController
                                                        andWrapNeedingFrontViewController:frontViewController];

    self.window.rootViewController = revealViewController;
    [self.window makeKeyAndVisible];

    return YES;
}
```

## Requirements

## Installation

DRRevealViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "DRRevealViewController"

## Author

David Runemalm, david.runemalm@gmail.com

## License

DRRevealViewController is available under the MIT license. See the LICENSE file for more info.

