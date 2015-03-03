//
//  ViewController.m
//  GREVocab
//
//  Created by Pratik on 15-08-13.
//  Copyright (c) 2013 TouchMonks. All rights reserved.
//

#import "ViewController.h"
#import "ListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreFoundation/CoreFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize imgView, txtView, result, wordTitle, backBtn, bookmarkBtn, swipeRight, swipeRighti, swipeLeft, swipeLefti, revisionList, result2, callOut, callOutImage;

NSMutableArray *indices;

static int paramWord;     //Array range 0-3966

static int textFontSize = 18;

static long _offset = 0;

static CATransition *transition;

+ (void) setTextFontSize:(int)tsize {
    textFontSize = tsize;
}

+ (int) getTextFontSize {
    return textFontSize;
}

+ (void)setOffset:(long)offset {
    _offset = offset;
}

+ (void)setIndices:(NSMutableArray*)indexArray {
    indices = [[NSMutableArray alloc] init];
    indices = indexArray;
}

+(void)setParamWord:(int)myParamWord {
    paramWord = myParamWord;
}

-(IBAction)showImage {
    [imgView setHidden:NO];
}

-(IBAction)hideImage {
    [imgView setHidden:YES];
}

-(IBAction)swipedRight:(UIGestureRecognizer *)sender {
    if([indices indexOfObject:[NSString stringWithFormat:@"%d",paramWord]] >= 1 && [indices indexOfObject:[NSString stringWithFormat:@"%d",paramWord]] >= _offset+1) {
//        paramWord = [NSString stringWithFormat:@"%ld",([paramWord integerValue]-1)];
        paramWord = [[indices objectAtIndex:([indices indexOfObject:[NSString stringWithFormat:@"%d",paramWord]] - 1)] intValue];
        [self search:0];
    }
}

-(IBAction)swipedLeft:(UIGestureRecognizer*)sender {
    if([indices indexOfObject:[NSString stringWithFormat:@"%d",paramWord]] <= 3967 && [indices indexOfObject:[NSString stringWithFormat:@"%d",paramWord]] <= _offset+400) {
        paramWord = [[indices objectAtIndex:([indices indexOfObject:[NSString stringWithFormat:@"%d",paramWord]] + 1)] intValue];
//        paramWord = [NSString stringWithFormat:@"%ld",([paramWord integerValue]+1)];
        [self search:1];
    }
}

-(IBAction)bookmarkBtnTapped:(UIGestureRecognizer*)sender {
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.listPickerContainer setFrame:CGRectMake(self.listPickerContainer.frame.origin.x, self.listPickerContainer.frame.origin.y - self.listPickerContainer.frame.size.height, self.listPickerContainer.frame.size.width, self.listPickerContainer.frame.size.height)];
    }];
//    BOOL flag = NO;
//    for(int i=0; i<revisionList.count; i++) {
//        if([revisionList[i] isEqual:[self.wordTitle.text lowercaseString]])
//            flag = YES;
//    } if(!flag) {
//        [self.revisionList addObject:[self.wordTitle.text lowercaseString]];
//        [self.wordTitle setTextColor:[UIColor orangeColor]];
//    }
}

-(IBAction)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)shuffleBtnTapped:(id)sender {
    //paramWord = [NSString stringWithFormat:@"%d",(rand() % (3967 - 1) + 1)];
    paramWord = (rand() % ((((_offset + 400) - _offset) +1) + _offset));
    //NSLog(@"Min:%ld  Max:%ld  RandomNum:%ld",_offset, _offset+400, (rand() % (((_offset + 400) - _offset) + 1) + _offset));
    [self search:2];
}

-(IBAction)doneButtonTapped {
    NSMutableArray *list = [[NSMutableArray alloc]init];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    list = [[NSMutableArray alloc]initWithContentsOfFile:[filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[_customList objectAtIndex:[self.listPicker selectedRowInComponent:0]] lowercaseString]]]];
    if(list == NULL) {
        list = [[NSMutableArray alloc]init];
    }
    
    BOOL flag = NO;
    for(int i=0; i<list.count; i++) {
        if([list[i] isEqual:[self.wordTitle.text lowercaseString]])
            flag = YES;
    } if(!flag) {
        [list addObject:[self.wordTitle.text lowercaseString]];
        NSString* fileAtPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[[_customList objectAtIndex:[self.listPicker selectedRowInComponent:0]] lowercaseString]]];
        if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
            [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
        }
        [list writeToFile:fileAtPath atomically:YES];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.listPickerContainer setFrame:CGRectMake(self.listPickerContainer.frame.origin.x, self.listPickerContainer.frame.origin.y + self.listPickerContainer.frame.size.height, self.listPickerContainer.frame.size.width, self.listPickerContainer.frame.size.height)];
    }];
}

- (IBAction)cancelButtonTapped {
    [UIView animateWithDuration:0.3f animations:^{
        [self.listPickerContainer setFrame:CGRectMake(self.listPickerContainer.frame.origin.x, self.listPickerContainer.frame.origin.y + self.listPickerContainer.frame.size.height, self.listPickerContainer.frame.size.width, self.listPickerContainer.frame.size.height)];
    }];
}

//-(void)viewWillDisappear:(BOOL)animated {
//    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString* fileAtPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"revision.plist"]];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath])
//    {
//        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
//    }
//    [self.revisionList writeToFile:fileAtPath atomically:YES];
//}

-(void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initializations
    //NSLog(@"textFontSize:%d",textFontSize);
    //NSLog(@"offset:%ld",_offset);
    [wordTitle setFont:[UIFont fontWithName:@"Oswald" size:32]];
    textFontSize = [[[NSUserDefaults standardUserDefaults] valueForKey:@"fontSize"] intValue];
    [self.callOut setBackgroundColor:[UIColor clearColor]];
    [self.callOutImage setImage:[UIImage imageNamed:@"callOut"]];
    [self.callOut setHidden:YES];
    
//    self.revisionList = [[NSMutableArray alloc]init];
//    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    self.revisionList = [[NSMutableArray alloc]initWithContentsOfFile:[filePath stringByAppendingPathComponent:@"revision.plist"]];
//    
//    if(revisionList == NULL) {
//        self.revisionList = [[NSMutableArray alloc]init];
//    }
    
    self.customList = [[NSMutableArray alloc]init];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.customList = [[NSMutableArray alloc]initWithContentsOfFile:[filePath stringByAppendingPathComponent:@"customList.plist"]];
    
    if(self.customList == NULL) {
        self.customList = [[NSMutableArray alloc]init];
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if(( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )) {
            // set the frame specific for iPhone 5
            //NSLog(@"Running on iPhone 5");
            self.txtView.layer.frame = CGRectMake(0, 60, 320, 508);
            self.imgView.layer.frame = CGRectMake(0, 80, 320, 488);
        } else {
            //NSLog(@"Running on iPhone 4/4S");
            self.txtView.layer.frame = CGRectMake(0, 60, 320, 420);
            self.imgView.layer.frame = CGRectMake(0, 80, 320, 400);
        }
    }
    [self search:2];
}

-(void)search:(int)direction {
    [self.wordTitle setTextColor:[UIColor whiteColor]];
    
    result = [[NSString alloc]init];
    result2 = [[NSMutableAttributedString alloc]init];
    UIImage *img4word = [[UIImage alloc]init];
    
    //PrepareAnimations
    transition = [CATransition animation];
    transition.duration = 0.30;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    if(direction == 0) {
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromLeft;
    } else if(direction == 1) {
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
    }
    else if(direction == 2) {
        transition.type = kCATransitionFade;
    }
    transition.delegate = self;
    [self.txtView.layer addAnimation:transition forKey:nil];
    [self.imgView.layer addAnimation:transition forKey:nil];
    [self.wordTitle.layer addAnimation:transition forKey:nil];
    //PrepareAnimations
    
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"sqlite3"];
    
    if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK) {
        //NSLog(@"Failed to open database!");
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT field1, field2, field3, field4, field5, field9, field10, field14, field15, field16, field17, field31, field40 FROM words WHERE field1 = \'%d\'",paramWord];
    
    //Databae field mappings 9-6, 10-7, 14-8, 15-9, 16-10, 17-11, 31-12, 40-13
    
    sqlite3_stmt *statement;
    
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            NSString *v1,*v2,*v3,*v4,*v5,*v6,*v7,*v8,*v9,*v10,*v11,*v12 = [[NSString alloc]init];
    
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)] != nil)
            {
                v1 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)] != nil)
            {
                v2 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)] != nil)
            {
                v3 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)] != nil)
            {
                v4 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)] != nil)
            {
                v5 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 6)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 9)] != nil)
            {
                v6 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 9)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 10)] != nil)
            {
                v7 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 10)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 12)] != nil)
            {
                v8 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 12)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)] != nil)
            {
                v9 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 7)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)] != nil)
            {
                v10 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 8)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)] != nil)
            {
                if([[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)] isEqualToString:@"0"]) {
                    v11 = @"Low";
                } else if([[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)] isEqualToString:@"1"]) {
                    v11 = @"Medium";
                } else if([[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)] isEqualToString:@"2"]) {
                    v11 = @"High";
                } else {
                    v11 = @"Very High";
                }
//                v11 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 5)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            if([[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 11)] != nil)
            {
                v12 = [[[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement,11)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }

            result = [NSString  stringWithFormat:@"Meaning: %@\n\nUsage:\n%@\n\n",v2,v4];
            if(![v3 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Mnemonic: %@\n\n",result,v3];
            if(![v5 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Root: %@\n\n",result,v5];
            if(![v6 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Synonym: %@\n\n",result,v6];
            if(![v7 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Antonym: %@\n\n",result,v7];
            if(![v8 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Other forms: %@\n\n",result,v8];
            if(![v9 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Confused with: %@\n\n",result,v9];
            if(![v10 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Group: %@\n\n",result,v10];
            if(![v11 isEqual: @""])
                result = [NSString stringWithFormat:@"%@Frequency: %@\n\n",result,v11];
            
            wordTitle.text = [v1 uppercaseString];
            
            if([v12 isEqual: @"TRUE"])
            {
                img4word = [UIImage imageNamed:[NSString stringWithFormat:@"%d.dlli",paramWord]];
            }
            else
            {
                img4word = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"placeholder" ofType:@"png"]];
            }
        }
        else
        {
            //NSLog(@"No record found");
            result = [NSString stringWithFormat:@"Not found, check spelling or try again"];
        }
        sqlite3_finalize(statement);
    }
//    else
//    {
//        NSLog(@"Could not prepare query");
//    }

    result2 = [[NSMutableAttributedString alloc]initWithString:result];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[UIColor colorWithRed:0.498 green:0.498 blue:0.498 alpha:1.000]];
    [shadow setShadowBlurRadius:0.8];
    [shadow setShadowOffset:CGSizeMake(0, 0)];
    
    [result2 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Archivo Narrow" size:textFontSize], NSFontAttributeName, nil] range:[result rangeOfString:result]];
    //[result2 addAttribute:NSShadowAttributeName value:shadow range:[result rangeOfString:result]];
    
    NSArray *titles = [NSArray arrayWithObjects:@"Meaning:",@"Mnemonic:", @"Usage:", @"Root:", @"Synonym:", @"Antonym:", @"Other forms:", @"Confused with:", @"Group:", @"Frequency:", nil];
    for (NSString *label in titles) {
        if ([result rangeOfString:label].location != NSNotFound) {
            [result2 setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Archivo Narrow" size:textFontSize], NSFontAttributeName, nil] range:[result rangeOfString:label]];
            [result2 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:[result rangeOfString:label]];
            [result2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:[result rangeOfString:label]];
            if([[[UIDevice currentDevice] systemVersion] intValue] >= 7)
            {
                [result2 addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithRed:0.925 green:0.306 blue:0.106 alpha:1.000] range:[result rangeOfString:label]];
            }
        }
    }
     
    [txtView setAttributedText:result2];
    [txtView setNeedsDisplay];
    imgView.image = img4word;
}

#pragma mark - PckerView Delegate and datasource

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.customList.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:[self.customList objectAtIndex:row] attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    return attributedTitle;
}

@end
