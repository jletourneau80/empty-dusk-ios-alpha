//
//  kapsuleAppDelegate.m
//  kapsule
//
//  Created by Letourneau, Jason B. on 5/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;
@synthesize mainViewController = _mainViewController;

@synthesize isAppInBackGround;
@synthesize didNotifyUserOfNewInfo;
@synthesize FBID;
@synthesize kapsule_token;
static NSString* apiUrl = @"http://empty-dusk-3091.herokuapp.com";

//static NSString* apiUrl = @"http://127.0.0.1:3000";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                  bundle:nil];
    self.mainViewController = [sb instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.navController = [[UINavigationController alloc]
                          initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
    return YES;
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController modalViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                      bundle:nil];
        LoginViewController* loginViewController = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];

       [topViewController presentModalViewController:loginViewController animated:NO];
    } else {
        LoginViewController* loginViewController =
        (LoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
}


- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController modalViewController]
                 isKindOfClass:[LoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


- (void)setUpLocationManager{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    //check to see if the distance since last update passes a threshhold...then update...
    
    NSLog([NSString stringWithFormat:@"/kapsule_messages/find.json?lat=%f&lon=%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    
    
    
    if (lastUpdateLocation==nil && kapsule_token!=nil){
        lastUpdateLocation = newLocation;
        //do restful find call...if has data...tell about it
        [self getKapsules:newLocation.coordinate.latitude :newLocation.coordinate.longitude];
        
    }else if (kapsule_token!=nil){
        if ([lastUpdateLocation distanceFromLocation:newLocation] > 1000 || isAppInBackGround == true){ //just for test the background
            lastUpdateLocation = newLocation;
            
            [self getKapsules:newLocation.coordinate.latitude :newLocation.coordinate.longitude];
            
        }else{
            //TODO: JUST FOR TESTING UPDATE EVERY TIME
            
            
            [self getKapsules:newLocation.coordinate.latitude :newLocation.coordinate.longitude];
            
            
        }
    }
    
    
    
    
    
    
}



- (void)getKapsules: (CLLocationDegrees) latitude :(CLLocationDegrees) longitude{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://empty-dusk-3091.herokuapp.com/kapsule_messages/find.json?lat=%f&lon=%f&auth_token=%@",latitude,longitude,kapsule_token]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10];
    if (request) {
        [request setURL:url];
        kapsuleConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse*)response;
{
    receivedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data;
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection*)connection
  didFailWithError:(NSError*)error;
{
    NSLog(@"WHOOPS! Something went wrong");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
	[alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    //  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
    //                        delegate.FBID, @"facebook_id",[defaults objectForKey:@"FBAccessTokenKey"],  @"facebook_auth_token", nil];
    //[[RKClient sharedClient] post:@"/api/v1/tokens.json" params:params delegate:self];
    
    
    if (connection==kapsuleConnection){
        NSString* s = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
        NSLog(@"Received data %@", s);
        
        
        NSArray *resultData = [NSJSONSerialization JSONObjectWithData:receivedData
                                                              options:kNilOptions
                                                                error:nil];
        
        if (resultData.count > 0 && didNotifyUserOfNewInfo){
            NSDate *alertTime = [[NSDate date] dateByAddingTimeInterval:1];
            UIApplication* app = [UIApplication sharedApplication];
            UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
            if (notifyAlarm)
            {
                notifyAlarm.fireDate = alertTime;
                notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
                notifyAlarm.repeatInterval = 0;
                notifyAlarm.alertBody = @"You've got some new Kapsules!";
                notifyAlarm.applicationIconBadgeNumber = resultData.count;
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:resultData.count];
                NSLog(@"New kapsules:%@", resultData.count);
                [app scheduleLocalNotification:notifyAlarm];
            }
            didNotifyUserOfNewInfo=true;
        }
    }
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Core Location Error: %@", error);
}




/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", error);
    NSLog(@"Err code: %d", [error code]);
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    isAppInBackGround = true;
    didNotifyUserOfNewInfo=false;
    
    [locationManager startMonitoringSignificantLocationChanges];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // [locationManager startMonitoringSignificantLocationChanges];
    if (isAppInBackGround){
        // [self setUpLocationManager];
    }
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
    
    isAppInBackGround = false;
    didNotifyUserOfNewInfo = false;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}


- (void)dealloc {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
