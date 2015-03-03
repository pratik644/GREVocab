//
//  RevisionListViewController.h
//  GREVocab
//
//  Created by Pratik on 21-08-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface RevisionListViewController : UITableViewController <UIGestureRecognizerDelegate>
{
//    NSMutableArray *revisionList;
//    IBOutlet UIButton *backBtn;
//    IBOutlet UIButton *editBtn;
//    IBOutlet UILabel *titleLabel;
    sqlite3 *database;
}

@property (nonatomic, retain) NSMutableArray *revisionList;
@property (nonatomic, retain) IBOutlet UIButton *backBtn;
@property (nonatomic, retain) IBOutlet UIButton *editBtn;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) NSString *listName;

-(IBAction)swiperight:(UIGestureRecognizer*)sender;
-(IBAction)toggleEdit:(id)sender;
-(IBAction)backBtnTapped:(id)sender;
@end
