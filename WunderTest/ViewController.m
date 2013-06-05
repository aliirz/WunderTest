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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.todoTableView_iPhone.dataSource = self;
        [self.todoTableView_iPhone registerClass:[WunderCell class] forCellReuseIdentifier:@"cell"];
        self.todoTableView_iPhone.delegate = self;
        self.todoTableView_iPhone.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.todoTableView_iPhone.backgroundColor = [UIColor cloudsColor];
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

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myTodos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    
    WunderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    int index = [indexPath row];
    TodoVM *todo = _myTodos[index];
    //cell.textLabel.text = todo.title;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.todo = todo;
    return cell;
}

#pragma mark - UITableViewDataDelegate protocol
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor sunflowerColor];
}


@end
