//
//  SQFirebaseHelper.h
//  Squashmag
//
//  Created by Abbin Varghese on 31/05/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"
#import "Article+CoreDataProperties.h"
@import Firebase;

FOUNDATION_EXPORT NSString *const articleImageUrl;
FOUNDATION_EXPORT NSString *const articleHeading;
FOUNDATION_EXPORT NSString *const articleWebsite;
FOUNDATION_EXPORT NSString *const articleAuthor;
FOUNDATION_EXPORT NSString *const articleTimeStamp;
FOUNDATION_EXPORT NSString *const articlePath;
FOUNDATION_EXPORT NSString *const articleUID;

@interface SQFirebaseHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *tmpContext;

+ (SQFirebaseHelper*)sharedHelper;

-(void)startListeningToBDChanges:(void (^)(NSArray *modifiedArray))success;

+(void)uploadArticleWithHeading:(NSString*)heading
                         author:(NSString*)author
                          image:(UIImage*)image
                        website:(NSString*)website
                        success:(void (^)(BOOL success, NSError *error))success;

@end
