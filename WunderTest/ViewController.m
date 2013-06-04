//
//  ViewController.m
//  WunderTest
//
//  Created by Ali Raza on 03/06/2013.
//  Copyright (c) 2013 Ali Raza. All rights reserved.
//

#import "ViewController.h"
#import "TodoVM.h"

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
        [self.todoTableView_iPhone registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    else{
        self.todoTableView_iPad.dataSource = self;
        [self.todoTableView_iPad registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myTodos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    int index = [indexPath row];
    TodoVM *todo = _myTodos[index];
    cell.textLabel.text = todo.title;
    return cell;
}

@end
