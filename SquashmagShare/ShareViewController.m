//
//  ShareViewController.m
//  SquashmagShare
//
//  Created by Abbin Varghese on 08/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

NSString *const articleForReview = @"articleForReview";

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
                
                    if (url) {
                        
                        NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName: @"group.ThePaadamCompany.Squashmag"];
                        NSMutableArray *array = [NSMutableArray arrayWithArray:[mySharedDefaults objectForKey:articleForReview]];
                        
                        if (array.count>0) {
                            [array addObject:[NSString stringWithFormat:@"%@",url]];
                        }
                        else{
                            [array addObject:[NSString stringWithFormat:@"%@",url]];
                        }
                        [mySharedDefaults setObject:array forKey:articleForReview];
                        [mySharedDefaults synchronize];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you!" message:@"Your submission is under review. Kindly wait. It may take upto 24 hours to be approved for publishing" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
                            }];
                            [alert addAction:action];
                            [self presentViewController:alert animated:YES completion:^{
                                
                            }];

                            
                        });
                        
                    }
                    else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:@"Squashmag failed to get url from app" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
                        }];
                        [alert addAction:action];
                        [self presentViewController:alert animated:YES completion:^{
                            
                        }];
                            });
                    }
                    
                }];
                
                break;
            }
        }
        
    }
    
}

@end
