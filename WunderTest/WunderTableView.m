//
//  WunderTableView.m
//  WunderTest
//
//  Created by Ali Raza on 06/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "WunderTableView.h"
#import "WunderCell.h"

@implementation WunderTableView{
    UIScrollView *_scrollView;
    NSMutableSet *_cellsToReuse;
    Class _cellsClass;
}



-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        _scrollView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        _cellsToReuse = [[NSMutableSet alloc]init];
        
    }
    return self;
}

-(void)layoutSubviews {
    _scrollView.frame = self.frame;
    [self refreshView];
}

-(void)refreshView {
    if (CGRectIsNull(_scrollView.frame)) {
        return;
    }
    // set the scrollview height
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width,
                                         [_dataSource numberOfRows] * SHC_ROW_HEIGHT);
    // remove cells that are no longer visible
    for (UIView* cell in [self cellSubviews]) {
        // is the cell off the top of the scrollview?
        if (cell.frame.origin.y + cell.frame.size.height < _scrollView.contentOffset.y) {
            [self recycleCell:cell];
        }
        // is the cell off the bottom of the scrollview?
        if (cell.frame.origin.y > _scrollView.contentOffset.y + _scrollView.frame.size.height) {
            [self recycleCell:cell];
        }
    }
    
    // ensure you have a cell for each row
    int firstVisibleIndex = MAX(0, floor(_scrollView.contentOffset.y / SHC_ROW_HEIGHT));
    int lastVisibleIndex = MIN([_dataSource numberOfRows],
                               firstVisibleIndex + 1 + ceil(_scrollView.frame.size.height / SHC_ROW_HEIGHT));
    for (int row = firstVisibleIndex; row < lastVisibleIndex; row++) {
        UIView* cell = [self cellForRow:row];
        if (!cell) {
            // create a new cell and add to the scrollview
            UIView* cell = [_dataSource cellForRow:row];
            float topEdgeForRow = row * SHC_ROW_HEIGHT;
            cell.frame = CGRectMake(0, topEdgeForRow, _scrollView.frame.size.width, SHC_ROW_HEIGHT);
            [_scrollView insertSubview:cell atIndex:0];
        }
    }
}

// recycles a cell by adding it the set of reuse cells and removing it from the view
-(void) recycleCell:(UIView*)cell {
    [_cellsToReuse addObject:cell];
    [cell removeFromSuperview];
}

// returns the cell for the given row, or nil if it doesn't exist
-(UIView*) cellForRow:(NSInteger)row {
    float topEdgeForRow = row * SHC_ROW_HEIGHT;
    for (UIView* cell in [self cellSubviews]) {
        if (cell.frame.origin.y == topEdgeForRow) {
            return cell;
        }
    }
    return nil;
}

// the scrollView subviews that are cells
-(NSArray*)cellSubviews {
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    for (UIView* subView in _scrollView.subviews) {
        if ([subView isKindOfClass:[WunderCell class]]) {
            [cells addObject:subView];
        }
    }
    return cells;
}

-(void)registerClassForCells:(Class)cellClass {
    _cellsClass = cellClass;
}

-(UIView*)dequeueReusableCell {
    // get cell from reuse pool
    UIView* cell = [_cellsToReuse anyObject];
    if (cell) {
        [_cellsToReuse removeObject:cell];
    }
    // if there is no cell in reuse pool allocate new one
    if (!cell) {
        cell = [[_cellsClass alloc] init];
    }
    return cell;
}



-(NSArray*) visibleCells {
    NSMutableArray* cells = [[NSMutableArray alloc] init];
    for (UIView* subView in [self cellSubviews]) {
        [cells addObject:subView];
    }
    NSArray* sortedCells = [cells sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UIView* view1 = (UIView*)obj1;
        UIView* view2 = (UIView*)obj2;
        float result = view2.frame.origin.y - view1.frame.origin.y;
        if (result > 0.0) {
            return NSOrderedAscending;
        } else if (result < 0.0){
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    return sortedCells;
}

-(void)reloadData {
    // remove all subviews
    [[self cellSubviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self refreshView];
}

#pragma mark - property setters
-(void)setDataSource:(id<WunderTableViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self refreshView];
}

-(UIScrollView *)scrollView{
    return _scrollView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UIScrollViewDelegate handlers
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self refreshView];
    if([self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:scrollView];
    }
}



#pragma mark - UIScrollViewDelegate forwarding
-(BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}


-(id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end
