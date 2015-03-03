//
//  HomeViewController.m
//  WordWise
//
//  Created by Pratik on 26-10-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import "HomeViewController.h"
#import "ListViewController.h"
#import "RevisionListViewController.h"
#import "SettingsViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize titleLabel;

-(IBAction)settingsTapped
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        [self.navigationController pushViewController:svc animated:YES];
    }
    else
    {
        SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

- (IBAction)addButtonTapped {
    UIAlertView *addListPrompt = [[UIAlertView alloc] initWithTitle:@"Add new List" message:@"Enter a list name" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Add", nil];
    addListPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addListPrompt show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        BOOL flag = NO;
        for (NSString *list in self.customList) {
            if ([list isEqualToString:[alertView textFieldAtIndex:0].text])
                flag = YES;
        }
        if(flag == NO) {
            [self.customList addObject:[alertView textFieldAtIndex:0].text];
            NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString* fileAtPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"customList.plist"]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath])
            {
                [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
            }
            [self.customList writeToFile:fileAtPath atomically:YES];
            [self.tableView reloadData];
        }
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:32]];
    
    self.customList = [[NSMutableArray alloc]init];
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.customList = [[NSMutableArray alloc]initWithContentsOfFile:[filePath stringByAppendingPathComponent:@"customList.plist"]];
    
    if(self.customList == NULL) {
        self.customList = [[NSMutableArray alloc]init];
    }
    
    [self.tableView reloadData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11 + self.customList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Stack %ld",(long)indexPath.row+1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"words from %ld to %ld",400*(long)indexPath.row+1,400*(long)indexPath.row+400];
    if(indexPath.row == 9) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"words from %ld to %d",400*(long)indexPath.row+1,3967];
    }
    if(indexPath.row == 10) {
        cell.textLabel.text = [NSString stringWithFormat:@"All Words"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Global list of all words"];
    }
    if(indexPath.row > 10) {
        cell.textLabel.text = [self.customList objectAtIndex:indexPath.row - 11];
        cell.detailTextLabel.text = @"Custom List";
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 10) {
        [ListViewController setOffset:-1];
        ListViewController *detailViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    } else if (indexPath.row > 10) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            RevisionListViewController *vc = [[RevisionListViewController alloc]initWithNibName:@"RevisionListViewController" bundle:nil];
            vc.listName = [self.customList objectAtIndex:indexPath.row - 11];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            RevisionListViewController *vc = [[RevisionListViewController alloc]initWithNibName:@"RevisionListViewController_iPad" bundle:nil];
            vc.listName = [self.customList objectAtIndex:indexPath.row - 11];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [ListViewController setOffset:(indexPath.row * 400)];
        ListViewController *detailViewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

@end
