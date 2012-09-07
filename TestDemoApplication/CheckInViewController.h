//
//  CheckInViewController.h
//  TestDemoApplication
//
//  Created by Ankit Patel on 26/02/12.
//  Copyright (c) 2012 ankitjp26@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface CheckInViewController : UIViewController <ZBarReaderDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    IBOutlet UITextView *resultTextView;
    UIWebView *urlView;
    IBOutlet UITextField *txtID;
    
    IBOutlet UITextField *txtIDLandScap;
    
    IBOutlet UIView *landScapeView;
    IBOutlet UIView *portrateView;
    
}

@property (nonatomic, retain) IBOutlet UITextView *resultTextView;
@property (nonatomic, retain) UIWebView *urlView;

-(void)setUPCameraForScan;
-(IBAction)StartScan:(id) sender;

@end
