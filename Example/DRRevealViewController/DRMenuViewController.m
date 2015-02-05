//
//  DRMenuViewController.m
//  DRRevealViewController
//
//  Created by David Runemalm on 2015-02-03.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import "DRMenuViewController.h"
#import "DRAppDelegate.h"

@interface DRMenuViewController ()

@property (strong, nonatomic) UIView *animatingView;
@property (assign, nonatomic) float concealedAlphaValue;
@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation DRMenuViewController

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
    self.view.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"menu_bg"];
    self.tableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.concealedAlphaValue = 0.3;
    self.menuItems = @[@[@{@"view": @(DRAppViewFirst), @"title": @"First View"},
                         @{@"view": @(DRAppViewSecond), @"title": @"Second View"}
                         ]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuItems[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell
    static NSString *kCellIdentifier = @"MenuCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    // Get menu item
    NSDictionary *menuItem = self.menuItems[indexPath.section][indexPath.row];
    
    // Configure
    NSString *title = [menuItem valueForKey:@"title"];
    cell.textLabel.text = title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get menu item
    NSDictionary *menuItem = self.menuItems[indexPath.section][indexPath.row];
    DRAppDelegate *appDelegate = (DRAppDelegate *)[UIApplication sharedApplication].delegate;
    
    DRAppView appView = (DRAppView)[[menuItem valueForKey:@"view"] intValue];
    UIViewController<DRRevealWrappedFrontControllerDelegate> *frontViewController;
    switch (appView) {
        case DRAppViewFirst:
            frontViewController = appDelegate.firstViewController;
            break;
        case DRAppViewSecond:
            frontViewController = appDelegate.secondViewController;
            break;
        default:
            break;
    }
    
    BOOL shouldReplace = NO;
    if (self.revealViewController.wrappedFrontViewController != frontViewController) {
        shouldReplace = YES;
    }
    
    if (shouldReplace) {
        [self.revealViewController wrapAndSetFrontViewController:frontViewController andRevealFrontView:YES];
    } else {
        [self.revealViewController revealFrontView];
    }
}

- (BOOL)revealViewControllerHasFrontViewController:(UIViewController *)viewController
{
    // NOTE: Front view controller may have been wrapped by a navigation controller
    if ([self.revealViewController.frontViewController isKindOfClass:[UINavigationController class]]) {
        return [self.revealViewController.frontViewController.childViewControllers containsObject:viewController];
    }
    return self.revealViewController.frontViewController == viewController;
}

#pragma mark - DRRevealChildControllerDelegate

- (void)didGetAddedByRevealViewController
{
    
}

#pragma mark - DRRevealSideControllerDelegate

- (void)willReveal
{
    // Create snapshot
    self.backgroundImageView.hidden = YES;
    self.animatingView = [self getSnapshotView];
    self.backgroundImageView.hidden = NO;
    self.animatingView.alpha = self.concealedAlphaValue;
    
    // Place snapshot
    self.tableView.hidden = YES;
    self.animatingView.frame = [self endFrameForConceal];
    [self.view addSubview:self.animatingView];
}

- (void)revealWithPercent:(float)percent
{
    CGRect frame = [self frameForAnimatingViewAtRevealedPercent:percent];
    self.animatingView.frame = frame;
    float delta = 1.0 - self.concealedAlphaValue;
    self.animatingView.alpha = self.concealedAlphaValue + delta * percent;
}

- (void)reveal
{
    // Move snapshot
    [self revealWithPercent:1.0];
}

- (void)didReveal
{
    // Remove snapshot
    self.tableView.hidden = NO;
    [self.animatingView removeFromSuperview];
    self.animatingView = nil;
}

- (void)willConceal
{
    // Prepare snapshot
    self.backgroundImageView.hidden = YES;
    self.animatingView = [self getSnapshotView];
    self.backgroundImageView.hidden = NO;
    self.animatingView.frame = self.view.frame;
    [self.view addSubview:self.animatingView];
    self.tableView.hidden = YES;
}

- (void)conceal
{
    // Move snapshot
    self.animatingView.frame = [self endFrameForConceal];
    self.animatingView.alpha = 0.3;
}

- (void)didConceal
{
    // Remove snapshot
    self.tableView.hidden = NO;
    [self.animatingView removeFromSuperview];
    self.animatingView = nil;
}

#pragma mark - Reveal frames

- (CGRect)endFrameForConceal
{
    float aspect = self.view.frame.size.width / self.view.frame.size.height;
    float x = 30;
    float y = x / aspect;
    CGRect frame = self.view.frame;
    frame = CGRectInset(frame, x, y);
    return frame;
}

- (CGRect)frameForAnimatingViewAtRevealedPercent:(float)percent
{
    CGRect frame = [self endFrameForConceal];
    
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

#pragma mark - Utilities

- (UIView *)getSnapshotView
{
    UIView *snapshotView = [self.view snapshotViewAfterScreenUpdates:YES];
    return snapshotView;
}

@end
