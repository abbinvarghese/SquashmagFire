//
//  SQFirebaseHelper.m
//  Squashmag
//
//  Created by Abbin Varghese on 31/05/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "SQFirebaseHelper.h"
#import "AppDelegate.h"

NSString *const articleImageUrl = @"articleImageUrl";
NSString *const articleHeading = @"articleHeading";
NSString *const articleAuthor = @"articleAuthor";
NSString *const articleTimeStamp = @"articleTimestamp";
NSString *const articlePath = @"Articles";
NSString *const articleWebsite = @"articleWebsite";
NSString *const articleUID = @"articleuUID";

@implementation SQFirebaseHelper

+ (SQFirebaseHelper*)sharedHelper {
    static SQFirebaseHelper *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.managedObjectContext = appDelegate.managedObjectContext;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark-
#pragma mark Class Methods

+ (NSString *)uuid{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

+(void)uploadArticleWithHeading:(NSString*)heading
                         author:(NSString*)author
                          image:(UIImage*)image
                        website:(NSString*)website
                        success:(void (^)(BOOL success, NSError *error))success{

    if (success == nil) {
        success = ^(BOOL success, NSError *error){};
    }
    
    if (image == nil) {
        success(NO,nil);
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"MM"];
    NSString *myMonthString = [df stringFromDate:[NSDate date]];
    
    [df setDateFormat:@"yyyy"];
    NSString *myYearString = [df stringFromDate:[NSDate date]];
    
    FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"gs://project-3738433765744964420.appspot.com/article_images/%@%@/%@.jpg",myYearString,myMonthString,[self uuid]]];
    
    [storageRef putData:UIImageJPEGRepresentation(image, 0.5) metadata:nil completion:^(FIRStorageMetadata *metadata, NSError *error) {
        if (!error) {
            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%@",metadata.downloadURL],articleImageUrl,
                                  heading,articleHeading,
                                  author,articleAuthor,
                                  [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]],articleTimeStamp,
                                  website,articleWebsite,
                                  [self uuid], articleUID, nil];
            [[[ref child:articlePath] childByAutoId] setValue:dict];
            success(YES,nil);
        }
        else{
            success(NO,error);
        }
    }];
}

-(void)startListeningToBDChanges:(void (^)(NSArray *modifiedArray))success{
    
    FIRDatabaseQuery *recentPostsQuery = [[[[FIRDatabase database] reference] child:articlePath] queryLimitedToLast:100];
    [recentPostsQuery keepSynced:YES];
    
    [recentPostsQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        dispatch_async(queue, ^{
        
            _tmpContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            _tmpContext.persistentStoreCoordinator = self.managedObjectContext.persistentStoreCoordinator;
            
            NSArray *array = [snapshot.value allObjects];
            NSMutableArray *newArray = [NSMutableArray array];
            
            for (NSDictionary *dict in array) {
                Article *newArt = [NSEntityDescription insertNewObjectForEntityForName:articlePath inManagedObjectContext:_tmpContext];
                @try {
                    newArt.articleAuthor = [dict valueForKey:articleAuthor];
                } @catch (NSException *exception) {
                    newArt.articleAuthor = @"";
                    NSLog(@"author exception");
                }
                @try {
                    newArt.articleHeading = [dict valueForKey:articleHeading];
                } @catch (NSException *exception) {
                    newArt.articleHeading = @"";
                    NSLog(@"heading exception");
                }
                @try {
                    newArt.articleImageUrl = [dict valueForKey:articleImageUrl];
                } @catch (NSException *exception) {
                    newArt.articleImageUrl = @"";
                    NSLog(@"imageurl exception");
                }
                @try {
                    newArt.articleTimestamp = [NSNumber numberWithDouble:[[dict valueForKey:articleTimeStamp] doubleValue]];
                } @catch (NSException *exception) {
                    newArt.articleTimestamp = 0;
                    NSLog(@"timestamp exception");
                }
                @try {
                    newArt.articleuUID = [dict valueForKey:articleUID];
                } @catch (NSException *exception) {
                    newArt.articleuUID = @"";
                    NSLog(@"uID exception");
                }
                @try {
                    newArt.articleWebsite = [dict valueForKey:articleWebsite];
                } @catch (NSException *exception) {
                    newArt.articleWebsite = @"";
                    NSLog(@"website exception");
                }
                
                [newArray addObject:newArt];
                
            }
            
            success(newArray);
            
        });
    }];
}

- (void)_mocDidSaveNotification:(NSNotification *)notification
{
    NSManagedObjectContext *savedContext = [notification object];
    
    // ignore change notifications for the main MOC
    if (_managedObjectContext == savedContext)
    {
        return;
    }
    
    if (_managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator)
    {
        // that's another database
        return;
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [_managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

@end
