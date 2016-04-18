//
//  DetailViewController.h
//  VKNews
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKPost.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) VKPost *post;
@property (nonatomic, strong) UIImage *avatarImage;

@end
