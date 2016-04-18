//
//  ImageCollectionViewCell.m
//  VKNews
//
//  Created by Alyona Belyaeva on 17.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#import "AFNetworking.h"
#import <objc/runtime.h>


#pragma help

@interface NSObject (Associating)

@property (nonatomic, retain) id associatedObject;

@end

@implementation NSObject (Associating)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


@interface ImageCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

@end

@implementation ImageCollectionViewCell

-(void)setImageWithUrl:(NSString *)urlStr{
    self.photoImage.associatedObject = urlStr;
    __block __weak ImageCollectionViewCell *wself = self;
    [self.operationManager GET:urlStr
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if ([wself.photoImage.associatedObject isEqualToString:urlStr]){
                               wself.photoImage.image = responseObject;
                               wself.imageActivity.hidden = YES;
                           }
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
                           NSLog(@"Failed with error %@.", error);
#endif
                       }];
}


#pragma Internet Help

- (AFHTTPRequestOperationManager *)operationManager
{
    if (!_operationManager)
        {
        _operationManager = [[AFHTTPRequestOperationManager alloc] init];
        _operationManager.responseSerializer = [AFImageResponseSerializer serializer];
        };
    
    return _operationManager;
}

@end
