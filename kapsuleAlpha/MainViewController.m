//
//  ViewController.m
//  empty-dusk-ios-alpha
//
//  Created by Letourneau, Jason B. on 1/29/13.
//  Copyright (c) 2013 Letourneau, Jason B. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>



@interface MainViewController ()

@end



@implementation MainViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

-(void)showKapsulePage{
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    NSLog(@"@%",[NSString stringWithFormat:@"http://kapsuleapp.com/kapsule_messages.mobile?auth_token=%@",[appDelegate kapsule_token]]);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kapsuleapp.com/kapsule_messages.mobile?auth_token=%@",[appDelegate kapsule_token]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate showLoginView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    tools.barStyle = -1; // clear background
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Create a standard refresh button.
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(showKapsulePage)];
    [buttons addObject:bi];
    
    
    // Create a spacer.
    bi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    bi.width = 12.0f;
    [buttons addObject:bi];
    
    
    // Add profile button.
    bi = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:appDelegate action:@selector(doFacebookLogin)];
    bi.style = UIBarButtonItemStyleBordered;
    [buttons addObject:bi];
    
    
    // Add buttons to toolbar and toolbar to nav bar.
    [tools setItems:buttons animated:NO];
    
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    
    self.navigationItem.rightBarButtonItem = twoButtons;
    
}


@end
