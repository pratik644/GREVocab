//
//  RevisionListViewController.m
//  GREVocab
//
//  Created by Pratik on 21-08-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import "RevisionListViewController.h"
#import "ViewController.h"
@interface RevisionListViewController ()

@end

@implementation RevisionListViewController

@synthesize revisionList, backBtn, editBtn, titleLabel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)swiperight:(UIGestureRecognizer*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toggleEdit:(id)sender
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if (self.tableView.editing)
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"DoneBtn.png"] forState:UIControlStateNormal];
    else
        [self.editBtn setBackgroundImage:[UIImage imageNamed:@"EditBtn.png"] forState:UIControlStateNormal];
}


-(void)viewWillDisappear:(BOOL)animated
{
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[self.listName lowercaseString]]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath])
    {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    [self.revisionList writeToFile:fileAtPath atomically:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:32]];
    [self.titleLabel setText:[self.listName uppercaseString]];
    self.revisionList = [[NSMutableArray alloc]init];
    
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    self.revisionList = [[NSMutableArray alloc]initWithContentsOfFile:[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[self.listName lowercaseString]]]];
    
    //NSLog(@"%@",revisionList.description);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.revisionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.text = self.revisionList[indexPath.row];
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.textLabel.textColor = [UIColor colorWithRed:0.263 green:0.263 blue:0.263 alpha:1.000];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        [self.revisionList removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
    
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"sqlite3"];
    
    if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK)
    {
        //NSLog(@"Failed to open database!");
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT field1 FROM words where field2 = \'%@\'",[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            [ViewController setParamWord:(int)((char *)sqlite3_column_text(statement, 0))];
        }
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIViewController *vc = [[ViewController alloc]initWithNibName:@"ViewController_iPhone" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *vc = [[ViewController alloc]initWithNibName:@"ViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
