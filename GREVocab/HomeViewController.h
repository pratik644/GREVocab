//
//  HomeViewController.h
//  WordWise
//
//  Created by Pratik on 26-10-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

@interface HomeViewController : UITableViewController <UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) NSMutableArray *customList;

-(IBAction) settingsTapped;
-(IBAction) addButtonTapped;

@end
