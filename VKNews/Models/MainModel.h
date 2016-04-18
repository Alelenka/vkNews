//
//  MainModel.h
//  VKNews
//
//  Created by Alyona Belyaeva on 14.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VK-ios-sdk/VKSdk.h>

@interface MainModel : NSObject

@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, strong) NSMutableArray *posts;

+ (instancetype)sharedInstance;

-(void)authorize;
-(void)clearAllData;
-(void)setVKDelegates:(id <VKSdkUIDelegate, VKSdkDelegate>)delegate;
-(void)startWorking;
-(void)logout;

-(void)downloadPostsOlder;
-(void)downloadNewPosts;


@end
