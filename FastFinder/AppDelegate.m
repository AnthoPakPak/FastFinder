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
    //no dock icon
    [NSApp windows][0].canHide = NO;
    [NSApp setActivationPolicy: NSApplicationActivationPolicyAccessory];

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
