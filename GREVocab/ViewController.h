//
//  ViewController.h
//  GREVocab
//
//  Created by Pratik on 15-08-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    sqlite3 *database;
//    NSString *result;
//    NSMutableAttributedString *result2;
//    NSMutableArray *revisionList;
//    IBOutlet UITextView *txtView;
//    IBOutlet UIImageView *imgView;
//    IBOutlet UILabel *wordTitle;
//    IBOutlet UIButton *backBtn;
//    IBOutlet UIButton *bookmarkBtn;
//    IBOutlet UIGestureRecognizer *swipeRight;
//    IBOutlet UIGestureRecognizer *swipeRighti;
//    IBOutlet UIGestureRecognizer *swipeLeft;
//    IBOutlet UIGestureRecognizer *swipeLefti;
   
}



@property (nonatomic, retain) NSString *result;
@property (nonatomic, retain) NSMutableAttributedString *result2;
@property (nonatomic, retain) NSMutableArray *revisionList;
@property (nonatomic, retain) IBOutlet UITextView *txtView;
@property (nonatomic, retain) IBOutlet UIImageView *imgView;
@property (nonatomic, retain) IBOutlet UIButton *backBtn;
@property (nonatomic, retain) IBOutlet UIButton *bookmarkBtn;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *swipeRight;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *swipeRighti;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *swipeLeft;
@property (nonatomic, retain) IBOutlet UIGestureRecognizer *swipeLefti;
@property (nonatomic, retain) IBOutlet UILabel *wordTitle;
@property (nonatomic, retain) IBOutlet UIView *callOut;
@property (nonatomic, retain) IBOutlet UIImageView *callOutImage;
@property (nonatomic, retain) NSMutableArray *customList;
@property (nonatomic, retain) IBOutlet UIView *listPickerContainer;
@property (nonatomic, retain) IBOutlet UIPickerView *listPicker;

- (void)search:(int)direction;
- (IBAction)backBtnTapped;
- (IBAction)bookmarkBtnTapped:(UIGestureRecognizer*)sender;
- (IBAction)swipedRight:(UIGestureRecognizer*)sender;
- (IBAction)swipedLeft:(UIGestureRecognizer*)sender;
- (IBAction)shuffleBtnTapped:(id)sender;
- (IBAction)showImage;
- (IBAction)hideImage;
- (IBAction)doneButtonTapped;
- (IBAction)cancelButtonTapped;
+ (void)setParamWord:(int)myParamWord;
+ (void)setTextFontSize:(int)tsize;
+ (int) getTextFontSize;
+ (void)setOffset:(long)offset;
+ (void)setIndices:(NSMutableArray*)indexArray;

@end
