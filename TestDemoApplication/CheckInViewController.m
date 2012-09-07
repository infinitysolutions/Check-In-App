//
//  CheckInViewController.m
//  TestDemoApplication
//
//  Created by Ankit Patel on 26/02/12.
//  Copyright (c) 2012 ankitjp26@gmail.com. All rights reserved.
//

#import "CheckInViewController.h"
#import "TestDemoApplicationAppDelegate.h"
@implementation CheckInViewController

@synthesize resultTextView;
@synthesize urlView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Check In";
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

//    [self setUPCameraForScan];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    if([self interfaceOrientation]== UIInterfaceOrientationPortraitUpsideDown || [self interfaceOrientation] == UIInterfaceOrientationPortrait)
    {
        self.view = portrateView;
    }
    else {
        self.view = landScapeView;
    }
    }
    
[self setUPCameraForScan];
}


-(IBAction)StartScan:(id) sender
{
    [self setUPCameraForScan];
}


-(void)setUPCameraForScan
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
	reader.readerDelegate = self;
    reader.cameraDevice=UIImagePickerControllerCameraDeviceFront;
	
	reader.readerView.torchMode = 0;
	
    reader.showsZBarControls = NO;
    
	ZBarImageScanner *scanner = reader.scanner;
	// TODO: (optional) additional reader configuration here
	
	// EXAMPLE: disable rarely used I2/5 to improve performance
	[scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
	
	// present and release the controller
	[self presentModalViewController: reader
							animated: YES];
	[reader release];
	
	//resultTextView.hidden=NO;
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
	NSLog(@"Cannot read barcode. Try again.");
	
	//scanButton.enabled = YES;
	//	scanButton.alpha = 1.0f;
	
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    return [urlTest evaluateWithObject:candidate];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"] && alertView.tag == 1)
    {
        [self setUPCameraForScan];
    }
    else if([title isEqualToString:@"OK"] && alertView.tag == 2)
    {
        [self setUPCameraForScan];
    } 
    else if([title isEqualToString:@"OK"] && alertView.tag == 3)
    {
        [self setUPCameraForScan];
    }
}

-(void)back
{
    [urlView removeFromSuperview];
}


- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info

{
    
    reader.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    
    //NSLog(@"the image picker is calling successfully %@",info);
    
    // ADD: get the decode results
    
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    
    ZBarSymbol *symbol = nil;
    
    NSString *hiddenData;
    
    for(symbol in results)
        
        hiddenData=[NSString stringWithString:symbol.data];
    
    //NSLog(@"the symbols  is the following %@",symbol.data);
    
    // EXAMPLE: just grab the first barcode
    
    //  break;
    
    
    // EXAMPLE: do something useful with the barcode data
    
    //resultText.text = symbol.data;
    
    resultTextView.text=symbol.data;
    
    
    
    //NSLog(@"BARCODE= %@",symbol.data);
    
    
    NSUserDefaults *storeData=[NSUserDefaults standardUserDefaults];
    
    [storeData setObject:hiddenData forKey:@"CONSUMERID"];
        
    NSLog(@"SYMBOL : %@",hiddenData);
    
    resultTextView.text=hiddenData;
    NSString *strUrl = [NSString stringWithFormat:@"URL?id=%@&Username=admin&Password=63b2c1751b",[hiddenData]];
    
    //    NSLog(@"%@",strUrl);
    NSURL *url = [NSURL URLWithString:strUrl];
    NSLog(@"url = %@",url);
    NSString *strTemp = [NSString stringWithContentsOfURL:url encoding:NSStringEncodingConversionAllowLossy error:nil];    
    NSLog(@"check in response =%@",strTemp);
    
    
    if ([strTemp isEqualToString:@"CheckedIn"]) 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Check In" message:@"Member Checked In Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
        [alert release];UIView * infoButton = [[[[[reader.view.subviews objectAtIndex:1] subviews] objectAtIndex:0] subviews] objectAtIndex:1];
        [infoButton setHidden:YES];
        
    }
    else if ([strTemp isEqualToString:@"AlreadyChecked"]) 
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"AlreadyChecked" message:@"Member Already Checked In" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag =2;
        [alert show];
        [alert release];
    }
    else
    {
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Invalid" message:@"Membership Number Is Invalid" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 3;
        [alert show];
        [alert release];
    }
    
    [reader dismissModalViewControllerAnimated: NO];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        TestDemoApplicationAppDelegate *appDeleg = (TestDemoApplicationAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            self.view = portrateView;
            appDeleg.orientation = 1 ;
        }
        else
        {
            self.view = landScapeView;
            appDeleg.orientation = 0 ;
        }
    }
    else
    { 
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    // Return YES for supported orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        return YES;
        
    }
    else
    { 
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

@end
