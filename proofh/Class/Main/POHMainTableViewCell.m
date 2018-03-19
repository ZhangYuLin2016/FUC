//
//  POHMainTableViewCell.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHMainTableViewCell.h"

@implementation POHMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initCell];
        self.contentView.backgroundColor = kTbgColor;
    }
    return self;
}

- (void)initCell{
    CGFloat labelH = 25;
    CGFloat labelW = kScreenWidth-40;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, labelW, labelH)];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:14];

    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_timeLabel.frame), labelW, labelH)];
    [self.contentView addSubview:_moneyLabel];
    _moneyLabel.font = [UIFont systemFontOfSize:14];
    
    _zhuangTaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_moneyLabel.frame), labelW, labelH)];
    [self.contentView addSubview:_zhuangTaiLabel];
    _zhuangTaiLabel.font = [UIFont systemFontOfSize:14];

    _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_zhuangTaiLabel.frame), labelW, labelH)];
    [self.contentView addSubview:_addrLabel];
    _addrLabel.font = [UIFont systemFontOfSize:14];
   
    
}

- (void)setFrame:(CGRect)frame{
    frame.size.height -= 2;
    [super setFrame:frame];
}
@end
