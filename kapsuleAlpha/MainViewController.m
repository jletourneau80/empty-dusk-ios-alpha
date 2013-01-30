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
    
    NSLog(@"@%",[NSString stringWithFormat:@"http://empty-dusk-3091.herokuapp.com/kapsule_messages.mobile?auth_token=%@",[appDelegate kapsule_token]]);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://empty-dusk-3091.herokuapp.com/kapsule_messages.mobile?auth_token=%@",[appDelegate kapsule_token]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
