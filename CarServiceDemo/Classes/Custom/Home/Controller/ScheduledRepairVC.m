//
//  ScheduledRepairVC.m
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/3.
//  Copyright © 2018年 com.from. All rights reserved.
//

#import "ScheduledRepairVC.h"
#import "WKTextView.h"
#import "UniversalSelectionBoxView.h"

#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import <Photos/Photos.h>
#import "ZLPhotoManager.h"
#import "ZLPhotoConfiguration.h"
#import "UIImage+Thumb.h"
#import "SelectPhotoStatusModel.h"
#import "SelectPhotoCollectionCell.h"
#import "MaintenanceRecordController.h"
#import "SubmitMaintainController.h"

static NSString *SelectPhotoCollectionCellID = @"SelectPhotoCollectionCell";

@interface ScheduledRepairVC ()<UniversalSelectionBoxViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SelectPhotoCollectionCellDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet WKTextView *textView;
@property (nonatomic ,strong)UniversalSelectionBoxView *selectBoxView;

//  选择相册相关
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic ,strong)NSMutableArray *photoAlbumImageDataSources;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, assign) BOOL isOriginal;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITextField *mobiTF;

@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confrimBtn;
@end

@implementation ScheduledRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // 初始化属性
    [self setupProperty];
    
    // 初始化页面
    [self setupInterFace];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupProperty{
    
    [self.confrimBtn setCornerRadius:4];
    self.textView.placeholder = @"请描述您要维修的项目";
    self.textView.placeholderColor = [UIColor colorwithHexString:@"A3A3A3"];
    self.title = @"预约维修";
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"NoDataCollectionViewCell" bundle:nil]
               forCellWithReuseIdentifier:@"NoDataCollectionViewCell"];
    
    [self.photoCollectionView registerNib:[UINib nibWithNibName:SelectPhotoCollectionCellID bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:SelectPhotoCollectionCellID];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 18, 0, 0);
    self.photoCollectionView.collectionViewLayout = flowLayout;
    
    if (self.photoAlbumImageDataSources.count <3) {
        SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
        model.imageData = nil;
        model.isAdd = YES;
        model.isShowImg = YES;
        model.isCanDelete = NO;
        [self.photoAlbumImageDataSources addObject:model];
    }
    [self.photoCollectionView reloadData];
    
}

- (void)setupInterFace{
    self.addressLabel.text = self.dataModel.address;
    
}

- (IBAction)selectTimeBtnAction:(id)sender {
    
    kWeakSelf(weakSelf);
    //年-月-日
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate *selectDate) {
        
        NSString *dateString = [selectDate stringWithFormat:@"yyyy-MM-dd"];
        
        weakSelf.timeLabel.text = dateString;
    }];
    datepicker.dateLabelColor = [UIColor colorwithHexString:@"3CADFF"];;//年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor colorwithHexString:@"3CADFF"];//滚轮日期颜色
    datepicker.doneButtonColor = [UIColor colorwithHexString:@"3CADFF"];;//确定按钮的颜色
    datepicker.minLimitDate = [NSDate date];
    [datepicker show];
}

- (IBAction)selectAddressBtnAction:(id)sender {
    
    
}

- (IBAction)selectCarTypeBtnAction:(UIButton *)sender {
    
    if (!self.selectBoxView) {
        self.selectBoxView = [UniversalSelectionBoxView universalSelectionBoxViewWithDataArr:@[@"小型蓝牌",@"七座以下"]];
        self.selectBoxView.delegate = self;
        [self.view addSubview:self.selectBoxView];
    }else{
        [self.selectBoxView showUniversalSelectionBoxView];
    }
    
}

- (void)universalSelectionBoxView:(UIView *)view SelectedIndex:(NSInteger)selectIndex SelectContent:(NSString *)selectContent{

    self.carTypeLabel.text = selectContent;
}




- (NSMutableArray *)photoAlbumImageDataSources{
    if (!_photoAlbumImageDataSources) {
        _photoAlbumImageDataSources = [NSMutableArray array];
    }
    return _photoAlbumImageDataSources;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoAlbumImageDataSources.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SelectPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SelectPhotoCollectionCellID forIndexPath:indexPath];
    cell.delegate = self;
    
    [cell setCellParamsWithModel:self.photoAlbumImageDataSources[indexPath.row] andIndexPath:indexPath.row];
    
    return cell;
}



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(116, 116);
}


static ZLPhotoActionSheet * extracted(ScheduledRepairVC *object) {
    return [object getPas];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectPhotoStatusModel *model = self.photoAlbumImageDataSources[indexPath.row];
    if (model.isAdd) {
        [[self getPas] showPhotoLibrary];
    }else{
        
        NSInteger indexTag = indexPath.row;

        [extracted(self) previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexTag isOriginal:self.isOriginal];
    }
    
}


- (ZLPhotoActionSheet *)getPas
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.configuration.sortAscending =0;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
    //设置照片最大预览数
    actionSheet.configuration.maxPreviewCount =3;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount =3;
    //是否在选择图片后直接进入编辑界面
    actionSheet.configuration.editAfterSelectThumbnailImage = NO;
    //是否在已选择照片上显示遮罩层
    actionSheet.configuration.showSelectedMask = YES;
    //是否允许框架解析图片
    actionSheet.configuration.shouldAnialysisAsset = YES;
    actionSheet.configuration.allowRecordVideo = NO;
    //框架语言
    //是否使用系统相机
    actionSheet.configuration.useSystemCamera = YES;
    actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
    
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = [UIApplication sharedApplication].keyWindow.rootViewController;
    //记录上次选择的图片
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.isOriginal = isOriginal;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        NSLog(@"image:%@", images);
        [strongSelf anialysisAssets:assets original:isOriginal];
    }];
    return actionSheet;
}

- (void)anialysisAssets:(NSArray<PHAsset *> *)assets original:(BOOL)original
{
    //    [MBProgressHUD showStatusOnView:self withMessage:LoadingMsg];
    //
    if (assets.count >0) {
       
        zl_weakify(self);
        [ZLPhotoManager anialysisAssets:assets original:original completion:^(NSArray<UIImage *> *images) {
            zl_strongify(weakSelf);
            NSMutableArray *imageArr = [NSMutableArray arrayWithArray:images];
            [strongSelf.photoAlbumImageDataSources removeAllObjects];
           
            for (int i = 0; i < images.count; i++) {
                UIImage *image= imageArr[i];
                SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
                model.imageData = image;
                model.isAdd = NO;
                model.isCanDelete = YES;
                [self.photoAlbumImageDataSources addObject:model];
                
            }
            
            
            if (self.photoAlbumImageDataSources.count <3) {
                SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
                model.imageData = nil;
                model.isAdd = YES;
                model.isShowImg = YES;
                model.isCanDelete = NO;
                [strongSelf.photoAlbumImageDataSources addObject:model];
            }
            [strongSelf.photoCollectionView reloadData];
        }];
    }else{
        kWeakSelf(weakSelf);

        weakSelf.photoAlbumImageDataSources = nil;
        
        
        if (self.photoAlbumImageDataSources.count <3) {
            SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
            model.imageData = nil;
            model.isAdd = YES;
            model.isShowImg = YES;
            model.isCanDelete = NO;
            [weakSelf.photoAlbumImageDataSources addObject:model];
        }
        [weakSelf.photoCollectionView reloadData];
        
    }
    
}

- (void)deleteImageWithSelectIndex:(NSInteger)index andImageModel:(SelectPhotoStatusModel *)imageModel{
    NSInteger indexTag = index;
    if (self.photoAlbumImageDataSources.count >=6) {
        indexTag = index;
    }else{
        indexTag = (index==0 ? 0:index);
    }
    if (indexTag < self.photoAlbumImageDataSources.count && self.photoAlbumImageDataSources.count >0 && imageModel) {
        [self.photoAlbumImageDataSources removeObjectAtIndex:indexTag];
        [self.lastSelectAssets removeObjectAtIndex:indexTag];
        [self.lastSelectPhotos removeObjectAtIndex:indexTag];
    }
    
    if (self.photoAlbumImageDataSources.count <3) {
        SelectPhotoStatusModel *model = [[SelectPhotoStatusModel alloc]init];
        model.imageData = nil;
        model.isAdd = YES;
        model.isShowImg = YES;
        model.isCanDelete = NO;
        [self.photoAlbumImageDataSources addObject:model];
    }
    
    [self.photoCollectionView reloadData];
}

- (NSMutableArray *)selectedImageDealWithArr:(NSArray *)arr{
    SelectPhotoStatusModel *addModel = nil;
    NSMutableArray *array = [[NSMutableArray alloc]initWithArray:arr];
    for (SelectPhotoStatusModel *model in array) {
        if (model.isAdd) {
            addModel = model;
        }
    }
    if (addModel) {
        [array removeObject:addModel];
    }
    return array;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    ///限制输入11位
    if (textField == self.mobiTF){
        if (textField.text.length>=11 && string.length>0) {
            return NO;
        }
    }
   
    return YES;
}


- (IBAction)confirmBtnAction:(UIButton *)sender {
    
    if ([ValidateUtil isEmptyStr:self.textView.text]) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请描述您要维修的项目！"];
        return;
    }
    
    if ([self selectedImageDealWithArr:self.photoAlbumImageDataSources].count == 0) {
        [MBProgressHUD showErrorOnView:self.view withMessage:@"请上传图片！"];
        return;
    }
    
    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
    parmas[@"content"] = self.textView.text;
    NSArray *imageArr = [self selectedImageDealWithArr:self.photoAlbumImageDataSources];
    parmas[@"number"] = @(imageArr.count);
    for(int i = 0 ; i < imageArr.count ; i++){
        SelectPhotoStatusModel *model = imageArr[i];
        NSString *key = [NSString stringWithFormat:@"pic%d",i+1];
        NSData *data = [UIImage imageWithImage:model.imageData limitCompactionImageLength:200];
    
            //使用0或以下来控制线结束后的最大线长度。默认情况下没有插入任何行的结尾
        NSString *valueStr = [data base64EncodedStringWithOptions:0];
        parmas[key] = valueStr;
    
    }
    SubmitMaintainController *vc = [[SubmitMaintainController alloc]init];
    vc.repairModel = self.dataModel;
    vc.maintainDictM = parmas;
    vc.isMaintain = YES;
    [self.navigationController pushViewController:vc animated:YES];
//    if ([ValidateUtil isEmptyStr:self.nameTF.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入联系人名称！"];
//        return;
//    }
//
//    if ([ValidateUtil isEmptyStr:self.mobiTF.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"请输入联系电话！"];
//        return;
//    }
//
//    if ([ValidateUtil isEmptyStr:self.carTypeLabel.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择车型！"];
//        return;
//    }
//    if ([ValidateUtil isEmptyStr:self.timeLabel.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"请选择时间！"];
//        return;
//    }
//    if ([ValidateUtil isEmptyStr:self.textView.text]) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"请描述您要维修的项目！"];
//        return;
//    }
//
//
//    if ([ValidateUtil isEmptyStr:self.dataModel.latitude] || [ValidateUtil isEmptyStr:self.dataModel.longitude] ) {
//        [MBProgressHUD showErrorOnView:self.view withMessage:@"暂无定位信息，请稍后重试！"];
//        return;
//    }
    
//    [MBProgressHUD showStatusOnView:self.view withMessage:LoadingMsg];
//    kWeakSelf(weakSelf);
//        int    汽修厂id    无    1
//        char(20)    名称    无    张三
//        char(20)    电话号码    无    12345678998
//        float    经度    无    104
//        float    纬度    无    23
//        char(100)    地址    无    广州天河区
//        char(100)    车型    无    Tx21
//        datetime    预约时间    无    2018-07-08 12:23:34
//        text    内容    无    修理
//    number    int    数量    多少个文件    1
//    pic1    文件流    图片    编号从1开始    (文件流)
    
//    NSMutableDictionary *parmas = [NSMutableDictionary dictionary];
//    parmas[@"garage_id"] = self.dataModel.ID;
//    parmas[@"name"] = self.nameTF.text;
//    parmas[@"phone"] = self.mobiTF.text;
//    parmas[@"longitude"] = self.dataModel.longitude;
//    parmas[@"latitude"] = self.dataModel.latitude;
//    parmas[@"address"] = self.dataModel.address;
//    parmas[@"car_type"] = self.carTypeLabel.text;
//    parmas[@"subscribe_time"] = [NSString stringWithFormat:@"%@ 00:00:00",self.timeLabel.text];
//    parmas[@"content"] = self.textView.text;
//    NSArray *imageArr = [self selectedImageDealWithArr:self.photoAlbumImageDataSources];
//    parmas[@"number"] = @(imageArr.count);
//
//
//    for(int i = 0 ; i < imageArr.count ; i++){
//        SelectPhotoStatusModel *model = imageArr[i];
//        NSString *key = [NSString stringWithFormat:@"pic%d",i+1];
//        NSData *data = [UIImage imageWithImage:model.imageData limitCompactionImageLength:200];
//
//        //使用0或以下来控制线结束后的最大线长度。默认情况下没有插入任何行的结尾
//        NSString *valueStr = [data base64EncodedStringWithOptions:0];
//        parmas[key] = valueStr;
//
//    }
//
//    [self.util postDataWithPath:@"/api/maintain/maintain/" parameters:parmas result:^(id obj, int status, NSString *msg) {
//        if (status == 1) {
//
//            [MBProgressHUD dismissHUDForView:weakSelf.view];
//
//            [weakSelf.navigationController pushViewController:[[MaintenanceRecordController alloc]init] animated:YES];
//
//        }else{
//
//            [MBProgressHUD dismissHUDForView:weakSelf.view withError:msg];
//        }
//    }];
//
    
    
}

@end
