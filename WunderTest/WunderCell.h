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


@interface WunderCell : UITableViewCell

@property (nonatomic) TodoVM *todo;
@property (nonatomic, assign) id<WunderCellDelegate> delegate;

@end
