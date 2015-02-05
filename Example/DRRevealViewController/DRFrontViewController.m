//
//  DRFrontViewController.m
//  DRRevealViewController
//
//  Created by David Runemalm on 2015-02-03.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import "DRFrontViewController.h"

@interface DRFrontViewController ()

@end

@implementation DRFrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DRRevealWrappedFrontControllerDelegate

- (void)didGetWrappedByWrappingFrontViewController:(UINavigationController<DRRevealWrappingFrontControllerDelegate> *)wrappingFrontViewController
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
