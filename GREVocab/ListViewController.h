//
//  ListViewController.h
//  GREVocab
//
//  Created by Pratik on 15-08-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface ListViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
{
//    //IBOutlet UITableView *tableView;
//    NSMutableArray *words;
//    NSMutableArray *meanings;
//    NSMutableArray *searchResults;
//    NSMutableArray *searchMeanings;
    sqlite3 *database;
//    IBOutlet UISearchBar *searchBar;
//    IBOutlet UISearchDisplayController *searchDisplayController;
}

//@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *words;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSMutableArray *meanings;
@property (nonatomic, retain) NSMutableArray *searchMeanings;
@property (nonatomic, retain) NSMutableArray *indices;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchDisplayController;

-(IBAction)back;
+ (void)setOffset:(long)offset;
+ (void)sortByColumn:(int)column order:(int)order;
+ (int)getSortColumn;
+ (int)getSortOrder;
@end
