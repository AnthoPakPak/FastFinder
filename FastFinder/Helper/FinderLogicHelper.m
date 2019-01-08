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
#import "SystemEvents.h"

#import "UserSettingsHelper.h"

//CONFIGURATION

//for first launch
static CGFloat const DEFAULT_FINDER_HEIGHT = 550;


@implementation FinderLogicHelper {
    FinderApplication * finder;
    
    CGFloat screenHeight;
    CGFloat screenWidth;

    NSInteger idOfMainVisorFinderWindow;
    NSInteger idOfVisorFinderWindow;
    CGFloat lastFinderHeight;
}


static FinderLogicHelper *instance = nil;

+(FinderLogicHelper*)getInstance {
    @synchronized(self) {
        if(instance==nil) {
            instance = [FinderLogicHelper new];
            
            //defaults values
            CGRect screenRect = [[NSScreen mainScreen] frame];
            instance->screenWidth = screenRect.size.width;
            instance->screenHeight = screenRect.size.height;
        }
    }
    return instance;
}

-(void) processFinderLogic {
    finder = [SBApplication applicationWithBundleIdentifier:@"com.apple.Finder"];
//    SystemEventsApplication * systEvt = [SBApplication applicationWithBundleIdentifier:@"com.apple.SystemEvents"]; //to send shortcuts to the app (https://github.com/tcurdt/shellhere/blob/master/main.m#L114)
    
    
    NSLog(@"Frontmost : %hhd | Visible : %hhd", finder.frontmost, finder.visible);
    
    [self show:!finder.frontmost finder:finder];
}


-(void) show:(BOOL)show finder:(FinderApplication*)finder {
    SBElementArray * finderWindows = finder.FinderWindows;
    FinderWindow *finderWindow;
    
//    NSLog(@"finderHeight : %f", finderHeight);
    
    BOOL animated = [UserSettingsHelper getInstance].animated;
    
    
    if (show) {
        NSLog(@"Show finder");
        //[finder activate];
        [self runCommand:@"open -j -a Finder"]; //activate without moving window when it outside of screen
        finder.visible = YES;

        finderWindow = [self getFinderWindowFromWindows:finderWindows]; //it has to be done after finder.visible = YES
        
        //set size on first time
        if (lastFinderHeight == 0) {
            lastFinderHeight = DEFAULT_FINDER_HEIGHT;
            [finderWindow setBounds:NSMakeRect(0, screenHeight, screenWidth, lastFinderHeight)]; //we set following bounds : {toutAGaucheDeLecran, enDehorsDeLecranEnBas_pourEtreInvisible, tailleEcran, lastFinderHeight)}
        }
        
        if (animated) {
            [self animateOffsetWindow:finderWindow directionUp:YES completionHandler:nil];
        }
    } else {
        NSLog(@"Hide finder");
        
        //experimental : reopen last closed window/tab; unfortunately, there is no way to distinguish tabs from window…
        if ([self frontmostWindowIsTabOfMainWindow:finderWindows]) {
            idOfVisorFinderWindow = ((FinderWindow*)finderWindows[0]).id; //show tab of main window
        } else { //frontmost window isn't mainWindow nor a tab of mainWindow
//            ((FinderWindow*)finderWindows[0]).index++;
            for (int i = 0; i < [self getMainWindow:finderWindows].index; i++) {
                ((FinderWindow*)finderWindows[i]).index++; //send all windows which are above mainWindow to back
            }
            [self getMainWindow:finderWindows].index = 1; //send mainWindow to front
            idOfVisorFinderWindow = idOfMainVisorFinderWindow; //restore main window
        }
        
        finderWindow = [self getFinderWindowFromWindows:finderWindows];
        CGFloat finderHeight = finderWindow.bounds.size.height;

        if (finderHeight != 0) {
            lastFinderHeight = finderHeight;
        }
        
        if (animated) {
            [self animateOffsetWindow:finderWindow directionUp:NO completionHandler:^{
                //if the frontmost window (not finder one) at the time of making the shortcut takes the whole screen (window.bounds == screen.bounds)

//                finder.frontmost = NO; //use this to allow working "Show in Finder" but experience is not as well as with finder.visible
                finder.visible = NO; //this is what causes the glitch that is visible when there is no other window behind, because when you reactivate the finder after hiding it, it restores position
                
                //if the frontmost window (not finder one) at the time of making the shortcut does NOT take the whole screen (window.bounds != screen.bounds), but the problem of this version is that the fact of not setting finder visible=NO, causes that if we click manually on Finder dock icon, it stays at its position on bottom…
//                finder.frontmost = NO;
////                finder.visible = NO;
//                [finderWindow setPosition:NSMakePoint(-1440, 900)];
            }];
        } else {
            finder.visible = NO;
        }
    }
}

-(FinderWindow*) getFinderWindowFromWindows:(SBElementArray*)finderWindows {
    FinderWindow *finderWindow = nil;

    if (finderWindows.count > 1) {
        finderWindow = [self getMainWindow:finderWindows];
        finderWindow.index = 1;
    }
    
    if (finderWindow == nil) {
        NSLog(@"Window not found, taking the frontmost one");
        if (finderWindows.count > 0) {
            finderWindow = finderWindows[0];
        } else {
            //Code to open a new Finder window. Currently it doesn't work well so I remove it.
//            NSURL *u = [NSURL fileURLWithPath:@"/tmp"];
//            FinderFinderWindow *w = [[[finder classForScriptingClass:@"Finder window"] alloc] init];
//                                       [[finder FinderWindows] addObject:w];
//                                       [w setTarget:u];

//            [self runCommand:@"osascript -e \"tell application \"Finder\" to make new Finder window\""];
        }
        idOfMainVisorFinderWindow = finderWindow.id;
        idOfVisorFinderWindow = finderWindow.id;
    }
    
//    NSLog(@"Window : id:%ld, name:%@, index:%ld, idOfVisorFinderWindow:%ld", finderWindow.id, finderWindow.name, finderWindow.index, idOfVisorFinderWindow);
    
    //idOfVisorFinderWindow = finderWindow.id;
    return finderWindow;
}


- (void)animateOffsetWindow:(FinderWindow *)finderWindow directionUp:(BOOL)directionUp completionHandler:(void (^)(void))completionHandler {
    NSTimeInterval t;
    NSDate* date = [NSDate date];
    float animationSpeed = [UserSettingsHelper getInstance].animationVelocity;
    
    while (animationSpeed >= (t = -[date timeIntervalSinceNow])) {
        float k = t / animationSpeed; //k varie de 0 à 1
        float kAccordingToDirection = directionUp ? 1 - k : k;
        
//        NSLog(@"kAccordingToDirection = %f", kAccordingToDirection);
        
        float offset = kAccordingToDirection * lastFinderHeight + (screenHeight - lastFinderHeight);
//        NSLog(@"offset = %f", offset);
        [finderWindow setPosition:NSMakePoint(0, offset)];
        
        usleep(3000);
    }
    
    //a last move to be sure to be on the right place (in the end it only works for SHOW because when the finder is down, MacOS does not allow its frame to go lower than its status bar)
    float kAccordingToDirection = directionUp ? 0 : 1;
    float offset = kAccordingToDirection * lastFinderHeight + (screenHeight - lastFinderHeight);
    NSLog(@"offset = %f", offset);
    [finderWindow setPosition:NSMakePoint(0, offset)];
    
    
    if (completionHandler)
        completionHandler();
}


-(FinderWindow*) getMainWindow:(SBElementArray*)finderWindows {
    FinderWindow *mainWindow;
    for (FinderWindow *finderWin in finderWindows) {
        //NSLog(@"win : %@", finderWin.properties); //this can cause glitch…
        
        if (finderWin.id == idOfVisorFinderWindow) {
            mainWindow = finderWin;
            break;
        }
    }
    
    //don't really know why i have to do this a second time, but without this it doesn't work
    if (mainWindow.id != idOfVisorFinderWindow) {
        NSLog(@"Window isn't the good one, searching for the good one…");
        for (FinderWindow *finderWin in finderWindows) {
            if (finderWin.id == idOfVisorFinderWindow) {
                NSLog(@"Window finally found !");
                mainWindow = finderWin;
                break;
            }
        }
    }
    
    return mainWindow;
}

-(BOOL) frontmostWindowIsTabOfMainWindow:(SBElementArray*)finderWindows {
    FinderWindow *frontmostWindow = (FinderWindow*)finderWindows[0];
    FinderWindow *mainWindow = [self getMainWindow:finderWindows];
    
    if (CGRectEqualToRect(frontmostWindow.bounds, mainWindow.bounds) && CGPointEqualToPoint(frontmostWindow.position, mainWindow.position)) {
        return YES;
    }
    
    return NO;
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
