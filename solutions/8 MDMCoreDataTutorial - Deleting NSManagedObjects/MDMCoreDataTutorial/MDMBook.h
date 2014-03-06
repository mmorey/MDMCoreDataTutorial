//
//  MDMBook.h
//  MDMCoreDataTutorial
//
//  Created by Matthew Morey on 3/4/14.
//  Copyright (c) 2014 Matthew Morey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MDMAuthor;

@interface MDMBook : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) MDMAuthor *author;

@end
