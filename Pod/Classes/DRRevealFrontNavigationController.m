//
//  DRRevealFrontNavigationController.m
//  Mebox Box UI Prototype
//
//  Created by David Runemalm on 2015-01-31.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import "DRRevealFrontNavigationController.h"

@interface DRRevealFrontNavigationController ()

@end

@implementation DRRevealFrontNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initProperties];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initProperties
{
    self.concealRightXoffset = 85;
    self.concealRightYoffset = 100;
}

#pragma mark - DRRevealChildControllerDelegate

- (void)didGetAddedByRevealViewController
{
}

#pragma mark - DRRevealWrappingFrontControllerDelegate

- (void)wrapViewController:(UIViewController<DRRevealWrappedFrontControllerDelegate> *)viewController
{
    [self setViewControllers:@[viewController]];
}

#pragma mark - DRRevealFrontControllerDelegate

- (void)willConcealToRight
{
    // Prepare snapshot
    self.animatingView = [self getSnapshotView];
    self.animatingView.frame = self.view.frame;
    
    // Hide view
    for (UIView *s in self.view.subviews) {
        s.hidden = YES;
    }
    [self.view addSubview:self.animatingView];
}

- (void)concealToRight
{
    [self revealToLeftWithPercent:0.0];
}

- (void)didConcealToRight
{

}

- (void)willRevealToLeft
{
    
}

- (void)revealToLeft
{
    // Move snapshot
    [self revealToLeftWithPercent:1.0];
}

- (void)revealToLeftWithPercent:(float)percent
{
    CGRect frame = [self frameForAnimatingViewAtRevealedPercent:percent];

    CGRect animationFrame = frame;
    animationFrame.origin.x = 0;
    
    frame.origin.y = 0;
    frame.size.height = UIScreen.mainScreen.bounds.size.height;
    frame.size.width = UIScreen.mainScreen.bounds.size.width;
    self.view.frame = frame;
    
    self.animatingView.frame = animationFrame;
}

- (void)didRevealToLeft
{
    for (UIView *s in self.view.subviews) {
        s.hidden = NO;
    }
    [self.animatingView removeFromSuperview];
    self.animatingView = nil;
}

- (void)didReplaceFrontViewController:(UIViewController<DRRevealFrontControllerDelegate> *)replacedFrontViewController
{
    if (self.revealViewController.state == DRRevealViewControllerStateLeftVisible) {
        [self transferStateFromViewController:replacedFrontViewController forState:DRRevealViewControllerStateLeftVisible];
    }
}

- (void)transferStateFromViewController:(UIViewController<DRRevealFrontControllerDelegate> *)fromViewController forState:(DRRevealViewControllerState)state
{
    if (state == DRRevealViewControllerStateLeftVisible) {
        // Take over animating view
        if (fromViewController.animatingView) {
            [self.view addSubview:fromViewController.animatingView];
            self.animatingView = fromViewController.animatingView;
            
            // Update the snapshot
            [self updateAnimatingView];
        }
        
        // Copy frame
        self.view.frame = fromViewController.view.frame;
        for (UIView *subView in self.view.subviews) {
            subView.hidden = YES;
        }
        self.animatingView.hidden = NO;
    }
}

#pragma mark - Reveal frames

- (CGRect)endFrameForRightConceal
{
    CGRect frame = [UIScreen mainScreen].bounds;
    float aspect = frame.size.width / frame.size.height;
    float x = frame.size.width - self.concealRightXoffset;
    float y = self.concealRightYoffset;
    float h = frame.size.height - (y * 2);
    float w = h * aspect;
    frame = CGRectMake(x, y, w, h);
    return frame;
}

- (CGRect)frameForAnimatingViewAtRevealedPercent:(float)percent
{
    CGRect frame = [self endFrameForRightConceal];
    
    float dX = frame.origin.x;
    float dY = frame.origin.y;
    float dW = frame.size.width - UIScreen.mainScreen.bounds.size.width;
    float dH = frame.size.height - UIScreen.mainScreen.bounds.size.height;
    
    float x = 0 + (1.0 - percent) * dX;
    float y = 0 + (1.0 - percent) * dY;
    float w = UIScreen.mainScreen.bounds.size.width + (1.0 - percent) * dW;
    float h = UIScreen.mainScreen.bounds.size.height + (1.0 - percent) * dH;
    frame = CGRectMake(x, y, w, h);
    return frame;
}

- (void)updateAnimatingView
{
    // Old
    CGRect oldFrame = self.animatingView.frame;
    [self.animatingView removeFromSuperview];
    
    // New
    self.animatingView = [self getSnapshotView];
    self.animatingView.frame = oldFrame;
    [self.view addSubview:self.animatingView];
}

#pragma mark - Utilities

- (UIView *)getSnapshotView
{
    UIView *snapshotView = [self.view snapshotViewAfterScreenUpdates:YES];
    return snapshotView;
}

- (float)revealPercentFromDistance:(float)distance
{
    CGRect frame = [self endFrameForRightConceal];
    float percent = fabsf(distance / frame.origin.x);
    if ((1.0 - percent) < 0.01 && (1.0 - percent) > -0.01) {
        percent = 1.0;
    }
    return percent;
}

@end
