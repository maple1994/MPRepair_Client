//
//  AnnualInspectionHistoryModel.h
//  CarServiceDemo
//
//  Created by Original_TJ on 2018/8/16.
//  Copyright © 2018年 com.from. All rights reserved.
//


#import <JSONModel/JSONModel.h>


@protocol obj_list <NSObject>
@end
@interface obj_list : JSONModel
///
@property (nonatomic ,copy)NSString *note;
///
@property (nonatomic ,copy)NSString *pic_url;

@end

@protocol image_list <NSObject>
@end
@interface image_list : JSONModel

/// 名称
@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,copy)NSString *price;
///
@property (nonatomic ,copy)NSArray <obj_list> *obj_list;
@end

@protocol failureitem_list <NSObject>
@end
@interface failureitem_list : JSONModel

/// 名称
@property (nonatomic ,copy)NSString *name;

@property (nonatomic ,copy)NSString *price;
///
@property (nonatomic ,copy)NSArray <obj_list> *failurepic_list;
@end

@protocol failure_object <NSObject>
@end
@interface failure_object : JSONModel
/// 名称
@property (nonatomic ,copy)NSString *name;
/// 费用
@property (nonatomic ,copy)NSString *price;
///
@property (nonatomic ,copy)NSArray <failureitem_list> *failureitem_list;

@end




@protocol surveypic_list <NSObject>
@end
@interface surveypic_list : JSONModel
///
@property (nonatomic ,copy)NSString *type;
///
@property (nonatomic ,strong)NSArray <obj_list>*obj_list;

@end

@protocol surveycomboitem_set <NSObject>
@end
@interface surveycomboitem_set : JSONModel
///
@property (nonatomic ,copy)NSString *name;
///
@property (nonatomic ,copy)NSString *price;

@end

@interface surveystation : JSONModel
///
@property (nonatomic ,copy)NSString *name;
///
@property (nonatomic ,copy)NSString *price;
///
@property (nonatomic ,copy)NSString *latitude;
///
@property (nonatomic ,copy)NSString *longitude;
///
@property (nonatomic ,copy)NSString *address;
///
@property (nonatomic ,copy)NSString *ID;

@end


@interface AnnualInspectionHistoryModel : JSONModel
/// id
@property (nonatomic ,copy)NSString *ID;
/// 创建时间
@property (nonatomic ,copy)NSString *create_time;
/// 修改时间
@property (nonatomic ,copy)NSString *update_time;
/// 联系人
@property (nonatomic ,copy)NSString *name;
/// 联系人电话
@property (nonatomic ,copy)NSString *phone;
/// 身份证正面照
@property (nonatomic ,copy)NSString *pic_IDcard_url;
/// 行驶证主页照
@property (nonatomic ,copy)NSString *pic_drive_front_url;
/// 车主姓名
@property (nonatomic ,copy)NSString *car_name;
/// 身份证
@property (nonatomic ,copy)NSString *id_card;
/// 品牌型号
@property (nonatomic ,copy)NSString *car_brand;
/// 车牌
@property (nonatomic ,copy)NSString *car_code;
/// 车量类型
@property (nonatomic ,copy)NSString *car_type;
/// 使用性质
@property (nonatomic ,copy)NSString *use_type;
/// 交接地点经度
@property (nonatomic ,copy)NSString *order_longitude;
/// 交接地点纬度
@property (nonatomic ,copy)NSString *order_latitude;

@property (nonatomic ,copy)NSString *order_address;
/// 年检站
@property (nonatomic ,copy)surveystation *surveystation;
//'surveystation':{
//    'id':1,
//    'create_time':'2018-07-08 12:23:34',
//    'update_time':'2018-07-08 12:23:34',
//    'name':'张三年检站',
//    'longitude':223,
//    'latitude':322,
//    'address':'广州越秀区'
//},
/// 预约日期
@property (nonatomic ,copy)NSString *subscribe_time;
/// 年检费用
@property (nonatomic ,copy)NSString *price;
/// 总费用
@property (nonatomic ,copy)NSString *total_price;
/// 0:还没有开始或是正在进行，1：成功，2：不成功，3：复查
@property (nonatomic ,copy)NSString *survey_state;
/// 0:已发布，1:已接单，2:已取车，3.到达年检，4.年检结束，5.等待支付，6.到达还车，7.已还车，8.已完成，9.已取消
@property (nonatomic ,copy)NSString *state;
/// 用户id
@property (nonatomic ,copy)NSString *drive_user_id;
/// 下单时间
@property (nonatomic ,copy)NSString *order_time;
/// 接单时间
@property (nonatomic ,copy)NSString *receive_time;
/// 取车时间
@property (nonatomic ,copy)NSString *get_time;
/// 到达年检时间
@property (nonatomic ,copy)NSString *arrive_survey_time;
/// 年检结束时间
@property (nonatomic ,copy)NSString *survey_time;
/// 到达还车时间
@property (nonatomic ,copy)NSString *arrive_return_time;
/// 还车时间
@property (nonatomic ,copy)NSString *return_time;
/// 确认时间
@property (nonatomic ,copy)NSString *confirm_time;
/// 取消时间
@property (nonatomic ,copy)NSString *cancel_time;
/// 是否评论， 0没有，1已评论
@property (nonatomic ,copy)NSString *is_comment;
///
@property (nonatomic ,assign)BOOL is_feedback;


//'surveycost_list':[{
//    'id':1,
//    'create_time':'2018-07-08 12:23:34',
//    'update_time':'2018-07-08 12:23:34',
//    'name':'材料费',
//    'price':12
//}],
//'pic_url_list':[{
//    'id':1,
//    'create_time':'2018-07-08 12:23:34',
//    'update_time':'2018-07-08 12:23:34',
//    'pic_url':'/aklsdjalk.jpg',
//    'note':'无图',
//    'state':1
//}]
///是否自驾
@property (nonatomic ,copy)NSString *is_self;
/// 年检是否成功
@property (nonatomic ,copy)NSString *is_success;

///
@property (nonatomic ,strong)NSArray<surveycomboitem_set> * surveycomboitem_set;

/// 取车图片-检车确认1照片url
@property (nonatomic ,copy)NSString *pic_get_confirm1_url;
/// 取车图片-检车确认2照片url
@property (nonatomic ,copy)NSString *pic_get_confirm2_url;
///
@property (nonatomic ,copy)NSString *driver_user_pic_url;
///
@property (nonatomic ,copy)NSString *driver_user_name;

///
@property (nonatomic ,strong)NSArray <surveypic_list>*surveypic_list;


///
@property (nonatomic ,strong)NSArray <failure_object> *failure_list;

@property (nonatomic ,strong)image_list *get_confirm;

@property (nonatomic ,strong)image_list *get_car;

@property (nonatomic ,strong)image_list *survey_fail_upload;

///
@property (nonatomic ,copy)NSString *drive_user_score;

@end