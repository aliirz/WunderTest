//
//  ViewController.m
//  WunderTest
//
//  Created by Ali Raza on 03/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "ViewController.h"
#import "TodoVM.h"
#import "UIColor+FlatUI.h"
#import "WunderCell.h"

@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray* _myTodos;
    float _editingOffset;
    WunderTableViewNew *_addNew;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _myTodos    = [[NSMutableArray alloc]init];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Fix PS3 Hard Drive"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Pass Wundertest"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Finish Inferno"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Kick some ass"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Play Tennis"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Tag a bag"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Show and tell"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Punch it"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Move to Berlin"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Ice Cubes"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Finish Assignment"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Play Tennis"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Prepare Presentation"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Lunch with Mom"]];
        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Watch Football"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.todoTableView_iPhone.dataSource = self;
        self.todoTableView_iPhone.backgroundColor = [UIColor cloudsColor];
        [self.todoTableView_iPhone registerClassForCells:[WunderCell class]];
        _addNew = [[WunderTableViewNew alloc]initWithTableView:self.todoTableView_iPhone];
    }
    else{
        self.todoTableView_iPad.dataSource = self;
        [self.todoTableView_iPad registerClass:[WunderCell class] forCellReuseIdentifier:@"cell"];
        self.todoTableView_iPad.delegate = self;
        self.todoTableView_iPad.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.todoTableView_iPad.backgroundColor = [UIColor cloudsColor];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)wunderItemDeleted:(id)todo{
    float delay = 0.0;
    
    [_myTodos removeObject:todo];
    
    //NSUInteger index = [_myTodos indexOfObject:todo];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSArray *visibleTodos = [self.todoTableView_iPhone visibleCells];
        UIView *lastTodo = [visibleTodos lastObject];
        bool startAnimation = false;
        for(WunderCell *cell in visibleTodos)
        {
            if(startAnimation){
                [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                } completion:^(BOOL finished){
                    if(cell == lastTodo){
                        [self.todoTableView_iPhone reloadData];
                    }
                }];
                
                delay+=0.03;
            }
            if(cell.todo == todo)
            {
                startAnimation = true;
                cell.hidden = YES;
            }
        }
    }
    else{
        NSArray *visibleTodos = [self.todoTableView_iPad visibleCells];
        UIView *lastTodo = [visibleTodos lastObject];
        bool startAnimation = false;
        for(WunderCell *cell in visibleTodos)
        {
            if(startAnimation){
                [UIView animateWithDuration:0.3 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.frame = CGRectOffset(cell.frame, 0.0f, -cell.frame.size.height);
                } completion:^(BOOL finished){
                    if(cell == lastTodo){
                        [self.todoTableView_iPad reloadData];
                    }
                }];
                delay+=0.03;
            }
            if(cell.todo == todo)
            {
                startAnimation = true;
                cell.hidden = YES;
            }
        }

    }
    
}

#pragma mark - WunderTableViewDataSource methods
-(NSInteger)numberOfRows {
    return _myTodos.count;
}

-(UITableViewCell *)cellForRow:(NSInteger)row {
    //NSString *ident = @"cell";
    WunderCell *cell = (WunderCell *)[self.todoTableView_iPhone dequeueReusableCell];
    TodoVM *item = _myTodos[row];
    cell.todo = item;
    cell.delegate = self;
    cell.backgroundColor = [UIColor sunflowerColor];
    return cell;
}

-(void)todoAdded{
    TodoVM *newTodo = [[TodoVM alloc]init];
    [_myTodos insertObject:newTodo atIndex:0];
    [_todoTableView_iPhone reloadData];
    WunderCell *nCell;
    for(WunderCell * cell in _todoTableView_iPhone.visibleCells)
    {
        if(cell.todo == newTodo){
            nCell = cell;
            break;
        }
    }
    [nCell.label becomeFirstResponder];
}

#pragma mark - UITableViewDataDelegate protocol
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor sunflowerColor];
}

#pragma mark - WunderCellDelegate

-(void)cellDidBeginEditing:(WunderCell *)editingCell {
    _editingOffset = _todoTableView_iPhone.scrollView.contentOffset.y - editingCell.frame.origin.y;
    for(WunderCell* cell in [_todoTableView_iPhone visibleCells]) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
                             if (cell != editingCell) {
                                 cell.alpha = 0.3;
                             }
                         }];
    }
}

-(void)cellDidEndEditing:(WunderCell *)editingCell {
    for(WunderCell* cell in [_todoTableView_iPhone visibleCells]) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             cell.frame = CGRectOffset(cell.frame, 0, -_editingOffset);
                             if (cell != editingCell)
                             {
                                 cell.alpha = 1.0;
                             }
                         }];
    }
}


@end
