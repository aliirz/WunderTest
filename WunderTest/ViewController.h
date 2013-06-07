//
//  ViewController.h
//  WunderTest
//
//  Created by Ali Raza on 03/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WunderTableView.h"
#import "WunderTableViewNew.h"
#import "WunderCellDelegate.h"

@interface ViewController : UIViewController <WunderTableViewDataSource, WunderCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *todoTableView_iPad;

@property (weak, nonatomic) IBOutlet WunderTableView *todoTableView_iPhone;

@end
