//
//  UserSettingsHelper.m
//  FastFinder
//
//  Created by Anthonin Cocagne on 30/11/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import "UserSettingsHelper.h"
#import <ServiceManagement/ServiceManagement.h>

static NSString *const kSettingsLaunchOnStartup = @"settings_launchOnStartup";
static NSString *const kSettingsAnimated = @"settings_animated";
static NSString *const kSettingsAnimationVelocity = @"settings_animationVelocity";

@implementation UserSettingsHelper

static UserSettingsHelper *instance = nil;

+(UserSettingsHelper*)getInstance {
    @synchronized(self) {
        if(instance==nil) {
            instance = [UserSettingsHelper new];
            [instance restoreSettings];
        }
    }
    return instance;
}

-(void) setDefaultsSettings {
    self.launchOnStartup = NO; //should be YES but currently feature isn't working so I disable it
    self.animated = YES;
    self.animationVelocity = 0.4;
}

-(void) restoreSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _launchOnStartup = [defaults boolForKey:kSettingsLaunchOnStartup];
    _animated = [defaults boolForKey:kSettingsAnimated];
    _animationVelocity = [defaults doubleForKey:kSettingsAnimationVelocity];
}


#pragma mark - Setters

-(void) setLaunchOnStartup:(BOOL)launchOnStartup {
    if (_launchOnStartup != launchOnStartup) {
        _launchOnStartup = launchOnStartup;
        [[NSUserDefaults standardUserDefaults] setBool:launchOnStartup forKey:kSettingsLaunchOnStartup];
        
        //has to be fixed with : https://theswiftdev.com/2017/10/27/how-to-launch-a-macos-app-at-login/ . for now, please add it manually to login items in System Preferences
        SMLoginItemSetEnabled ((__bridge CFStringRef)@"com.acocagne.FastFinder", launchOnStartup); // NO to cancel launch at login
    }
}

-(void) setAnimated:(BOOL)animated {
    if (_animated != animated) {
        _animated = animated;
        [[NSUserDefaults standardUserDefaults] setBool:animated forKey:kSettingsAnimated];
    }
}

-(void) setAnimationVelocity:(double)animationVelocity {
    if (_animationVelocity != animationVelocity) {
        _animationVelocity = animationVelocity;
        [[NSUserDefaults standardUserDefaults] setDouble:animationVelocity forKey:kSettingsAnimationVelocity];
    }
}

@end
