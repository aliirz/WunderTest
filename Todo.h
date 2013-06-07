//
//  Todo.h
//  WunderTest
//
//  Created by Ali Raza on 08/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Todo : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * title;

@end
