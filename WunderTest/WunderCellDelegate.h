//
//  WunerCellDelegate.h
//  WunderTest
//
//  Created by Ali Raza on 05/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoVM.h"
@class WunderCell;


@protocol WunderCellDelegate <NSObject>

-(void)wunderItemDeleted:(TodoVM *)todo;
// Indicates that the edit process has begun for the given cell
-(void)cellDidBeginEditing:(WunderCell*)cell;

// Indicates that the edit process has committed for the given cell
-(void)cellDidEndEditing:(WunderCell*)cell;

@end
