//
//  VKPost.m
//  VKNews
//
//  Created by Alyona Belyaeva on 14.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "VKPost.h"

@implementation VKPost

-(id)initWithItem:(NSDictionary *)item profile:(NSDictionary *)profile orGroup:(NSDictionary *)group{
    self = [super init];
    if (self) {
        self.sourceId = [item objectForKey:@"source_id"];
        self.postId = [item objectForKey:@"post_id"];
        self.postText = [item objectForKey:@"text"];
        
        if([self.postText isEqualToString:@""] && [item objectForKey:@"copy_history"]){
            NSDictionary * copyHistory = [item objectForKey:@"copy_history"][0];
            self.postText = [copyHistory objectForKey:@"text"];
            
        }
        
        if(profile.count > 0){
            self.author = [NSString stringWithFormat:@"%@ %@",[profile objectForKey:@"first_name"],[profile objectForKey:@"last_name"]];
            self.avatar = [profile objectForKey:@"photo_100"];
        }
        if(group.count > 0){
            self.author = [group objectForKey:@"name"];
            self.avatar = [group objectForKey:@"photo_100"];
        }
        
        self.date = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"date"] doubleValue]];
        
        self.likes = [[[item objectForKey:@"likes"] objectForKey:@"count"] intValue];
        self.reposts = [[[item objectForKey:@"reposts"] objectForKey:@"count"] intValue];
        
        if([item objectForKey:@"attachments"]){ //post
             self.allImages = [self findAllImageURL:[item objectForKey:@"attachments"]];
        }else { //repost
            NSDictionary * copyHistory = [item objectForKey:@"copy_history"][0];
            self.allImages = [self findAllImageURL:[copyHistory objectForKey:@"attachments"]];
        }
       
    }
    return self;
}


-(NSArray *)findAllImageURL:(NSArray *)attachment{
    NSMutableArray * array = [NSMutableArray array];
    NSMutableArray *sizeArray = [NSMutableArray array];
    for (NSDictionary* dict in attachment) {
        NSDictionary *photo = [dict objectForKey:@"photo"];
        if(photo){
            NSURL *imgURL = [photo objectForKey:@"photo_604"];
            [array addObject:imgURL];
            CGSize size = CGSizeMake([[photo objectForKey:@"width"] floatValue], [[photo objectForKey:@"height"] floatValue]);
            [sizeArray addObject:[NSValue valueWithCGSize:size]];
        }
    }
    self.imagesSize = [NSArray arrayWithArray:sizeArray];
    return array;
}


-(CGSize)calculatedSizeForOldSizeIndex:(NSInteger)index forWidth:(CGFloat)width{
    CGSize oldSize = [self.imagesSize[index] CGSizeValue];
    CGSize newSize = oldSize;
    if(oldSize.width > width){
        newSize.width = width;
        newSize.height = oldSize.height*(width/oldSize.width);
    }
    return newSize;
}

-(CGFloat)heightForAllImagesWithWeight:(CGFloat)width{
    CGFloat newHeight = 0.0;
    for (int i=0; i<self.imagesSize.count; i++) {
        CGSize oldSize = [self.imagesSize[i] CGSizeValue];
        CGSize newSize = oldSize;
        if(oldSize.width > width){
            newSize.width = width;
            newSize.height = oldSize.height*(width/oldSize.width);
        }
        newHeight += newSize.height;
    }
    return newHeight;
}




@end
