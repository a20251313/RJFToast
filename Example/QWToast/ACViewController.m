//
//  ACViewController.m
//  QWToast
//
//  Created by ranjingfu on 01/14/2016.
//  Copyright (c) 2016 ranjingfu. All rights reserved.
//

#import "ACViewController.h"
#import "ACNavBarDrawer.h"

@interface ACViewController ()

@end

@implementation ACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIButton  *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 64, 190, 45)];
    [button setTitle:@"Toast" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showToast:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
 
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)showToast:(id)sender
{
    ACNavBarDrawer *_toast = [[ACNavBarDrawer alloc] initWithView:self.view];
    [_toast showToastWithType:QWToastError
                       button:DrawerBtnRefresh
                        Title:@"哈哈哈"
                    subString:@"nihao"
                    errorCode:4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
