//
//  PostTableViewCell.h
//  VKNews
//
//  Created by Alyona Belyaeva on 14.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKPost.h"

@interface PostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *image1;

-(void)showPostInfo:(VKPost *)vkpost;
-(float)calculateHeightWithContent:(VKPost *)post forWidth:(CGFloat)width;

@end
