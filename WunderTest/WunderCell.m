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
#import "WunderTaskCompleteLabel.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Todo.h"


@implementation WunderCell{
    CAGradientLayer* _gradientLayer;
    CGPoint _originalCenter;
    BOOL _deleteOnDragRelease;
    WunderTaskCompleteLabel *_completeLabel;
    CALayer *_taskCompleteLayer;
    
    BOOL _markCompleteOnDragRelease;
    UILabel *_tickLabel;
	UILabel *_deleteLabel;
}

@synthesize managedObjectContext;

const float UI_CUES_MARGIN = 10.0f;
const float UI_CUES_WIDTH = 50.0f;
const float LABEL_MARGIN_LFT = 15.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        managedObjectContext = appDelegate.managedObjectContext;
        _tickLabel = [self createCueLabel];
        _tickLabel.text = @"\u2713";
        _tickLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_tickLabel];
        _deleteLabel = [self createCueLabel];
        _deleteLabel.text = @"\u2717";
        _deleteLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_deleteLabel];
        
        
        _completeLabel = [[WunderTaskCompleteLabel alloc]initWithFrame:CGRectNull];
        _completeLabel.delegate = self;
        _completeLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _completeLabel.textColor = [UIColor whiteColor];
        _completeLabel.font = [UIFont boldSystemFontOfSize:16];
        _completeLabel.backgroundColor  = [UIColor clearColor];
        [self addSubview:_completeLabel];
        //lets remove the default blue selected color
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
//        _gradientLayer.colors = @[[UIColor carrotColor],[UIColor pumpkinColor]];
        _gradientLayer.colors = @[(id)[[UIColor colorWithWhite:1.0f alpha:0.2f] CGColor],
                                  (id)[[UIColor colorWithWhite:1.0f alpha:0.1f] CGColor],
                                  (id)[[UIColor clearColor] CGColor],
                                  (id)[[UIColor colorWithWhite:0.0f alpha:0.1f] CGColor]];
        _gradientLayer.locations = @[@0.00f, @0.01f, @0.95f, @1.00f];
        [self.layer insertSublayer:_gradientLayer atIndex:0];
        
        _taskCompleteLayer = [CALayer layer];
        _taskCompleteLayer.backgroundColor =  [[UIColor alizarinColor]CGColor]; //[[[UIColor alloc] initWithRed:0.0 green:0.6 blue:0.0 alpha:1.0] CGColor];
        _taskCompleteLayer.hidden = YES;
        [self.layer insertSublayer:_taskCompleteLayer atIndex:0];
        
        
        UIGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
    
    _taskCompleteLayer.frame = self.bounds;
    _completeLabel.frame = CGRectMake(LABEL_MARGIN_LFT, 0, self.bounds.size.width - LABEL_MARGIN_LFT, self.bounds.size.height);
    
    _tickLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0,
                                  UI_CUES_WIDTH, self.bounds.size.height);
    _deleteLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0,
                                   UI_CUES_WIDTH, self.bounds.size.height);

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

-(void)handleGesture:(UIPanGestureRecognizer *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateBegan){
        _originalCenter = self.center;
    }
    
    if(recognizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        _markCompleteOnDragRelease = self.frame.origin.x > self.frame.size.width /2;
        _deleteOnDragRelease = self.frame.origin.x < -self.frame.size.width /2;
        // fade the contextual cues
        float cueAlpha = fabsf(self.frame.origin.x) / (self.frame.size.width / 2);
        _tickLabel.alpha = cueAlpha;
        _deleteLabel.alpha = cueAlpha;
        
        // indicate when the item have been pulled far enough to invoke the given action
        _tickLabel.textColor = _markCompleteOnDragRelease ?
        [UIColor greenColor] : [UIColor whiteColor];
        _deleteLabel.textColor = _deleteOnDragRelease ?
        [UIColor redColor] : [UIColor whiteColor];
    
    
    }
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if(!_deleteOnDragRelease){
            [UIView animateWithDuration:0.2 animations:^{self.frame = originalFrame;}];
        }
        if(_deleteOnDragRelease){
            [self.delegate wunderItemDeleted:self.todo];
            
        }
        if(_markCompleteOnDragRelease){
            if(self.todo.completed != YES)
            {
                self.todo.completed = YES;
                _taskCompleteLayer.hidden  = NO;
                _completeLabel.markComplete = YES;
                //lets update coredata model as well
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@",self.todo.title]];
                [fetchRequest setEntity:entity];
                NSError *error;
                NSArray *objs = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
                for(Todo *t in objs)
                {
                    t.completed = [NSNumber numberWithBool:YES];
                    
                }
                [managedObjectContext save:&error];

            }
            else
            {
                self.todo.completed = NO;
                _taskCompleteLayer.hidden = YES;
                _completeLabel.markComplete = NO;
                //lets update coredata model as well
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@",self.todo.title]];
                [fetchRequest setEntity:entity];
                NSError *error;
                NSArray *objs = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
                for(Todo *t in objs)
                {
                    t.completed = [NSNumber numberWithBool:NO];
                    
                }
                [managedObjectContext save:&error];
            }
            
        }
    }

}

-(void)setTodo:(TodoVM *)todo{
    _todo = todo;
    _completeLabel.text = todo.title;
    _completeLabel.markComplete = todo.completed;
    _taskCompleteLayer.hidden = !todo.completed;
    //Lets update this todo in CoreData Model as well.
    
    
}

-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:32.0];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    // close the keyboard on enter
    [textField resignFirstResponder];
    return NO;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.delegate cellDidBeginEditing:self];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    // set the model object state when an edit has complete
    [self.delegate cellDidEndEditing:self];
    //after editing is complete lets save the result to database as well.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@",self.todo.title]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *objs = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for(Todo *t in objs)
    {
        t.title = textField.text;
        
    }
    [managedObjectContext save:&error];
    self.todo.title = textField.text;
    
    
}

@end
