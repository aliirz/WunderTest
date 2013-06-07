//
//  WunderCell.h
//  WunderTest
//
//  Created by Ali Raza on 04/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TodoVM.h"
#import "WunderCellDelegate.h"
#import "WunderTaskCompleteLabel.h"


@interface WunderCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic) TodoVM *todo;
@property (nonatomic, assign) id<WunderCellDelegate> delegate;
@property (nonatomic, strong, readonly) WunderTaskCompleteLabel *label;

@end
