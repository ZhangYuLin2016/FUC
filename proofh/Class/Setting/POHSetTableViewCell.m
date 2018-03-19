//
//  POHSetTableViewCell.m
//  proofh
//
//  Created by 张玉琳 on 2018/3/5.
//  Copyright © 2018年 zyl. All rights reserved.
//

#import "POHSetTableViewCell.h"

@implementation POHSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCell];
    }
    return self;
}
- (void)initCell{
    //cellH = 60
    self.backgroundColor = [UIColor whiteColor];
    CGFloat imageW = 40;
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, imageW, imageW)];
    [self.contentView addSubview:_image];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20+imageW+10, 10, 1, 40)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+imageW+10+10, 0, kScreenWidth - (20+imageW+10+10+20), 30)];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    
    _detailLable = [[UILabel alloc] initWithFrame:CGRectMake(20+imageW+10+10, 30, kScreenWidth - (20+imageW+10+10+20), 30)];
    [self.contentView addSubview:_detailLable];
    _detailLable.textColor = [UIColor grayColor];
    _detailLable.font = [UIFont systemFontOfSize:12];
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(0, 59, kScreenWidth, 1)];
    [self.contentView addSubview:vLine];
    vLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

@end
