//
//  ListViewController.m
//  GREVocab
//
//  Created by Pratik on 15-08-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import "ListViewController.h"
#import "ViewController.h"
#import "RevisionListViewController.h"
#import <UIKit/UIKit.h>
@interface ListViewController ()

@end

@implementation ListViewController

static long _offset = 0;

static int sortOrder = 0;

static int sortColumn = 0;

@synthesize words, searchResults, meanings, searchBar, searchDisplayController, searchMeanings;

+ (void)sortByColumn:(int)column order:(int)order {
    sortColumn = column;
    sortOrder = order;
}

+ (void)setOffset:(long)offset
{
    _offset = offset;
    [ViewController setOffset:_offset];
}

+ (int)getSortColumn {
    return sortColumn;
}

+ (int)getSortOrder {
    return sortOrder;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)back;
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.searchResults = [[NSMutableArray alloc]init];
    self.meanings = [[NSMutableArray alloc]init];
    self.searchMeanings = [[NSMutableArray alloc]init];
    
    sortColumn = [[[NSUserDefaults standardUserDefaults] valueForKey:@"sortColumn"] intValue];
    sortOrder = [[[NSUserDefaults standardUserDefaults] valueForKey:@"sortOrder"] intValue];
    
    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    if([[[UIDevice currentDevice] systemVersion] intValue] ==6)
    {
        [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [self.searchBar setBackgroundColor:[UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.000]];
        [searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor whiteColor]];
        [searchDisplayController.searchResultsTableView setSeparatorColor:[UIColor colorWithRed:0.878 green:0.878 blue:0.878 alpha:1.000]];
    }
    
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"sqlite3"];
    
    if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK)
    {
        //NSLog(@"Failed to open database!");
    }
    //NSLog(@"%ld",_offset);
    
    NSString *query = [NSString stringWithFormat:@"SELECT field2, field3, field1 FROM words where CAST(field1 AS INT)  > %ld LIMIT 400",_offset];
    
    if (_offset == -1) {
        _offset = 1;
        
        NSString *querySortOrder = @"";
        if(sortOrder == 1) {
            querySortOrder = @"desc";
        }
        
        NSString *querySortField = @"field2";
        switch (sortColumn) {
            case 0:
                querySortField = @"field1";
                break;
            case 1:
                querySortField = @"field9";
                break;
            case 2:
                querySortField = @"field11";
                break;
            default:
                querySortField = @"field2";
                break;
        }
        
        query = [NSString stringWithFormat:@"SELECT field2, field3, field1 FROM words order by CAST(%@ AS INT) %@",querySortField, querySortOrder];
    }
    
    NSLog(@"%@",query);
    
    sqlite3_stmt *statement;
    int i=0;
    _indices = [[NSMutableArray alloc] init];
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        self.words = [[NSMutableArray alloc]initWithCapacity:3968];
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] != nil || [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] != nil)
            {
                self.words[i] = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                self.meanings[i] = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                self.indices[i] = [[NSString alloc] initWithUTF8String:(char*)sqlite3_column_text(statement,2)];
                i++;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
    }
    else
    {
        return [words count];
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [searchMeanings objectAtIndex:indexPath.row];
    }
    
    else
    {
        cell.textLabel.text = [words objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [meanings objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    //cell.textLabel.textColor = [UIColor colorWithRed:0.263 green:0.263 blue:0.263 alpha:1.000];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
//        [ViewController setParamWord:[NSString stringWithFormat:@"%ld",[words indexOfObject:[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath].textLabel.text]+_offset+1]];
        [ViewController setParamWord:[_indices[[words indexOfObject:[self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath].textLabel.text]] intValue]];
    }
    else
    {
//        [ViewController setParamWord:[NSString stringWithFormat:@"%ld",indexPath.row+_offset+1]];
        [ViewController setParamWord:[_indices[indexPath.row] intValue]];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        ViewController *vc = [[ViewController alloc]initWithNibName:@"ViewController_iPhone" bundle:nil];
        [ViewController setIndices:self.indices];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ViewController *vc = [[ViewController alloc]initWithNibName:@"ViewController_iPad" bundle:nil];
        [ViewController setIndices:self.indices];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    self.searchResults = [NSMutableArray arrayWithArray:[words filteredArrayUsingPredicate:predicate]];
    for(int i=0; i<searchResults.count; i++)
    {
        searchMeanings[i] = meanings[[words indexOfObject:[searchResults objectAtIndex:i]]];
    }
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:nil];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return NO;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        searchBar.frame = CGRectMake(64.0f, 8.0f, 250.0f, 44.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    else
    {
        searchBar.frame = CGRectMake(68.0f, 8.0f, 700.0f, 44.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        searchBar.frame = CGRectMake(64.0f, 8.0f, 250.0f, 44.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
    else
    {
        searchBar.frame = CGRectMake(68.0f, 14.0f, 700.0f, 44.0f);
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text=@"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
}

@end
