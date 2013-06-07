//
//  WunderTableView.h
//  WunderTest
//
//  Created by Ali Raza on 06/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WunderTableViewDataSource.h"
#define SHC_ROW_HEIGHT  50.0f

@interface WunderTableView : UIView<UIScrollViewDelegate>
@property (nonatomic, assign) id<WunderTableViewDataSource> dataSource;
@property (nonatomic, assign) id<UIScrollViewDelegate> delegate;
@property (nonatomic, assign, readonly) UIScrollView* scrollView;
// dequeues a cell that can be reused
-(UIView*)dequeueReusableCell;

// registers a class for use as new cells
-(void)registerClassForCells:(Class)cellClass;

//an array that shows visible cells
-(NSArray *)visibleCells;

-(void)reloadData;


@end
