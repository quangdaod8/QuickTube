//
//  ChannelCell.m
//  vtvvideos
//
//  Created by Duy Quang on 2/23/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "ChannelCell.h"

@implementation ChannelCell

- (void)awakeFromNib {
    // Initialization code
    _btnAdd.layer.cornerRadius = 5;
    [_btnAdd setHidden:YES];
    _btnAdd.clipsToBounds = YES;
    _btnAdd.layer.borderWidth = 1;
    _btnAdd.layer.borderColor = [[UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1]CGColor];
    _imgAva.clipsToBounds = YES;
    _imgAva.layer.borderColor = [[UIColor whiteColor]CGColor];
    _imgAva.layer.borderWidth = 0.5;
    _imgAva.layer.cornerRadius = 34.5;
    
    
    [_imgBanner setClipsToBounds:YES];
    [_view setClipsToBounds:YES];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setDataByChannelData:(ChannelData *)data {
    [_imgAva setImageWithURL:[NSURL URLWithString:data.imgAvaUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_imgBanner setImageWithURL:[NSURL URLWithString:data.imgBannerUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _title.text = data.title;
    _videoCount.text = [NSString stringWithFormat:@"%@ Videos  |  %@ Subs",data.videoCount,data.subscriberCount];
    _channelData = data;
    [_subCount restartLabel];
    
        if([data.liveBroadcastContent isEqualToString:@"live"]) {
            _subCount.text = @"Live Streaming";
            _subCount.textColor = [UIColor colorWithRed:1 green:0.2 blue:0.4 alpha:1];
        } else {
            _subCount.text = data.descriptions;
            _subCount.textColor = [UIColor lightGrayColor];
            _subCount.textColor = [UIColor lightGrayColor];
        }

}

- (IBAction)btnAddAction:(id)sender {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[userDefault objectForKey:@"array"]];
    if([array containsObject:_channelData.channelId]) [self AlertWithTitle:_channelData.title Messenger:@"You can't add this channel because it has been added already" Butontitle:@"OK"];
    else {
        [array addObject:_channelData.channelId];
        [userDefault setObject:array forKey:@"array"];
        [userDefault synchronize];
        [self AlertWithTitle:_channelData.title Messenger:@"This channel has been added to Home" Butontitle:@"OK"];
    }
}

-(void)AlertWithTitle:(NSString*)title  Messenger:(NSString*)messenger  Butontitle:(NSString*)buttonTitle
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:messenger preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *ok) {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [[self topMostController] presentViewController:alert animated:YES completion:nil];
}

- (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

@end
