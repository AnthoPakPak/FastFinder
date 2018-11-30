//
//  AppDelegate.m
//  FastFinder
//
//  Created by Anthonin Cocagne on 30/11/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import "AppDelegate.h"
#import <MASShortcut/Shortcut.h>
#import "FinderLogicHelper.h"
#import <ServiceManagement/ServiceManagement.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//    NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
//    BOOL accessibilityEnabled = AXIsProcessTrustedWithOptions((CFDictionaryRef)options);
//
//    NSLog(@"%hhd", accessibilityEnabled);

    [[MASShortcutBinder sharedBinder]
     bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut
     toAction:^{
         [[FinderLogicHelper getInstance] processFinderLogic];
     }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
