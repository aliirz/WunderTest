//
//  WunderTableViewNew.m
//  WunderTest
//
//  Created by Ali Raza on 06/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "WunderTableViewNew.h"
#import "WunderCell.h"
#import "UIColor+FlatUI.h"

@implementation WunderTableViewNew{
    WunderCell *_placeHolder;
    BOOL _pullDownInProgress;
    WunderTableView *_tableView;
}

-(id)initWithTableView:(WunderTableView *)tableView{
    self = [super init];
    if(self){
        _placeHolder = [[WunderCell alloc]init];
        _placeHolder.backgroundColor = [UIColor pomegranateColor];
        _tableView = tableView;
        _tableView.delegate = self;
    }
    return self;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pullDownInProgress = scrollView.contentOffset.y <= 0.0f;
    if (_pullDownInProgress) {
        [_tableView insertSubview:_placeHolder atIndex:0];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //[_tableView scrollViewDidScroll:scrollView];
    if(_pullDownInProgress && _tableView.scrollView.contentOffset.y <= 0.0f){
        _placeHolder.frame = CGRectMake(0, -_tableView.scrollView.contentOffset.y - SHC_ROW_HEIGHT, _tableView.frame.size.width,SHC_ROW_HEIGHT);
        _placeHolder.alpha = MIN(1.0f, -_tableView.scrollView.contentOffset.y/SHC_ROW_HEIGHT);
    }
    else{
        _pullDownInProgress = false;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(_pullDownInProgress && -_tableView.scrollView.contentOffset.y > SHC_ROW_HEIGHT){
        [_tableView.dataSource todoAdded];
    }
    _pullDownInProgress = false;
    [_placeHolder removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
