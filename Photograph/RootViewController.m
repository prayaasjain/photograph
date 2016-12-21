//
//  RootViewController.m
//  Photograph
//
//  Created by Prayaas Jain on 10/25/16.
//  Copyright © 2016 Prayaas Jain. All rights reserved.
//

#import "RootViewController.h"
#import "HomeFeedViewController.h"
#import "UserProfileViewController.h"
#import "DataManager.h"

typedef enum: NSInteger {
    HomeFeedView = 0,
    ProfileView
} viewTags;

@interface RootViewController () <UITabBarControllerDelegate> {
    HomeFeedViewController *homeFeedVc;
    UserProfileViewController *userProfileVc;
}

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    //hard-coding tag for fetching data
    [[DataManager getInstance] fetchTagBasedDataForTag:@"gameofthrones"];
    [[DataManager getInstance] fetchCurrentUserProfile];

    [self setUpNavigationController];
    [self setupTabBarController];
}

- (void)setUpNavigationController {
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor photographBackgroundColor];
    [self.navigationItem setTitle:@"Photograph"];
}

- (void)setupTabBarController {
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    [self.tabBarController.view setBackgroundColor:[UIColor clearColor]];

    [[UITabBar appearance] setBarTintColor:[UIColor photographBackgroundColor]];
    [[UITabBar appearance] setTranslucent:NO];

    homeFeedVc = [[HomeFeedViewController alloc] init];
    homeFeedVc.tableData = [[DataManager getInstance] getFetchedTagBasedDataItems];
    homeFeedVc.view.tag = HomeFeedView;

    UIImage *homeImage = [UIImage imageNamed:@"homeUnselected"];
    UIImage *homeImageSelected = [UIImage imageNamed:@"homeSelected"];
    homeImage = [homeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeImageSelected = [homeImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeFeedVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:homeImage selectedImage:homeImageSelected];
    homeFeedVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    homeFeedVc.tabBarItem.tag = 111;

    userProfileVc = [[UserProfileViewController alloc] init];
    userProfileVc.user = [[DataManager getInstance] getFetchedUserProfileData];
    userProfileVc.view.tag = ProfileView;

    UIImage *userImage = [UIImage imageNamed:@"userUnselected"];
    UIImage *userImageSelected = [UIImage imageNamed:@"userSelected"];
    userImage = [userImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userImageSelected = [userImageSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userProfileVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:userImage selectedImage:userImageSelected];
    userProfileVc.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    userProfileVc.tabBarItem.tag = 222;

    NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  homeFeedVc,
                                  userProfileVc, nil];

    [self.tabBarController setViewControllers:myViewControllers animated:YES];
    [self.tabBarController setSelectedIndex:0];

    [self.view addSubview:self.tabBarController.view];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    switch (viewController.view.tag) {
        case HomeFeedView:
            [self.navigationItem setTitle:@"Photograph"];
            break;

        case ProfileView:
            [self.navigationItem setTitle:userProfileVc.user.username];
            break;

        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
