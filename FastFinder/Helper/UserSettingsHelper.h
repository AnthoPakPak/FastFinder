//
//  UserSettingsHelper.h
//  FastFinder
//
//  Created by Anthonin Cocagne on 30/11/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserSettingsHelper : NSObject

@property(nonatomic) BOOL launchOnStartup;
@property(nonatomic) BOOL animated;
@property(nonatomic) double animationVelocity;

+(UserSettingsHelper*)getInstance;
-(void) setDefaultsSettings;

@end

NS_ASSUME_NONNULL_END
