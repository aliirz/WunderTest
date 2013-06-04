//
//  TodoVM.m
//  WunderTest
//
//  Created by Ali Raza on 04/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "TodoVM.h"

@implementation TodoVM


-(id)initWithTitle:(NSString *) title{
    if(self = [super init]){
        self.title = title;
    }
    return  self;
}
+(id)getTodoWithTitle:(NSString *) title{
    return [[TodoVM alloc]initWithTitle:title];
}

@end
