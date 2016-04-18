//
//  MainModel.m
//  VKNews
//
//  Created by Alyona Belyaeva on 14.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "MainModel.h"
#import "AppDelegate.h"
#import "VKPost.h"

static NSArray *SCOPE = nil;

@interface MainModel ()

@property (nonatomic) BOOL isLoggedIn;
@property (nonatomic, strong) NSString *nextFrom;
@property (nonatomic, strong) NSString *toEnd;

@end


@implementation MainModel

@synthesize isLoggedIn = _isLoggedIn;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t pred;
    static MainModel *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[MainModel alloc] init];
        SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_PHOTOS, VK_PER_MESSAGES];
        [VKSdk initializeWithAppId:@"5412699"];
        shared.nextFrom = @"";
        shared.posts = [NSMutableArray array];
    });
    
    return shared;
}


-(BOOL)isLoggedIn{
    __block BOOL res;
    __weak id wself = self;
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            res = YES;
            [wself downloadNewsFromStart:NO]; //because we dont have anything
        } else {
            res = NO;
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                });
            }
        }
    }];
    
    return res;
}

-(void)authorize{
    [VKSdk authorize:SCOPE];
}

-(void)startWorking{
    [self downloadNewsFromStart:NO];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *viewController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"MainScreen"];
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:viewController];
}

-(void)setVKDelegates:(id<VKSdkUIDelegate,VKSdkDelegate>)delegate{
    [[VKSdk instance] registerDelegate:delegate];
    [[VKSdk instance] setUiDelegate:delegate];
}

-(void)clearAllData{
    self.posts = [NSMutableArray array];
    self.nextFrom = @"";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadPosts" object:nil];
}

-(void)logout{
    [VKSdk forceLogout];
    [self clearAllData];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] logout];
}


#pragma mark - VK Logic

-(NSString *)toEnd{
    if(self.posts.count>0){
        VKPost *firstPost = self.posts[0];
        return [NSString stringWithFormat:@"%f",[firstPost.date timeIntervalSince1970]];
    }else{
        return @"";
    }
}

-(NSString *)userId{
    return [[VKSdk accessToken] userId];
}

-(void)downloadNewsFromStart:(BOOL)fromStart{
    VKRequest *req;
    if (fromStart) {
        req = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"filters": @"post", @"end_from": self.toEnd ,@"count": @(25)}];
    } else {
        req = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"filters": @"post", @"start_from": self.nextFrom, @"count": @(25)}];
    }
    
    [req executeWithResultBlock:^(VKResponse *response) {
        NSMutableArray * array = [NSMutableArray array];
//        NSLog(@"res: %@",response.json);
        self.nextFrom = [response.json objectForKey:@"next_from"];
        
        NSArray *items = [response.json objectForKey:@"items"];
        NSArray *profiles = [response.json objectForKey:@"profiles"];
        NSArray *groups = [response.json objectForKey:@"groups"];
        
        for(NSDictionary *item in items){
            int sourse = fabsl([[item objectForKey:@"source_id"] doubleValue]);
            NSDictionary *group = nil;
            if(groups.count > 0){
                for (NSDictionary *gr in groups){
                    if(sourse == [[gr objectForKey:@"id"] intValue]){
                        group = gr;
                        break;
                    }
                }
            }
            NSDictionary * profile = nil;
            if(profiles.count > 0){
                for (NSDictionary *pr in profiles){
                    if(sourse == [[pr objectForKey:@"id"] intValue]){
                        profile = pr;
                        break;
                    }
                }
            }
            VKPost *post = [[VKPost alloc] initWithItem:item profile:profile orGroup:group];
            [array addObject:post];
        }
        if(fromStart){ //add objects at start
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                   NSMakeRange(0,[array count])];
            [self.posts insertObjects:array atIndexes:indexes];
        }else{ //add object at end
            [self.posts addObjectsFromArray:array];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadPosts" object:nil];
        
    } errorBlock:^(NSError * error) {
        if (error.code != VK_API_ERROR) {
            [error.vkError.request repeat];
        } else {
            NSLog(@"VK error: %@", error);
        }
    }];
}

-(void)downloadPostsOlder{
    [self downloadNewsFromStart:NO];
}
-(void)downloadNewPosts{
    [self downloadNewsFromStart:YES];
}

@end
