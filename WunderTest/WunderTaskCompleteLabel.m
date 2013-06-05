//
//  WunderTaskCompleteLabel.m
//  WunderTest
//
//  Created by Ali Raza on 05/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "WunderTaskCompleteLabel.h"

@implementation WunderTaskCompleteLabel{
    bool _markComplete;
    CALayer* _markCompleteLayer;
}

const float STRIKE_WIDTH = 2.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _markCompleteLayer = [CALayer layer];
        _markCompleteLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        _markCompleteLayer.hidden = YES;
        [self.layer addSublayer:_markCompleteLayer];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self resizeMarkComplete];
}

-(void)resizeMarkComplete {
    CGSize textSize = [self.text sizeWithFont:self.font];
    _markCompleteLayer.frame = CGRectMake(0, self.bounds.size.height/2, textSize.width, STRIKE_WIDTH);
}

#pragma mark - property setter
-(void)setMarkComplete:(bool)markComplete{
    _markComplete = markComplete;
    _markCompleteLayer.hidden = !markComplete;
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
