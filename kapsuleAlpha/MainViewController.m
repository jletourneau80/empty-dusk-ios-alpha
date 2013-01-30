//
//  ViewController.m
//  empty-dusk-ios-alpha
//
//  Created by Letourneau, Jason B. on 1/29/13.
//  Copyright (c) 2013 Letourneau, Jason B. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end



@implementation MainViewController

@synthesize webView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //todo: send browser to the login page with creds...what is this?
    NSURL *url = [NSURL URLWithString:@"http://empty-dusk-3091.herokuapp.com"];
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
