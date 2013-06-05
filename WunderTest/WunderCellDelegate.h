//
//  WunerCellDelegate.h
//  WunderTest
//
//  Created by Ali Raza on 05/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoVM.h"


@protocol WunderCellDelegate <NSObject>

-(void)wunderItemDeleted:(TodoVM *)todo;

@end
