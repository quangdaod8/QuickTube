//
//  PlayListCell.h
//  vtvvideos
//
//  Created by Duy Quang on 2/24/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayListData.h"
#import "VideoData.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface PlayListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *videoCount;
@property (weak, nonatomic) IBOutlet UIView *view;

-(void)setDataByPlayListData:(PlayListData*)data;
-(void)setDataByVideoData:(VideoData*)data;
@end
