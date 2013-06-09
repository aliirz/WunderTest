//
//  TodoVM.m
//  WunderTest
//
//  Created by Ali Raza on 04/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "TodoVM.h"

@implementation TodoVM


-(id)initWithTitle:(NSString *) title andCompleted:(BOOL)completed{
    if(self = [super init]){
        self.title = title;
        self.completed = completed;
    }
    return  self;
}
+(id)getTodoWithTitle:(NSString *) title andCompleted:(BOOL)completed{
    return [[TodoVM alloc]initWithTitle:title andCompleted:completed];
}

@end
