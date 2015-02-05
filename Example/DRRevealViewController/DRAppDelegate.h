//
//  DRAppDelegate.h
//  DRRevealViewController
//
//  Created by CocoaPods on 02/03/2015.
//  Copyright (c) 2014 David Runemalm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DRRevealViewController/DRRevealViewController.h>
#import "DRMenuViewController.h"
#import "DRFrontViewController.h"

@interface DRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DRFrontViewController<DRRevealWrappedFrontControllerDelegate> *firstViewController;
@property (strong, nonatomic) DRFrontViewController<DRRevealWrappedFrontControllerDelegate> *secondViewController;
@property (strong, nonatomic) DRMenuViewController<DRRevealSideControllerDelegate> *menuViewController;

@end
