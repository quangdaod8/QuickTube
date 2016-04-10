//
//  ChannelCell.h
//  vtvvideos
//
//  Created by Duy Quang on 2/23/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelData.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MarqueeLabel.h"

@interface ChannelCell : UITableViewCell
-(void)setDataByChannelData:(ChannelData*)data;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet MarqueeLabel *subCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
- (IBAction)btnAddAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *videoCount;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property(strong, nonatomic) ChannelData *channelData;
@property (weak, nonatomic) IBOutlet UIImageView *imgAva;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
