//
//  FinderLogicHelper.m
//  FastFinder
//
//  Created by Anthonin Cocagne on 30/11/2018.
//  Copyright © 2018 Anthonin Cocagne. All rights reserved.
//

#import "FinderLogicHelper.h"

#import <ScriptingBridge/ScriptingBridge.h>
#import "Finder.h"

#import "UserSettingsHelper.h"

//CONFIGURATION

//static CGFloat const ANIMATION_SPEED = 0.4; //in seconds

//for first launch
static CGFloat const DEFAULT_FINDER_HEIGHT = 500;
static CGFloat const DEFAULT_FINDER_WIDTH = 1440;


@implementation FinderLogicHelper {
    CGFloat screenHeight;
    
    NSInteger indexOfVisorFinderWindow;
    CGFloat lastFinderHeight;
}


static FinderLogicHelper *instance = nil;

+(FinderLogicHelper*)getInstance {
    @synchronized(self) {
        if(instance==nil) {
            instance = [FinderLogicHelper new];
        }
    }
    return instance;
}

-(void) processFinderLogic {
    // this is the finder
    FinderApplication * finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
    //    finder.launchFlags = kLSLaunchAndHide;
    
    NSLog(@"Frontmost : %hhd | Visible : %hhd", finder.frontmost, finder.visible);
    
    [self show:!finder.frontmost finder:finder];
}


-(void) show:(BOOL)show finder:(FinderApplication*)finder {
    SBElementArray * finderWindows = finder.FinderWindows;
    FinderWindow *finderWindow = finderWindows[0];
    //    __block CGFloat yAxis;
    
    //    [self cancelTimer]; //si on fait le raccourci plusieurs fois de suite
    //    if (indexOfVisorFinderWindow == 0) {
    //        finderWindow = finderWindows[0];
    //        indexOfVisorFinderWindow = finderWindow.id;
    //    } else {
    //        for (FinderWindow *win in finderWindows) {
    //            NSLog(@"win : %@", win.properties);
    //
    //            if (win.id == indexOfVisorFinderWindow) {
    //                finderWindow = win;
    ////                finderWindow.index = 1;
    //            } else {
    ////                [win setPosition:NSMakePoint(0, 0)];
    //            }
    //        }
    //
    //        if (finderWindow.index != 1) {≤
    //            for (FinderWindow *win in finderWindows) {
    //                win.index = 1;
    //            }
    //            finderWindow.index = 0;
    //        }
    //    }
    
    
    
    
    CGRect screenRect = [[NSScreen mainScreen] frame];
    //    CGFloat screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    CGFloat finderHeight = finderWindow.bounds.size.height;
    NSLog(@"finderHeight : %f", finderHeight);
    
    
    BOOL animated = [UserSettingsHelper getInstance].animated;
    //    CGFloat finderWidth = screenWidth;
    
    
    
    
    //    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //    dispatch_queue_t queue = dispatch_get_main_queue();
    //    double secondsToFire = 0.015;
    
    if (show) {
        NSLog(@"Show finder");
        //                [finder activate];
        [self runCommand:@"open -j -a Finder"]; //activate without moving window when it outside of screen
        finder.visible = YES;
        
        //set size
        //        [finderWindow setBounds:NSMakeRect(0, screenHeight, screenWidth, lastFinderHeight)]; //on set les bounds suivants : {toutAGaucheDeLecran, enDehorsDeLecranEnBas_pourEtreInvisible, tailleEcran, lastFinderHeight)}
        
        
        //        yAxis = screenHeight;
        //
        ////        dispatch_async(dispatch_get_main_queue(), ^{
        //            _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        //                NSLog(@"SHOW :Set position : %f", yAxis);
        //                yAxis -= ANIMATION_SPEED;
        //
        //                [finderWindow setPosition:NSMakePoint(0, yAxis)];
        //
        //                if (yAxis <= screenHeight - lastFinderHeight) {
        //                    [self cancelTimer];
        //                    [finderWindow setPosition:NSMakePoint(0, screenHeight - lastFinderHeight)]; //un dernier coup pour être sur d'arriver au bon endroit
        //                }
        //            });
        ////        });
        
        
        
        //        yAxis = screenHeight;
        //
        //        dispatch_async_repeated(0.01, dispatch_get_main_queue(), ^(BOOL *stop) {
        //            NSLog(@"SHOW :Set position : %f", yAxis);
        //            yAxis -= ANIMATION_SPEED;
        //
        //            [finderWindow setPosition:NSMakePoint(0, yAxis)];
        //
        //            if (yAxis <= screenHeight - lastFinderHeight) {
        //                *stop = YES;
        //                [finderWindow setPosition:NSMakePoint(0, screenHeight - lastFinderHeight)]; //un dernier coup pour être sur d'arriver au bon endroit
        //            }
        //        });
        
        
        //animate position
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //            for (int i = screenHeight; i >= screenHeight - lastFinderHeight; i = i - ANIMATION_SPEED) {
        //                NSLog(@"SHOW :Set position : %d", i);
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [finderWindow setPosition:NSMakePoint(0, i)];
        //                });
        //            }
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [finderWindow setPosition:NSMakePoint(0, screenHeight - lastFinderHeight)]; //un dernier coup pour être sur d'arriver au bon endroit
        //            });
        //        });
        
        
        if (lastFinderHeight == 0) {
            lastFinderHeight = DEFAULT_FINDER_HEIGHT;
            [finderWindow setBounds:NSMakeRect(0, screenHeight, DEFAULT_FINDER_WIDTH, lastFinderHeight)]; //on set les bounds suivants : {toutAGaucheDeLecran, enDehorsDeLecranEnBas_pourEtreInvisible, tailleEcran, lastFinderHeight)}
        }
        
        if (animated) {
            [self animateOffsetWindow:finderWindow directionUp:YES completionHandler:nil];
        }
        
        
        
    } else {
        NSLog(@"Hide finder");
        
        if (finderHeight != 0) {
            lastFinderHeight = finderHeight;
        }
        
        //        yAxis = screenHeight - lastFinderHeight;
        //
        ////        dispatch_async(dispatch_get_main_queue(), ^{
        //            _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        //                NSLog(@"HIDE :Set position : %f", yAxis);
        //                yAxis += ANIMATION_SPEED;
        //
        //                [finderWindow setPosition:NSMakePoint(0, yAxis)];
        //
        //                if (yAxis >= screenHeight) {
        //                    [self cancelTimer];
        //                    finder.visible = NO;
        //                }
        //            });
        ////        });
        
        
        //        yAxis = screenHeight - lastFinderHeight;
        //
        //        dispatch_async_repeated(0.01, dispatch_get_main_queue(), ^(BOOL *stop) {
        //            NSLog(@"HIDE :Set position : %f", yAxis);
        //            yAxis += ANIMATION_SPEED;
        //
        //            [finderWindow setPosition:NSMakePoint(0, yAxis)]; //un dernier coup pour être sur d'arriver au bon endroit
        //
        //            if (yAxis >= screenHeight) {
        //                *stop = YES;
        //
        //                finder.visible = NO;
        //            }
        //        });
        
        //animate position
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //            for (int i = screenHeight - lastFinderHeight; i <= screenHeight; i = i + ANIMATION_SPEED) {
        //                NSLog(@"HIDE : Set position : %d", i);
        //                dispatch_async(dispatch_get_main_queue(), ^{
        //                    [finderWindow setPosition:NSMakePoint(0, i)];
        //                });
        //            }
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                finder.visible = NO;
        //            });
        //        });
        
        
        if (animated) {
            [self animateOffsetWindow:finderWindow directionUp:NO completionHandler:^{
                //si la frontmost window au moment de faire le raccourci prend tout l'ecran (window.bounds == screen.bounds)
                finder.visible = NO; //c'est ceci qui cause le glitch qui est visible quand il n'y a pas d'autre fenetre derriere, car quand on réactive le finder après l'avoir hidden, il restaure position
                
                //si la frontmost window au moment de faire le raccourci NE prend PAS tout l'ecran (window.bounds == screen.bounds)
                //            finder.frontmost = NO;
                //            [finderWindow setPosition:NSMakePoint(1440, 900)];
            }];
        } else {
            finder.visible = NO;
        }
        
    }
}

- (void)animateOffsetWindow:(FinderWindow *)finderWindow directionUp:(BOOL)directionUp completionHandler:(void (^)(void))completionHandler { //direction YES is UP (show)
    NSTimeInterval t;
    NSDate* date = [NSDate date];
    float animationSpeed = [UserSettingsHelper getInstance].animationVelocity;
    BOOL doSlide = YES;
    while (animationSpeed >= (t = -[date timeIntervalSinceNow])) {
        // animation update loop
        float k = t / animationSpeed; //k varie de 0 à 1
        float kAccordingToDirection = directionUp ? 1 - k : k;
        
        if (doSlide) {
            
            NSLog(@"kAccordingToDirection = %f", kAccordingToDirection);
            
            float offset = kAccordingToDirection * lastFinderHeight + (screenHeight - lastFinderHeight);
            NSLog(@"offset = %f", offset);
            //                float offset = SLIDE_DIRECTION(direction, SLIDE_EASING(k));
            //                [self placeWindow:_window offset:offset];
            //                float offset = SLIDE_DIRECTION(NO, SLIDE_EASING(k)) * lastFinderHeight;
            //                NSLog(@"SHOW :Set position : %f", offset);
            [finderWindow setPosition:NSMakePoint(0, offset)];
            
        }
        
        //            usleep(_background ? 1000 : 5000);         // 1 or 5ms
        usleep(3000);
    }
    
    //un dernier coup pour être sur d'être au bon endroit (au final ça ne fonctionne que pour SHOW car quand le finder est en bas, MacOS n'autorise pas sa frame d'aller plus bas que sa status bar)
    float kAccordingToDirection = directionUp ? 0 : 1;
    float offset = kAccordingToDirection * lastFinderHeight + (screenHeight - lastFinderHeight);
    NSLog(@"offset = %f", offset);
    [finderWindow setPosition:NSMakePoint(0, offset)];
    
    
    if (completionHandler)
        completionHandler();
}




#pragma mark - Misc

- (NSString *)runCommand:(NSString *)commandToRun {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/sh"];
    
    NSArray *arguments = [NSArray arrayWithObjects:
                          @"-c" ,
                          [NSString stringWithFormat:@"%@", commandToRun],
                          nil];
    NSLog(@"run command:%@", commandToRun);
    [task setArguments:arguments];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    
    NSString *output = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return output;
}

@end
