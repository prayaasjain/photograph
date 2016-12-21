//
//  LoginViewController.m
//  Photograph
//
//  Created by Prayaas Jain on 10/24/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "LoginViewController.h"
#import "RootViewController.h"
#import "DataManager.h"
#import "TagBasedDataFetcher.h"

@interface LoginViewController () <UIWebViewDelegate> {
    BOOL didRetrieveToken;
}

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *originalUrl;
@property (nonatomic, assign) BOOL validatedRequest;

@end

//client ID, client secret and redirect URI from Instagram Developer Registration
static NSString *clientID = @"9f498c17e1a3426a98c695cfea9b4335";
static NSString *clientSecret = @"7c1a4fc907084190b25729ef134c7405";

//using this as a redirect URI to retrieve oauth token
static NSString *redirectURI = @"https://bobmckay.com/";

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    didRetrieveToken = FALSE;
    [self setUpNavigationController];
    [self setupMainView];
}

#pragma mark - UI Setup Methods
- (void)setUpNavigationController {
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationItem setTitle:@"Photograph"];
}

-  (void)setupMainView {
    self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.welcomeLabel setTextColor:[UIColor blackColor]];
    [self.welcomeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.welcomeLabel setFont:[UIFont fontWithName:AppFont_SF_UI_Display_Regular size:50]];
    [self.welcomeLabel setNumberOfLines:0];
    [self.welcomeLabel sizeToFit];
    self.welcomeLabel.text = @"Welcome!";
    self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.welcomeLabel.adjustsFontSizeToFitWidth = NO;

    self.loginButton = [[HollowButton alloc] init];
    [self.loginButton addTarget:self
                               action:@selector(loginButtonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@"Login with Instagram" forState:UIControlStateNormal];
    [self.loginButton setEnabled:YES];
    self.loginButton.translatesAutoresizingMaskIntoConstraints = NO;

    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.webView setDelegate:self];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    [self.webView setHidden:NO];
    [self.webView setAlpha:0.0];
    [self.webView setScalesPageToFit:YES];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.welcomeLabel];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.webView];

    [self setupConstraintsForMainView];
}

- (void)setupConstraintsForMainView {
    NSLayoutConstraint *welcomeLabelCenterXConstraint = [NSLayoutConstraint
                                                              constraintWithItem:self.welcomeLabel attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *welcomeLabelCenterYConstraint = [NSLayoutConstraint
                                                              constraintWithItem:self.welcomeLabel attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY multiplier:0.75 constant:0];

    NSLayoutConstraint *loginButtonButtonCenterXConstraint = [NSLayoutConstraint
                                                              constraintWithItem:self.loginButton attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *loginButtonButtonCenterYConstraint = [NSLayoutConstraint
                                                              constraintWithItem:self.loginButton attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY multiplier:1.05 constant:0];

    NSLayoutConstraint *loginButtonButtonHeightConstraint = [NSLayoutConstraint
                                                             constraintWithItem:self.loginButton attribute:NSLayoutAttributeHeight
                                                             relatedBy:NSLayoutRelationEqual toItem:self.view
                                                             attribute:NSLayoutAttributeHeight multiplier:0.075 constant:0];
    NSLayoutConstraint *loginButtonButtonWidthConstraint = [NSLayoutConstraint
                                                            constraintWithItem:self.loginButton attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual toItem:self.view
                                                            attribute:NSLayoutAttributeWidth multiplier:0.55 constant:0];

    NSLayoutConstraint *webViewCenterXConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.webView attribute:NSLayoutAttributeCenterX
                                                    relatedBy:NSLayoutRelationEqual toItem:self.view
                                                    attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *webViewCenterYConstraint = [NSLayoutConstraint
                                                    constraintWithItem:self.webView attribute:NSLayoutAttributeCenterY
                                                    relatedBy:NSLayoutRelationEqual toItem:self.view
                                                    attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    NSLayoutConstraint *webViewHeightConstraint = [NSLayoutConstraint
                                                   constraintWithItem:self.webView attribute:NSLayoutAttributeHeight
                                                   relatedBy:NSLayoutRelationEqual toItem:self.view
                                                   attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *webViewWidthConstraint = [NSLayoutConstraint
                                                  constraintWithItem:self.webView attribute:NSLayoutAttributeWidth
                                                  relatedBy:NSLayoutRelationEqual toItem:self.view
                                                  attribute:NSLayoutAttributeWidth multiplier:1 constant:0];

    [self.view addConstraints:@[welcomeLabelCenterXConstraint, welcomeLabelCenterYConstraint,
                                loginButtonButtonCenterXConstraint, loginButtonButtonCenterYConstraint, loginButtonButtonHeightConstraint, loginButtonButtonWidthConstraint,
                                webViewCenterXConstraint, webViewCenterYConstraint, webViewHeightConstraint, webViewWidthConstraint]];
}

- (void)showWebPage {
    [UIView animateWithDuration:0.5
                     animations:^(void) {
                         [self.webView setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [self.loginButton setHidden:YES];
                     }];
}

- (void)hideWebPage {
    [UIView animateWithDuration:0.5
                     animations:^(void) {
                         [self.webView setAlpha:0.0];
                     }
                     completion:^(BOOL finished){
                         [self.webView setHidden:YES];
                     }];

    [self presentRootViewController];
}

- (void)presentRootViewController {
    RootViewController *rootVc = [[RootViewController alloc] init];
    [self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.navigationController pushViewController:rootVc animated:YES];
}

#pragma mark - UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"attmpting to load web view");
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    self.validatedRequest = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error in loading webview = %@", error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(self.validatedRequest) {
        return YES;
    }
    self.originalUrl = request.URL;
    [NSURLConnection connectionWithRequest:request delegate:self];
    return NO;
}

#pragma mark - NSURLConnectionDataDelegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Original request: %@ \nOriginal response: %@", self.originalUrl.absoluteString, response.URL.absoluteString);
    NSString *responseUrlHostName = response.URL.host;

    //extracting token from authentication response
    if ([responseUrlHostName isEqualToString:@"bobmckay.com"] && !didRetrieveToken) {
        NSArray *responseParts = [response.URL.absoluteString componentsSeparatedByString:@"https://bobmckay.com/#access_token="];
        self.token = responseParts[1];
        didRetrieveToken = TRUE;
        [self initDataManager];
        [self hideWebPage];
        [connection cancel];
        return;
    }

    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        NSLog(@"Response header: %@", response);

        if (statusCode < 200 || statusCode >= 300) {
            //TODO: Handle error in loading page
            NSLog(@"Request to %@ failed with statusCode = %ld", response.URL.absoluteString, (long)statusCode);
        }
        else {
            self.validatedRequest = YES;
            [self.webView loadRequest:connection.originalRequest];
        }
    }
    [connection cancel];
}

#pragma mark - NSURLConnectionDelegate Methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Error in connection = %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Success in establishing connection %@", connection);
}

#pragma mark - Helper Methods
- (void)initDataManager {
    [[DataManager getInstance] setAccessToken:self.token];
}

#pragma mark - UIButtonPressed Methods
- (IBAction)loginButtonPressed:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token&scope=public_content+likes+comments", clientID, redirectURI];
    self.originalUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.originalUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10.0];
    [NSURLConnection connectionWithRequest:request delegate:self];

    [self.webView loadRequest:request];
    [self showWebPage];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
