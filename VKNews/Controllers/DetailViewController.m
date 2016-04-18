//
//  DetailViewController.m
//  VKNews
//
//  Created by Alyona Belyaeva on 16.04.16.
//  Copyright © 2016 Alyona Belyaeva. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageCollectionViewCell.h"

@interface DetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *repostsLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
@property (weak, nonatomic) IBOutlet UIView *content;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarImageView.image = self.avatarImage;
    self.nameLabel.text = self.post.author;
    self.postText.text = self.post.postText;
    self.likesLabel.text = [NSString stringWithFormat:@"♥︎ %lu",(unsigned long)self.post.likes];
    self.repostsLabel.text = [NSString stringWithFormat:@"♠︎ %lu",(unsigned long)self.post.reposts];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm dd.MM"];
    self.dateLabel.text = [formatter stringFromDate:self.post.date];
    [self.collectionViewHeight setConstant:[self.post heightForAllImagesWithWeight:self.view.frame.size.width-40]];
    [self.collectionView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return self.post.allImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"ImageCell";
    ImageCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *photo = self.post.allImages[indexPath.row];
    [cell setImageWithUrl:photo];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize imageSize = [self.post calculatedSizeForOldSizeIndex:indexPath.row forWidth:self.collectionView.frame.size.width];
    return imageSize;
}


@end
