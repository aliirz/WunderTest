//
//  WunderTableViewDataSource.h
//  WunderTest
//
//  Created by Ali Raza on 06/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WunderTableViewDataSource <NSObject>


-(NSInteger)numberOfRows;
-(UIView *)cellForRow:(NSInteger)row;
-(void)todoAdded;
@end
