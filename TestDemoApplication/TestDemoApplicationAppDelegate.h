//
//  TestDemoApplicationAppDelegate.h
//  TestDemoApplication
//
//  Created by ankit patel on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestDemoApplicationAppDelegate : UIResponder <UIApplicationDelegate> {
    
    BOOL orientation;
}

@property (nonatomic, readwrite) BOOL orientation;

@property (strong, nonatomic) UIViewController *viewController;

@property (nonatomic, retain) UIWindow *window;


@end
