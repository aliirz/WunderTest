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
#import <CoreData/CoreData.h>
#import "Todo.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"


@interface ViewController ()

@end

@implementation ViewController{
    NSMutableArray* _myTodos;
    float _editingOffset;
    WunderTableViewNew *_addNew;
}
@synthesize managedObjectContext;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        _myTodos    = [[NSMutableArray alloc]init];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Move to Berlin" andCompleted:NO]];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Ice Cubes" andCompleted:NO]];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Finish Assignment" andCompleted:NO]];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Play Tennis" andCompleted:NO]];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Prepare Presentation" andCompleted:NO]];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Lunch with Mom" andCompleted:NO]];
//        [_myTodos addObject:[TodoVM getTodoWithTitle:@"Watch Football" andCompleted:NO]];
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        NSArray *todosFromDB = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for(Todo *t in todosFromDB)
        {
            [_myTodos addObject:[TodoVM getTodoWithTitle:t.title andCompleted:[t.completed boolValue]]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+"
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(addNewTodo:)];
    self.title = @"WunderTest";
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.todoTableView_iPhone.dataSource = self;
        self.todoTableView_iPhone.backgroundColor = [UIColor cloudsColor];
        [self.todoTableView_iPhone registerClassForCells:[WunderCell class]];
        _addNew = [[WunderTableViewNew alloc]initWithTableView:self.todoTableView_iPhone];
    }
    else{
        self.todoTableView_iPad.dataSource = self;
        self.todoTableView_iPad.backgroundColor = [UIColor cloudsColor];
        [self.todoTableView_iPad registerClassForCells:[WunderCell class]];
        _addNew = [[WunderTableViewNew alloc]initWithTableView:self.todoTableView_iPad];
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
                //lets delete it from our coredata context as well.
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Todo" inManagedObjectContext:managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
                [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title == %@",cell.todo.title]];
                [fetchRequest setEntity:entity];
                NSError *error;
                NSArray *objs = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
                for(Todo  *t in objs)
                {
                    //if(t.title == cell.todo.title)
                   // {
                        [managedObjectContext deleteObject:t];
                    //}
                    NSLog(@"Todo: %@", t.title);
                }
                [managedObjectContext save:&error];
                
                
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
    WunderCell *cell;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        cell = (WunderCell *)[self.todoTableView_iPhone dequeueReusableCell];
    }
    else{
        cell = (WunderCell *)[self.todoTableView_iPad dequeueReusableCell];
    }
    TodoVM *item = _myTodos[row];
    cell.todo = item;
    cell.delegate = self;
    cell.backgroundColor = [UIColor sunflowerColor];
    return cell;
}

-(void)todoAdded{
    
    TodoVM *newTodo = [[TodoVM alloc]init];
    [_myTodos insertObject:newTodo atIndex:0];
    WunderCell *nCell;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [_todoTableView_iPhone reloadData];
    for(WunderCell * cell in _todoTableView_iPhone.visibleCells)
    {
        if(cell.todo == newTodo){
            nCell = cell;
            break;
        }
    }
        
    }
    else{
        [_todoTableView_iPad reloadData];
        for(WunderCell *cell in _todoTableView_iPad.visibleCells)
        {
            if(cell.todo == newTodo){
                nCell = cell;
                break;
            }
        }
    }
    [nCell.label becomeFirstResponder];
}

-(void)addNewTodo:(id)sender{
    [self todoAdded];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
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
    else{
        _editingOffset = _todoTableView_iPad.scrollView.contentOffset.y - editingCell.frame.origin.y;
        for(WunderCell* cell in [_todoTableView_iPad visibleCells]) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 cell.frame = CGRectOffset(cell.frame, 0, _editingOffset);
                                 if (cell != editingCell) {
                                     cell.alpha = 0.3;
                                 }
                             }];
        }
    }
}

-(void)cellDidEndEditing:(WunderCell *)editingCell {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
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
    else{
        for(WunderCell* cell in [_todoTableView_iPad visibleCells]) {
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
}

@end
