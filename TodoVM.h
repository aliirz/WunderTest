//
//  TodoVM.h
//  WunderTest
//
//  Created by Ali Raza on 04/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TodoVM : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic) BOOL completed;


-(id)initWithTitle:(NSString *) title andCompleted:(BOOL)completed;
+(id)getTodoWithTitle:(NSString *) title andCompleted:(BOOL)completed;

@end
