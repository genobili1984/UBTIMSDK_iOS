//
//  UBTViewController.m
//  UBTIMSDK_iOS
//
//  Created by aimin.zha on 03/26/2019.
//  Copyright (c) 2019 aimin.zha. All rights reserved.
//

#import "UBTViewController.h"
#import <UBTIMSDK_iOS/UBTIMSDK.h>
#import <UBTIMSDK_iOS/UBTIMMessage.h>

@interface UBTViewController ()

@end

@implementation UBTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [GPIMMessageManager sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
