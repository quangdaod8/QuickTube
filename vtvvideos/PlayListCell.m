//
//  PlayListCell.m
//  vtvvideos
//
//  Created by Duy Quang on 2/24/16.
//  Copyright © 2016 duyquang. All rights reserved.
//

#import "PlayListCell.h"

@implementation PlayListCell

- (void)awakeFromNib {
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataByPlayListData:(PlayListData *)data {
    _title.text = data.title;
    _videoCount.text = [NSString stringWithFormat:@"%ld Videos",(long)data.total];
    [_imgView setImageWithURL:[NSURL URLWithString:data.thumbnailsUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}
-(void)setDataByVideoData:(VideoData *)data {
    _title.text = @"ALL VIDEOS";
    _videoCount.text = [NSString stringWithFormat:@"%ld Videos",(long)data.total];
    VideoData *temp = [data.listItems firstObject];
    [_imgView setImageWithURL:[NSURL URLWithString:temp.thumbailUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
}
@end
