//
//  SettingsViewController.m
//  WordWise
//
//  Created by Pratik on 27-10-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize titleLabel,fontStepper,fontTitle,sizeLabel;

-(IBAction)backBtnTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)fontSizeChanged
{
    sizeLabel.text = [[NSString alloc] initWithFormat:@"%d",(int)[self.fontStepper value]];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:self.fontStepper.value] forKey:@"fontSize"];
//    [ViewController setTextFontSize:(int)[self.fontStepper value]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.titleLabel setFont:[UIFont fontWithName:@"Oswald" size:32]];
    [self.fontTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [self.sizeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    self.sizeLabel.text = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] valueForKey:@"fontSize"] intValue]];
//    [self.fontStepper setValue:[ViewController getTextFontSize]];
    [self.fontStepper setValue:[[[NSUserDefaults standardUserDefaults] valueForKey:@"fontSize"] intValue]];
    
    self.sortColumn = [@[@"Alphabet", @"Frequency", @"Difficulty"] mutableCopy];

    [self.sortPicker selectRow:[[[NSUserDefaults standardUserDefaults] valueForKey:@"sortColumn"] intValue] inComponent:0 animated:NO];
    [self.sortPicker selectRow:[[[NSUserDefaults standardUserDefaults] valueForKey:@"sortOrder"] intValue] inComponent:1 animated:NO];
//    [self.sortPicker selectRow:(int)[[NSUserDefaults standardUserDefaults] valueForKey:@"sortColumn"] inComponent:0 animated:NO];
//    [self.sortPicker selectRow:(int)[[NSUserDefaults standardUserDefaults] valueForKey:@"sortOrder"] inComponent:0 animated:NO];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PckerView Delegate and datasource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0) {
        return 3;
    } else {
        return 2;
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(component == 0) {
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:[self.sortColumn objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attributedTitle;
    } else {
        NSString *sortOrder = @"Ascending";
        if(row == 1) {
            sortOrder = @"Descending";
        }
        NSMutableAttributedString *sortOrderTitle = [[NSMutableAttributedString alloc] initWithString:sortOrder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        return sortOrderTitle;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:row] forKey:@"sortColumn"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:row] forKey:@"sortOrder"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
