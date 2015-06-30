//
//  DRRevealViewController.m
//  Mebox Box UI Prototype
//
//  Created by David Runemalm on 2015-01-30.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import "DRRevealViewController.h"
#import "DRRevealFrontNavigationController.h"

@interface DRRevealViewController ()

//@property (strong, nonatomic) UIBarButtonItem *leftRevealButton;
@property (strong, nonatomic) UITapGestureRecognizer *frontViewTapGestureRecognizer;
@property (strong, nonatomic) UIPanGestureRecognizer *frontViewPanGestureRecognizer;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer *frontViewLeftScreenEdgePanGestureRecognizer;

@property (assign, nonatomic) float panOriginX;
@property (assign, nonatomic) CGPoint panVelocity;
@property (assign, nonatomic) DRRevealViewControllerDirection panDirection;

@end

@implementation DRRevealViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // ..
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self initProperties];
}

- (void)initProperties
{
    //UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@", @"DRRevealViewController", @"menu_icon.png"]];
    //self.leftRevealButton = [[UIBarButtonItem alloc] initWithImage:buttonImage
    //                                                         style:UIBarButtonItemStyleBordered
    //                                                        target:self
    //                                                        action:@selector(didTapRevealLeftButton:)];
    self.frontViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapFrontView:)];
    self.frontViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanFrontView:)];
    self.frontViewLeftScreenEdgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanFrontViewLeftEdge:)];
    self.frontViewLeftScreenEdgePanGestureRecognizer.edges = UIRectEdgeLeft;
    
    // Panning functionality
    self.isPanFrontViewEnabled = YES;
    self.isPanToRevealEnabled = YES;
    self.panToRevealLeftViewMode = DRRevealViewControllerPanToRevealLeftViewModeEdge;
    
    self.state = DRRevealViewControllerStateFrontVisible;
    self.revealDuration = 0.2;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (id)initWithLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController andFrontViewController:(UINavigationController<DRRevealFrontControllerDelegate> *)frontViewController
{
    self = [self init];
    if (self) {
        self.frontViewController = frontViewController;
        self.leftViewController = leftViewController;
    }
    return self;
}

- (id)initWithLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController andWrapNeedingFrontViewController:(UIViewController<DRRevealWrappedFrontControllerDelegate> *)frontViewController
{
    self = [self init];
    if (self) {
        [self wrapAndSetFrontViewController:frontViewController andRevealFrontView:NO];
        self.leftViewController = leftViewController;
    }
    return self;
}

- (void)setFrontViewController:(UINavigationController<DRRevealFrontControllerDelegate> *)frontViewController andRevealFrontView:(BOOL)revealFrontView
{
    // Set
    self.frontViewController = frontViewController;

    // Reveal?
    if (revealFrontView) {
        [self revealFrontView];
    }
}

- (void)wrapAndSetFrontViewController:(UIViewController<DRRevealWrappedFrontControllerDelegate> *)frontViewController andRevealFrontView:(BOOL)revealFrontView
{
    // Wrap
    DRRevealFrontNavigationController *wrappingFrontViewController = [DRRevealFrontNavigationController new];
    [wrappingFrontViewController wrapViewController:frontViewController];
    [frontViewController didGetWrappedByWrappingFrontViewController:wrappingFrontViewController];
    
    self.wrappedFrontViewController = frontViewController;
    frontViewController.revealViewController = self;

    // Set
    [self setFrontViewController:wrappingFrontViewController andRevealFrontView:revealFrontView];
}

#pragma mark - Buttons

- (void)didTapRevealLeftButton:(id)sender
{
    if (self.state == DRRevealViewControllerStateFrontVisible) {
        [self revealLeftView];
    } else {
        [self revealFrontView];
    }
}

#pragma mark - Gestures

- (void)updateGestures
{
    if (self.state == DRRevealViewControllerStateFrontVisible) {
        
        BOOL tapEnabled = NO;
        self.frontViewTapGestureRecognizer.enabled = tapEnabled;
        
        BOOL panEnabled = self.isPanFrontViewEnabled && self.isPanToRevealEnabled &&
                          self.isPanFrontViewToRevealLeftViewEnabled;
        self.frontViewPanGestureRecognizer.enabled = panEnabled;
        
        BOOL panLeftEdgeEnabled = self.isPanFrontViewEnabled && self.isPanToRevealEnabled &&
                                  self.isPanFrontViewLeftEdgeToRevealEnabled;
        self.frontViewLeftScreenEdgePanGestureRecognizer.enabled = panLeftEdgeEnabled;
        
    } else if (self.state == DRRevealViewControllerStateLeftVisible) {

        BOOL tapEnabled = YES;
        self.frontViewTapGestureRecognizer.enabled = tapEnabled;

        BOOL panEnabled = self.isPanFrontViewEnabled && self.isPanToRevealEnabled;
        self.frontViewPanGestureRecognizer.enabled = panEnabled;
        
    }
}

//- (void)didTapFrontAnimatingView:(UITapGestureRecognizer *)gesture
//{
//    if (self.state == DRRevealViewControllerStateLeftVisible) {
//        [self revealFrontView];
//    }
//}
//
//- (void)didPanFrontAnimatingView:(UIPanGestureRecognizer *)gesture
//{
//    [self didPanFrontView:gesture];
//}

- (void)didTapFrontView:(UIPanGestureRecognizer *)gesture
{
    if (self.state == DRRevealViewControllerStateLeftVisible) {
        [self revealFrontView];
    }
}

- (void)didPanFrontViewLeftEdge:(UIPanGestureRecognizer *)gesture
{
    [self didPan:gesture];
}

- (void)didPanFrontView:(UIPanGestureRecognizer *)gesture
{
    [self didPan:gesture];
}

- (void)didPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        // Velocity
        self.panVelocity = CGPointMake(0.0, 0.0);
        
        // Direction
        if([gesture velocityInView:self.view].x > 0) {
            self.panDirection = DRRevealViewControllerDirectionRight;
        } else {
            self.panDirection = DRRevealViewControllerDirectionLeft;
        }
        
        // Update state
        if (self.state == DRRevealViewControllerStateLeftVisible) {
            
            self.state = DRRevealViewControllerStateTransitioningLeftToFront;
            [self.leftViewController willConceal];
            
        } else if (self.state == DRRevealViewControllerStateFrontVisible && self.panDirection == DRRevealViewControllerDirectionRight) {
            
            if([self.wrappedFrontViewController canConcealToRight]){
                self.state = DRRevealViewControllerStateTransitioningFrontToLeft;
                [self.leftViewController willReveal];
                [self.frontViewController willConcealToRight];
            }else{
                self.state = DRRevealViewControllerStateCancelled;
            }
        }
        
        // Save starting point
        self.panOriginX = [gesture locationInView:self.view].x;
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        // Metrics
        CGPoint velocity = [gesture velocityInView:self.view];
        CGPoint location = [gesture locationInView:self.view];
        self.panVelocity = velocity;
        
        // Direction
        if(velocity.x > 0) {
            self.panDirection = DRRevealViewControllerDirectionRight;
        } else {
            self.panDirection = DRRevealViewControllerDirectionLeft;
        }
        
        // Distance
        float distance = location.x - self.panOriginX;
        
        // Reveal distance in percent
        float percent = [self.frontViewController revealPercentFromDistance:distance];
        
        // Reveal views
        if (self.state == DRRevealViewControllerStateTransitioningLeftToFront) {
            
            [self.leftViewController revealWithPercent:(1.0 - percent)];
            [self.frontViewController revealToLeftWithPercent:percent];
            
        } else if (self.state == DRRevealViewControllerStateTransitioningFrontToLeft) {
            
            [self.leftViewController revealWithPercent:percent];
            [self.frontViewController revealToLeftWithPercent:(1.0 - percent)];
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if(self.state != DRRevealViewControllerStateCancelled){
            if (self.panDirection == DRRevealViewControllerDirectionLeft) {
                [self revealFrontView];
            } else {
                [self revealLeftView];
            }
        }
    }
}

#pragma mark - Revealing

- (void)revealLeftView
{
    if (self.state == DRRevealViewControllerStateFrontVisible) {
        [self.leftViewController willReveal];
        [self.frontViewController willConcealToRight];
    }
    
    [UIView animateWithDuration:self.revealDuration animations:^{
        
        [self.leftViewController reveal];
        [self.frontViewController concealToRight];
        
    } completion:^(BOOL finished) {
        
        [self.leftViewController didReveal];
        [self.frontViewController didConcealToRight];
        
        // Bind tap recognizer so we know when to reveal front view again
//        [self.frontViewController.animatingView addGestureRecognizer:self.frontAnimatingViewTapGestureRecognizer];
//        [self.frontViewController.animatingView addGestureRecognizer:self.frontAnimatingViewPanGestureRecognizer];
        
        // Enable the tap gesture recognizer
        //self.frontViewTapGestureRecognizer.enabled = YES;
        
        // Update state
        self.state = DRRevealViewControllerStateLeftVisible;
        
        // Notify
        [self.delegate DRRevealViewController:self didRevealLeftViewController:self.leftViewController];
        [self.delegate DRRevealViewController:self didConcealFrontViewController:self.frontViewController];
        
        // Update gesture recognizers
        [self updateGestures];
        
    }];
    
    self.state = DRRevealViewControllerStateLeftVisible;
}

- (void)revealFrontView
{
    if (self.state == DRRevealViewControllerStateLeftVisible) {
        [self.leftViewController willConceal];
        [self.frontViewController willRevealToLeft];
    }
    
    [UIView animateWithDuration:self.revealDuration animations:^{
        
        [self.leftViewController conceal];
        [self.frontViewController revealToLeft];
        
    } completion:^(BOOL finished) {
        
        [self.leftViewController didConceal];
        [self.frontViewController didRevealToLeft];
        
        // Update state
        self.state = DRRevealViewControllerStateFrontVisible;
        
        // Notify
        [self.delegate DRRevealViewController:self didRevealFrontViewController:self.frontViewController];
        [self.delegate DRRevealViewController:self didConcealLeftViewController:self.leftViewController];
        
        // Update gesture recognizers
        [self updateGestures];
    }];
}

- (void)revealView:(DRRevealViewControllerView)view
{
    if (view == DRRevealViewControllerViewFront) {
        [self revealFrontView];
    } else {
        [self revealLeftView];
    }
}

#pragma mark - Properties

- (void)setIsPanFrontViewEnabled:(BOOL)isPanFrontViewEnabled
{
    _isPanFrontViewEnabled = isPanFrontViewEnabled;
    [self updateGestures];
}

- (void)setIsPanToRevealEnabled:(BOOL)isPanToRevealEnabled
{
    _isPanToRevealEnabled = isPanToRevealEnabled;
    [self updateGestures];
}

- (void)setIsPanFrontViewToRevealLeftViewEnabled:(BOOL)isPanFrontViewToRevealLeftViewEnabled
{
    _isPanFrontViewToRevealLeftViewEnabled = isPanFrontViewToRevealLeftViewEnabled;
    [self updateGestures];
}

- (void)setIsPanFrontViewLeftEdgeToRevealEnabled:(BOOL)isPanFrontViewLeftEdgeToRevealEnabled
{
    _isPanFrontViewLeftEdgeToRevealEnabled = isPanFrontViewLeftEdgeToRevealEnabled;
    [self updateGestures];
}

- (void)setPanToRevealLeftViewMode:(DRRevealViewControllerPanToRevealLeftViewMode)panToRevealLeftViewMode
{
    _panToRevealLeftViewMode = panToRevealLeftViewMode;
    switch (panToRevealLeftViewMode) {
        case DRRevealViewControllerPanToRevealLeftViewModeEdge:
            self.isPanFrontViewToRevealLeftViewEnabled = NO;
            self.isPanFrontViewLeftEdgeToRevealEnabled = YES;
            break;
        case DRRevealViewControllerPanToRevealLeftViewModeFull:
            self.isPanFrontViewToRevealLeftViewEnabled = YES;
            self.isPanFrontViewLeftEdgeToRevealEnabled = NO;
            break;
        default:
            break;
    }
}

- (void)setIsFrontViewControllerTapGestureRecognizerEnabled:(BOOL)isFrontViewControllerTapGestureRecognizerEnabled
{
    self.frontViewTapGestureRecognizer.enabled = isFrontViewControllerTapGestureRecognizerEnabled;
}

- (void)setIsFrontViewControllerPanGestureRecognizerEnabled:(BOOL)isFrontViewControllerPanGestureRecognizerEnabled
{
    self.frontViewPanGestureRecognizer.enabled = isFrontViewControllerPanGestureRecognizerEnabled;
}

- (void)setFrontViewController:(UINavigationController<DRRevealFrontControllerDelegate> *)frontViewController
{
    // Get reference to old controller
    UIViewController<DRRevealFrontControllerDelegate> *oldFrontViewController = _frontViewController;
    
    // Set new controller reference
    _frontViewController = frontViewController;

    // Init
    [self initFrontViewController];
    
    // Remove old view controller
    if (oldFrontViewController) {
        
        // Transfer state from old controller
        [_frontViewController didReplaceFrontViewController:oldFrontViewController];
    
        // Remove as child
        [self removeChildFrontViewController:oldFrontViewController];
    }
    
    [self.frontViewController didGetAddedByRevealViewController];
}

- (void)setLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController
{
    _leftViewController = leftViewController;
    [self initLeftViewController];
    
    [self.leftViewController didGetAddedByRevealViewController];
}

- (BOOL)isWrappingFrontViewController
{
    return self.wrappedFrontViewController != nil;
}

#pragma mark - Controller configuration

- (void)initFrontViewController
{
    // Set reference to reveal view controller
    self.frontViewController.revealViewController = self;
    
    // Add gesture recognizers
    [self.frontViewController.view addGestureRecognizer:self.frontViewTapGestureRecognizer];
    [self.frontViewController.view addGestureRecognizer:self.frontViewPanGestureRecognizer];
    [self.frontViewController.view addGestureRecognizer:self.frontViewLeftScreenEdgePanGestureRecognizer];
    
    // Add reveal buttons
    //self.frontViewController.visibleViewController.navigationItem.leftBarButtonItem = self.leftRevealButton;
    
    // Add as child view controller
    CGRect frame = self.view.frame;
    [self addChildFrontViewController:self.frontViewController withFrame:frame];
}

- (void)initLeftViewController
{
    // Set reference to reveal view controller
    self.leftViewController.revealViewController = self;
    
    // Add as child view controller
    CGRect frame = self.view.frame;
    [self addChildLeftViewController:self.leftViewController withFrame:frame];
}

#pragma mark - Child view controllers

- (void)removeChildFrontViewController:(UIViewController *)childFrontViewController
{
    [childFrontViewController willMoveToParentViewController:nil];
    [childFrontViewController.view removeFromSuperview];
    [childFrontViewController removeFromParentViewController];
}

- (void)addChildLeftViewController:(UIViewController<DRRevealChildControllerDelegate> *)leftViewController withFrame:(CGRect)frame
{
    [self addChildViewController:leftViewController];
    leftViewController.view.frame = frame;
    if ([self.childViewControllers containsObject:self.frontViewController]) {
        [self.view insertSubview:leftViewController.view belowSubview:self.frontViewController.view];
    } else {
        [self.view addSubview:leftViewController.view];
    }
    [leftViewController didMoveToParentViewController:self];
}

- (void)addChildFrontViewController:(UINavigationController<DRRevealFrontControllerDelegate> *)frontViewController withFrame:(CGRect)frame
{
    [self addChildViewController:frontViewController];
    frontViewController.view.frame = frame;
    if ([self.childViewControllers containsObject:self.leftViewController]) {
        [self.view insertSubview:frontViewController.view aboveSubview:self.leftViewController.view];
    } else {
        [self.view addSubview:frontViewController.view];
    }
    [frontViewController didMoveToParentViewController:self];
}

+ (UIView*)getViewSnapshot:(UIView*)v {
    // Updates:YES -> Glitch in ios8!!!
    // http://stackoverflow.com/questions/25873234/snapshotviewafterscreenupdates-glitch-on-ios-8
    //return [v snapshotViewAfterScreenUpdates:NO];
   
    //UIGraphicsBeginImageContextWithOptions(v.bounds.size, v.opaque, 0.0);
    UIGraphicsBeginImageContextWithOptions(v.bounds.size, NO, 0.0);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* iv = [[UIImageView alloc] initWithImage:img];
    return iv;
}
@end