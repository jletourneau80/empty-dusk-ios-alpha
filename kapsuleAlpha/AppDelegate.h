//
//  kapsuleAppDelegate.h
//  kapsule
//
//  Created by Letourneau, Jason B. on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : NSObject <UIApplicationDelegate,UIAlertViewDelegate,
CLLocationManagerDelegate>{
    
    
    CLLocationDegrees lat;
    CLLocationDegrees lon;
    NSURLConnection* kapsuleConnection;
    NSURLConnection* kapsuleLoginConnection;
    NSMutableData* receivedData;
    CLLocationManager *locationManager;
    CLLocation *lastUpdateLocation;
}

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) MainViewController *mainViewController;
@property (nonatomic) bool isAppInBackGround;
@property (nonatomic) bool didNotifyUserOfNewInfo;
@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) NSString *kapsule_token;
@property (nonatomic, retain) NSString *FBID;
@property (nonatomic,retain) NSString  *FB_token;


-(void) doFacebookLogin;
-(void) doKapsuleLogin;
- (void)openSession;
-(void) showLoginView;
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;




@end
