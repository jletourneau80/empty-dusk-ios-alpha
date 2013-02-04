//
//  LoginViewController.h
//  empty-dusk-ios-alpha
//
//  Created by Letourneau, Jason B. on 1/29/13.
//  Copyright (c) 2013 Letourneau, Jason B. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *StatusLabel;

- (IBAction)performLogin:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
- (void)loginFailed;
@end
