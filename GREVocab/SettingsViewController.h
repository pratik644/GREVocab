//
//  SettingsViewController.h
//  WordWise
//
//  Created by Pratik on 27-10-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

@interface SettingsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
//    IBOutlet UILabel *titleLabel;
//    IBOutlet UILabel *fontTitle;
//    IBOutlet UILabel *sizeLabel;
//    IBOutlet UIStepper *fontStepper;
}
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *fontTitle;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UIStepper *fontStepper;
@property (strong, nonatomic) IBOutlet UIPickerView *sortPicker;
@property (strong, nonatomic) NSMutableArray *sortColumn;
-(IBAction)backBtnTapped;
-(IBAction)fontSizeChanged;


@end
