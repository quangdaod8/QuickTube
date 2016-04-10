//
//  CustomCell.m
//  vtvvideos
//
//  Created by Duy Quang on 2/21/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (void)awakeFromNib {
    _live.clipsToBounds = YES;
    _live.layer.borderColor = [[UIColor redColor]CGColor];
    _live.layer.borderWidth = 1;
    [self showPlay:NO];
    //_live.layer.cornerRadius = 2;
    [_live setHidden:YES];
    //[self setGardiendView];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected) {
        if(_btnPlay.isHidden) [self showPlay:YES];
    } else [self showPlay:NO];
}
- (IBAction)btnInfoAction:(id)sender {
    [_delegate pressInfoWithVideoId:_videoId];
}

- (IBAction)btnActionPress:(id)sender {
    [self.delegate pressActionWithVideoId:_videoId Title:_title.text];
}

-(void)setDataForCellByVideoData:(VideoData *)data {
    _videoData = data;
    [_imgView setImageWithURL:[NSURL URLWithString:data.thumbailUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _title.text = data.title;
    _videoId = data.videoId;
    if([data.liveBroadcastContent isEqualToString:@"live"]) [_live setHidden:NO];
    else [_live setHidden:YES];
    [_title restartLabel];
}
    
-(void)showPlay:(BOOL)play {
    if(play) {
        [_btnPlay setHidden:NO];
        [_btnFavo setHidden:NO];
        [_btnInfo setHidden:NO];
        [_btnAction setHidden:NO];
        [_blur setHidden:NO];
        [_title restartLabel];
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        [UIView animateWithDuration:0.3 animations:^{
            [_blur setEffect:effect];
            _btnPlay.alpha = 0.8;
            _btnInfo.alpha = 0.8;
            _btnFavo.alpha = 0.8;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [_blur setEffect:nil];
            [_btnPlay setHidden:YES];
            [_btnInfo setHidden:YES];
            [_btnAction setHidden:YES];
            [_btnFavo setHidden:YES];
            
        }];
    }
}
- (IBAction)playPressed:(id)sender {
    [self.delegate pressPlayWithVideoId:_videoId];
}
-(void)setGardiendView {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = _view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
    [_view.layer insertSublayer:gradient atIndex:0];
}

- (IBAction)btnFavoAction:(id)sender {
    [self.delegate pressFavoWithVideoData:_videoData];
}
@end
