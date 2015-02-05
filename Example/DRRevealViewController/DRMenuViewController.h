//
//  DRMenuViewController.h
//  DRRevealViewController
//
//  Created by David Runemalm on 2015-02-03.
//  Copyright (c) 2015 David Runemalm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRRevealViewController.h"

@interface DRMenuViewController : UIViewController <DRRevealSideControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) DRRevealViewController *revealViewController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end
