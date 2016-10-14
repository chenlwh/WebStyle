//
//  GWRequestDurationDAO.h
//  GWMovie
//
//  Created by wushengtao on 15/5/25.
//  Copyright (c) 2015年 gewara. All rights reserved.
//

#import "GWBaseDAO.h"

//#ifdef __USE_DEBUGTOOL__
/**
 http400：
 httpGt400:
 http500: serverError
 http502:
 http503:
 */
@interface GWRequestDurationDAO : GWBaseDAO
@property (nonatomic, copy) NSString<GWDBKeyPrimary, GWDBKeyNotNull>* method;
@property (nonatomic, copy) NSString<GWDBKeyPrimary, GWDBKeyNotNull>* ip;
@property (nonatomic, assign) NSUInteger successCount;          //成功次数
@property (nonatomic, assign) NSTimeInterval successTotalTime;  //成功总时间，毫秒
@property (nonatomic, assign) NSUInteger socketTmeout;
@property (nonatomic, assign) NSUInteger http400;    //黑名单
@property (nonatomic, assign) NSUInteger httpGt400;  //状态码是401~499
@property (nonatomic, assign) NSUInteger http500;    //serverError
@property (nonatomic, assign) NSUInteger http502;
@property (nonatomic, assign) NSUInteger http503;
#if defined(DEBUG)
@property (nonatomic, copy) NSString<GWDBKeyAddition>* sender;
@property (nonatomic, copy) NSString<GWDBKeyAddition>* networkStatus;
#endif

- (void)paramsAdditionmWithDuration:(GWRequestDurationDAO*)dao;

- (BOOL)valueIsIncorrect;

@end
//#endif


#ifdef __USE_DEBUGTOOL__

typedef enum {
    GWRequestDurationStatusSending = 0,
    GWRequestDurationStatusFailure,
    GWRequestDurationStatusSuccess,
}GWRequestDurationStatus;

@interface GWRequestDebugDurationDAO : GWBaseDAO
@property (nonatomic, copy) NSString<GWDBKeyPrimary, GWDBKeyNotNull>* sendTime;
@property (nonatomic, copy) NSString<GWDBKeyPrimary, GWDBKeyNotNull>* method;
@property (nonatomic, copy) NSString* httpURL;
@property (nonatomic, copy) NSString* sender;
@property (nonatomic, copy) NSString* duration;
@property (nonatomic, copy) NSString* networkStatus;
@property (nonatomic, assign) GWRequestDurationStatus stauts;
@end
#endif