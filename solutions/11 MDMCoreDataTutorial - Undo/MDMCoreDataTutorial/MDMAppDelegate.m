//
//  MDMAppDelegate.m
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 2/28/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import "MDMAppDelegate.h"
#import "MDMViewController.h"
#import "MDMCoreDataFatalErrorAlertView.h"

@import CoreData;

@interface MDMAppDelegate ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MDMCoreDataFatalErrorAlertView *fatalAlertView;

@end

@implementation MDMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    MDMViewController *rootViewController = [((UINavigationController *)self.window.rootViewController).viewControllers firstObject];
    rootViewController.managedObjectContext = self.managedObjectContext;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (_managedObjectContext == nil) {
        
        NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:@[[NSBundle mainBundle]]];
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        NSURL *persistentStoreURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                             inDomains:NSUserDomainMask] lastObject]
                                     URLByAppendingPathComponent:@"Database.sqlite"];
        
        NSError *error;
        NSPersistentStore *persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                      configuration:nil
                                                                                                URL:persistentStoreURL
                                                                                            options:nil
                                                                                              error:&error];
        
        if (persistentStore == nil) {
            
            NSAssert(NO, @"Error: %@", [error localizedDescription]);
            [self showAlert];
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        _managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
    
    return _managedObjectContext;
}

#pragma mark - UIAlertView

- (void)showAlert {
    
    [self.fatalAlertView showAlert];
}

- (MDMCoreDataFatalErrorAlertView *)fatalAlertView {
    
    if (_fatalAlertView == nil) {
        _fatalAlertView = [[MDMCoreDataFatalErrorAlertView alloc] init];
    }
    
    return _fatalAlertView;
}

@end
