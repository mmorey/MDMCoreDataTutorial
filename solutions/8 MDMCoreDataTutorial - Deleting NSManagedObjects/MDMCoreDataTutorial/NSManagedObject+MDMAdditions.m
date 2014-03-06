//
//  NSManagedObject+MDMAdditions.m
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 3/4/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import "NSManagedObject+MDMAdditions.h"

@implementation NSManagedObject (MDMAdditions)

+ (NSString *)MDMCoreDataAdditionsEntityName {
    
    return NSStringFromClass(self);
}

+ (instancetype)MDMCoreDataAdditionsInsertNewObjectIntoContext:(NSManagedObjectContext *)context {
    
    return [NSEntityDescription insertNewObjectForEntityForName:[self MDMCoreDataAdditionsEntityName]
                                         inManagedObjectContext:context];
}

@end
