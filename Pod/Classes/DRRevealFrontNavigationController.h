//
//  MBRevealFrontNavigationController.h
//  Mebox Box UI Prototype
//
//  Created by David Runemalm on 2015-01-31.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRRevealViewController.h"

@interface DRRevealFrontNavigationController : UINavigationController <DRRevealWrappingFrontControllerDelegate>

@property (strong, nonatomic) DRRevealViewController *revealViewController;
@property (strong, nonatomic) UIView *animatingView;
@property (assign, nonatomic) float concealRightXoffset;
@property (assign, nonatomic) float concealRightYoffset;

@end
