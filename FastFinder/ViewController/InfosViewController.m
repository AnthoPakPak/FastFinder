//
//  InfosViewController.m
//  FastFinder
//
//  Created by Anthonin Cocagne on 01/12/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import "InfosViewController.h"

@interface InfosViewController ()

@property (weak) IBOutlet NSTextField *versionNumberLabel;

@end

@implementation InfosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVersionNumber];
}

-(void) setVersionNumber {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDict objectForKey:@"CFBundleShortVersionString"]; // example: 1.0.0
    _versionNumberLabel.stringValue = appVersion;
}

@end
