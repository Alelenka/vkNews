//
//  ImageCollectionViewCell.h
//  VKNews
//
//  Created by Alyona Belyaeva on 17.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *photoImage;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageActivity;
-(void)setImageWithUrl:(NSString *)urlStr;

@end
