//
//  DRRevealViewController.h
//  Mebox Box UI Prototype
//
//  Created by David Runemalm on 2015-01-30.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DRRevealViewControllerStateFrontVisible,
    DRRevealViewControllerStateLeftVisible,
    DRRevealViewControllerStateTransitioningLeftToFront,
    DRRevealViewControllerStateTransitioningFrontToLeft
} DRRevealViewControllerState;

typedef enum {
    DRRevealViewControllerViewLeft,
    DRRevealViewControllerViewFront
} DRRevealViewControllerView;

typedef enum {
    DRRevealViewControllerDirectionLeft,
    DRRevealViewControllerDirectionRight
} DRRevealViewControllerDirection;

typedef enum {
    DRRevealViewControllerPanToRevealLeftViewModeFull,
    DRRevealViewControllerPanToRevealLeftViewModeEdge
} DRRevealViewControllerPanToRevealLeftViewMode;

#pragma mark - Forward declarations

@class DRRevealViewController;
@protocol DRRevealWrappingFrontControllerDelegate;

#pragma mark - Protocols

@protocol DRRevealWrappedFrontControllerDelegate <NSObject>

@property (strong, nonatomic) DRRevealViewController *revealViewController;

- (void)didGetWrappedByWrappingFrontViewController:(UINavigationController<DRRevealWrappingFrontControllerDelegate> *)wrappingFrontViewController;

@end

@protocol DRRevealChildControllerDelegate <NSObject>

@property (strong, nonatomic) DRRevealViewController *revealViewController;

- (void)didGetAddedByRevealViewController;

@end

@protocol DRRevealSideControllerDelegate <DRRevealChildControllerDelegate>

- (void)willReveal;
- (void)reveal;
- (void)didReveal;

- (void)revealWithPercent:(float)percent;

- (void)willConceal;
- (void)conceal;
- (void)didConceal;

@end

@protocol DRRevealFrontControllerDelegate <DRRevealChildControllerDelegate>

@property (strong, nonatomic) UIView *animatingView;
@property (assign, nonatomic) float concealRightXoffset;
@property (assign, nonatomic) float concealRightYoffset;

- (void)willRevealToLeft;
- (void)revealToLeft;
- (void)didRevealToLeft;

- (void)revealToLeftWithPercent:(float)percent;
- (float)revealPercentFromDistance:(float)distance;

- (void)willConcealToRight;
- (void)concealToRight;
- (void)didConcealToRight;

- (void)didReplaceFrontViewController:(UIViewController<DRRevealFrontControllerDelegate> *)replacedFrontViewController;

@end

@protocol DRRevealWrappingFrontControllerDelegate <DRRevealFrontControllerDelegate>

- (void)wrapViewController:(UIViewController<DRRevealWrappedFrontControllerDelegate> *)viewController;

@end

@protocol DRRevealViewControllerDelegate <NSObject>

- (void)DRRevealViewController:(DRRevealViewController *)revealViewController didRevealLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController;
- (void)DRRevealViewController:(DRRevealViewController *)revealViewController didConcealLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController;
- (void)DRRevealViewController:(DRRevealViewController *)revealViewController didRevealFrontViewController:(UIViewController<DRRevealFrontControllerDelegate> *)frontViewController;
- (void)DRRevealViewController:(DRRevealViewController *)revealViewController didConcealFrontViewController:(UIViewController<DRRevealFrontControllerDelegate> *)frontViewController;

@end

#pragma mark - Class

@interface DRRevealViewController : UIViewController <UIGestureRecognizerDelegate>

@property (assign, nonatomic) id <DRRevealViewControllerDelegate> delegate;
@property (assign, nonatomic) DRRevealViewControllerState state;
@property (assign, nonatomic) float revealDuration;
@property (strong, nonatomic) UIViewController<DRRevealSideControllerDelegate> *leftViewController;
@property (strong, nonatomic) UINavigationController<DRRevealFrontControllerDelegate> *frontViewController;
@property (strong, nonatomic) UIViewController<DRRevealWrappedFrontControllerDelegate> *wrappedFrontViewController;
@property (readonly, nonatomic) BOOL isWrappingFrontViewController;

@property (assign, nonatomic) BOOL isPanToRevealEnabled;
@property (assign, nonatomic) BOOL isPanFrontViewEnabled;
@property (assign, nonatomic) BOOL isPanFrontViewToRevealLeftViewEnabled;
@property (assign, nonatomic) BOOL isPanFrontViewLeftEdgeToRevealEnabled;
@property (assign, nonatomic) BOOL isTapFrontViewToConcealEnabled;
@property (assign, nonatomic) BOOL isTapFrontViewToConcealLeftViewEnabled;

@property (assign, nonatomic) DRRevealViewControllerPanToRevealLeftViewMode panToRevealLeftViewMode;

- (id)initWithLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController andFrontViewController:(UINavigationController<DRRevealFrontControllerDelegate> *)frontViewController;
- (id)initWithLeftViewController:(UIViewController<DRRevealSideControllerDelegate> *)leftViewController andWrapNeedingFrontViewController:(UIViewController<DRRevealWrappedFrontControllerDelegate> *)frontViewController;
- (void)setFrontViewController:(UINavigationController<DRRevealFrontControllerDelegate> *)frontViewController andRevealFrontView:(BOOL)revealFrontView;
- (void)wrapAndSetFrontViewController:(UIViewController<DRRevealWrappedFrontControllerDelegate> *)frontViewController andRevealFrontView:(BOOL)revealFrontView;

- (void)revealView:(DRRevealViewControllerView)view;
- (void)revealLeftView;
- (void)revealFrontView;

+ (UIView*)getViewSnapshot:(UIView*)v;
@end
