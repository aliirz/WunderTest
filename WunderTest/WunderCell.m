//
//  WunderCell.m
//  WunderTest
//
//  Created by Ali Raza on 04/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "WunderCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+FlatUI.h"


@implementation WunderCell{
    CAGradientLayer* _gradientLayer;
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
//        _gradientLayer.colors = @[[UIColor carrotColor],[UIColor pumpkinColor]];
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
CGPoint translatoryPnt = [gestureRecognizer translationInView:[self superview]];
    if(fabsf(translatoryPnt.x) > fabsf(translatoryPnt.y)){
        return YES;
    }
    return  NO;
}

@end
