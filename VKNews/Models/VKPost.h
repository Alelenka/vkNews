//
//  VKPost.h
//  VKNews
//
//  Created by Alyona Belyaeva on 14.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VKPost : NSObject

@property (nonatomic, strong) NSString *sourceId;
@property (nonatomic, strong) NSString *postId;

@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *postText;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSArray *allImages;

@property (nonatomic) NSUInteger likes;
@property (nonatomic) NSUInteger reposts;

@property (nonatomic) NSArray *imagesSize;

-(id)initWithItem:(NSDictionary *)item profile:(NSDictionary *)profile orGroup:(NSDictionary *)group;
-(CGSize)calculatedSizeForOldSizeIndex:(NSInteger)index forWidth:(CGFloat)width;
-(CGFloat)heightForAllImagesWithWeight:(CGFloat)width;

@end
