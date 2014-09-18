//
//  ViewController.m
//  Safari
//
//  Created by Alex Hudson on 9/16/14.
//  Copyright (c) 2014 Alex Hudson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate, UIWebViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
@property (strong, nonatomic) NSString * currentURLString;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *fowardButton;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.urlTextField.delegate = self;
    [self loadURl:@"http://www.google.com"];
}

-(void)loadURl:(NSString *)url
{
    NSURL * URL = [NSURL URLWithString:url];
    NSURLRequest *urlRequest =  [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:urlRequest];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ( [textField.text hasPrefix:@"http://"]){
        [self loadURl:textField.text];
        [textField resignFirstResponder];
    }
    else {
        [self loadURl:[NSString stringWithFormat:@"http://www.%@", textField.text]];

        [textField resignFirstResponder];

    }
    self.currentURLString = textField.text;
    return YES;
}
#pragma mark - navigation buttons

//These buttons help the user navigate through the webpages

- (IBAction)onBackButtonPressed:(id)sender {

    [self.webView goBack];

}
- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {

    [self.webView stopLoading];
}
- (IBAction)onReloadButtonPressed:(id)sender {

    [self.webView reload];
}

- (IBAction)commingSoonButtonPressed:(id)sender {

    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.delegate = self;
    alertView.title = @"Comming Soon";
    [alertView addButtonWithTitle:@"Home"];
    [alertView show];
}

#pragma mark - Scroll View Delegate Methods


//brings up url field when user scroll to the top of a webpage
//and removes the field when the user scrolls down to the bottom
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y > 1.0){

            [UIView animateWithDuration:1.0f delay:0.0f options:0 animations:^{
                self.urlTextField.alpha = 0;
            } completion:nil];

            NSLog(@"Bottom Reached");

    }
    if(scrollView.contentOffset.y <= 0.0){

        [UIView animateWithDuration:1.0f delay:0.0f options:0 animations:^{
            self.urlTextField.alpha = 1;

        } completion:nil];
        NSLog(@"Top Reached");
    }
}


#pragma mark - webView delgate Methods

-(void)webViewDidStartLoad:(UIWebView *)webView{

    NSLog(@"Loading");

    self.backButton.enabled = self.webView.canGoBack;
    self.fowardButton.enabled = self.webView.canGoForward;
}

//checking to see if back and foward butttons will be enabled when the webview finishes loading
-(void) webViewDidFinishLoad:(UIWebView *)webView{

    NSLog(@"Loaded");

    self.backButton.enabled = self.webView.canGoBack;
    self.fowardButton.enabled = self.webView.canGoForward;
    self.urlTextField.text = self.currentURLString;
    
}

#pragma mark - alert delaget methods
//This alert is called when the user enters a URL in the textView that is not a valid domain name

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.delegate = self;
    alertView.title = @"Invalid Domain Name";
    alertView.message = error.localizedDescription;
    [alertView addButtonWithTitle:@"Retry"];
    [alertView addButtonWithTitle:@"Google"];
    [alertView show];
}


//Sets  an alertvViews button to Google.com and gives generic message
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {

        [self loadURl:@"http://google.com"];
         self.currentURLString = @"http://google.com";
    } else{
        self.urlTextField.alpha = 1;
    }
}

@end
