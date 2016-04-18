//
//  PostTableViewCell.m
//  VKNews
//
//  Created by Alyona Belyaeva on 14.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "PostTableViewCell.h"
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

- (void)setAssociatedObject:(id)associatedObject // that we can checking right image
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#pragma PostTableViewCell

@interface PostTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image1Height;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *repostLabel;

@property (strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

@end


@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image1.image = nil;
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];

}

-(void)showPostInfo:(VKPost *)vkpost{
    self.nameLabel.text = vkpost.author;
    self.postLabel.text = vkpost.postText;
    self.likesLabel.text = [NSString stringWithFormat:@"♥︎ %lu",(unsigned long)vkpost.likes];
    self.repostLabel.text = [NSString stringWithFormat:@"♠︎ %lu",(unsigned long)vkpost.reposts];
    
    [self showAvatarWithURL:vkpost.avatar];
    self.image1.image = nil;
    if(vkpost.allImages.count > 0){
        [self showImagesWithInfo:vkpost.allImages];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm dd.MM"];
    self.dateLabel.text = [formatter stringFromDate:vkpost.date];
    
}

-(float)calculateHeightWithContent:(VKPost *)post forWidth:(CGFloat)width{ //Calculate content height for cell
    float height = 64.0;
    self.nameLabel.text = post.author;
    self.postLabel.text = post.postText;
    self.image1.image = nil;
    if(post.allImages.count > 0){
        height = height + [post calculatedSizeForOldSizeIndex:0 forWidth:width-90.0].height;
    }
    
    CGSize nameSize = [post.author boundingRectWithSize:CGSizeMake(width-98.0, MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName : self.nameLabel.font}
                                   context:nil].size;
    height = height + nameSize.height;
    
    CGSize postSize = [post.postText boundingRectWithSize:CGSizeMake(width-98.0, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName : self.postLabel.font}
                                                context:nil].size;
    height = height + postSize.height;
    return height;
}


-(void)showAvatarWithURL:(NSString *)url{
    self.avatarImageView.associatedObject = url;
    __block __weak PostTableViewCell *wself = self;
    [self.operationManager GET:url
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if ([wself.avatarImageView.associatedObject isEqualToString:url]){
                               wself.avatarImageView.image = responseObject;
                           }
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
                           NSLog(@"Failed with error %@.", error);
#endif
                       }];
}


-(void)showImagesWithInfo:(NSArray *)array{
    NSString *url1 = array[0];
    __block __weak PostTableViewCell *wself = self;
    self.image1.associatedObject = url1;
    [self.operationManager GET:url1
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                           if ([wself.image1.associatedObject isEqualToString:url1]){
                               wself.image1.image = responseObject;
                           }
                       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
#if DEBUG
                           NSLog(@"Failed with error %@.", error);
#endif
                       }];
}

CGSize CGSizeAspectFit(const CGSize aspectRatio, const CGSize boundingSize)
{
    CGSize aspectFitSize = CGSizeMake(boundingSize.width, boundingSize.height);
    float mW = boundingSize.width / aspectRatio.width;
    aspectFitSize.height = mW * aspectRatio.height;
    return aspectFitSize;
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
