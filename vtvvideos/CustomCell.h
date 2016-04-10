//
//  CustomCell.h
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoData.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MarqueeLabel.h"

@protocol CustomCellDelegate
-(void)pressPlayWithVideoId:(NSString*)videoId;
-(void)pressInfoWithVideoId:(NSString*)videoId;
-(void)pressActionWithVideoId:(NSString*)videoId Title:(NSString*)title;
-(void)pressFavoWithVideoData:(VideoData*)videoData;
@end
@interface CustomCell : UITableViewCell

- (IBAction)playPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet MarqueeLabel *title;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blur;
- (IBAction)btnFavoAction:(id)sender;
@property (weak, nonatomic) id<CustomCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *btnFavo;
@property (strong, nonatomic) NSString* videoId;
@property (strong, nonatomic) VideoData *videoData;
@property (weak, nonatomic) IBOutlet UILabel *live;
@property (strong, nonatomic) IBOutlet UIButton *btnInfo;
- (IBAction)btnInfoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnAction;
- (IBAction)btnActionPress:(id)sender;

-(void)setDataForCellByVideoData:(VideoData*)data;
@end
