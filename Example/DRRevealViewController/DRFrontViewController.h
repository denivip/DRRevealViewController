//
//  DRFrontViewController.h
//  DRRevealViewController
//
//  Created by David Runemalm on 2015-02-03.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRRevealViewController.h"

@interface DRFrontViewController : UIViewController <DRRevealWrappedFrontControllerDelegate>

@property (strong, nonatomic) DRRevealViewController *revealViewController;

@end
