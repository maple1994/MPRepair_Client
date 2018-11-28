//
//  NewsHeadTableCell.m
//  CarServiceDemo
//
//  Created by xiejun on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "NewsHeadTableCell.h"
#import "NewsModel.h"
#import "NewsDetailWebController.h"

@interface NewsHeadTableCell ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (strong,nonatomic) SDCycleScrollView *cycleScrollView;

@end

@implementation NewsHeadTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_backView addSubview:self.cycleScrollView];
    kWeakSelf(weakSelf)
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.left.with.bottom.with.right.mas_equalTo(weakSelf.backView);
    }];
}

- (void)setImageArrM:(NSMutableArray *)imageArrM{
    _imageArrM = imageArrM;
    NSMutableArray *dataArrM = [NSMutableArray array];
    for (NewsModel *model in _imageArrM) {
        [dataArrM addObject:model.pic_url];
    }
    _cycleScrollView.localizationImageNamesGroup = dataArrM;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NewsModel *model = self.imageArrM[index];
    NewsDetailWebController *newsDetailVC = [[NewsDetailWebController alloc] init];
    newsDetailVC.urlStr = model.detail_url;
    [self.viewController.navigationController pushViewController:newsDetailVC animated:YES];
}

#pragma mark - 懒加载
- (SDCycleScrollView *)cycleScrollView{
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _backView.height) imageURLStringsGroup:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 5;
        _cycleScrollView.placeholderImage = [UIImage imageNamed:KDefaultImage];
    }
    return _cycleScrollView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
