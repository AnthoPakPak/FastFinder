//
//  ViewController.m
//  FastFinder
//
//  Created by Anthonin Cocagne on 30/11/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <MASShortcut/Shortcut.h>
#import "UserSettingsHelper.h"


@interface ViewController () {
    
}

@property(strong) IBOutlet MASShortcutView *customShortcutView;
@property (weak) IBOutlet NSButton *launchAtStartupCheckbox;
@property (weak) IBOutlet NSButton *animatedCheckbox;
@property (weak) IBOutlet NSSlider *animationVelocitySlider;
@property (weak) IBOutlet NSTextField *animationVelocityLabel;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.customShortcutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    self.customShortcutView.shortcutValidator.allowAnyShortcutWithOptionModifier = YES; //allow alt key
    // Do any additional setup after loading the view.

    [self restoreSettingsStates];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


#pragma mark - Settings

-(void) restoreSettingsStates {
    _launchAtStartupCheckbox.state = [UserSettingsHelper getInstance].launchOnStartup;
    _animatedCheckbox.state = [UserSettingsHelper getInstance].animated;
    _animationVelocitySlider.doubleValue = [UserSettingsHelper getInstance].animationVelocity;
    [self didChangeAnimationVelocity:_animationVelocitySlider];
}


- (IBAction)didChangeLaunchOnStartup:(NSButton*)button {
    NSLog(@"Setting launchOnStartup to %ld", (long)button.state);

    [UserSettingsHelper getInstance].launchOnStartup = button.state;
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
