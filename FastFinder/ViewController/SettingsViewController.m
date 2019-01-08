//
//  ViewController.m
//  FastFinder
//
//  Created by Anthonin Cocagne on 30/11/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import <MASShortcut/Shortcut.h>
#import "UserSettingsHelper.h"


@interface SettingsViewController () {
    
}

@property (strong) IBOutlet MASShortcutView *customShortcutView;
@property (weak) IBOutlet NSButton *launchAtStartupCheckbox;
@property (weak) IBOutlet NSButton *animatedCheckbox;
@property (weak) IBOutlet NSSlider *animationVelocitySlider;
@property (weak) IBOutlet NSTextField *animationVelocityLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _customShortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    _customShortcutView.shortcutValidator.allowAnyShortcutWithOptionModifier = YES; //allow alt key

    [self setDefaultsSettingsIfNeeded];
    [self restoreSettingsStates];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - Settings

-(void) setDefaultsSettingsIfNeeded {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLaunch = ![defaults boolForKey:@"appAlreadyLaunched"];
    if (isFirstLaunch) {
        [defaults setBool:YES forKey:@"appAlreadyLaunched"];
        [[UserSettingsHelper getInstance] setDefaultsSettings];
        
        //show Spaces settings on first launch
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"useWithSpacesSegue" sender:self];
        });
    }
}

-(void) restoreSettingsStates {
    _launchAtStartupCheckbox.state = [UserSettingsHelper getInstance].launchOnStartup;
    _animatedCheckbox.state = [UserSettingsHelper getInstance].animated;
    _animationVelocitySlider.doubleValue = [UserSettingsHelper getInstance].animationVelocity;
    [self didChangeAnimationVelocity:_animationVelocitySlider];
}


#pragma mark Outlets changes

- (IBAction)didChangeLaunchOnStartup:(NSButton*)button {
    NSLog(@"Setting launchOnStartup to %ld", (long)button.state);

    //[UserSettingsHelper getInstance].launchOnStartup = button.state;
    
    NSAlert *alert = [NSAlert new];
    [alert setMessageText:@"⚠️ Feature not available currently"];
    [alert setInformativeText:@"Sorry, launch at startup isn't supported for now.\n\nFor now, please do it manually by going to System Preferences > Users and groups > Login Items and adding FastFinder there.\n\nThe feature will be available when I'll have time to implement it, or if you have some free time, feel free to make a PR on https://github.com/AnthoPakPak/FastFinder 😉"];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
    
    button.state = NSControlStateValueOff;
}

- (IBAction)didChangeAnimated:(NSButton*)button {
    NSLog(@"Setting animated to %ld", (long)button.state);

    [UserSettingsHelper getInstance].animated = button.state;
}

- (IBAction)didChangeAnimationVelocity:(NSSlider*)slider {
    NSLog(@"Setting animation velocity to %f", slider.doubleValue);
    
    [UserSettingsHelper getInstance].animationVelocity = slider.doubleValue;
    _animationVelocityLabel.stringValue = [NSString stringWithFormat:@"%.1f seconds", slider.doubleValue];
}

@end
