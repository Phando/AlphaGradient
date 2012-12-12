//
//  ViewController.m
//  AlphaGradient
//
//  Created by Joe Andolina on 10/19/12.
//  Copyright (c) 2012 Joe Andolina. All rights reserved.
//

#import "ViewController.h"
#import "AlphaGradientView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AlphaGradientView* gradient = [[AlphaGradientView alloc] initWithFrame:
                                   CGRectMake( 0, 250, self.view.frame.size.width, 50)];
    
    [self.view addSubview:gradient];

    gradient = [[AlphaGradientView alloc] initWithFrame:
                                   CGRectMake( 0, 200, self.view.frame.size.width, 50)];
    
    gradient.direction = GRADIENT_DOWN;
    [self.view addSubview:gradient];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
