//
//  UrlDefine.h
//  WebStyle
//
//  Created by 刘丹 on 16/8/30.
//  Copyright © 2016年 liudan. All rights reserved.
//

#ifndef UrlDefine_h
#define UrlDefine_h

#define KGWHostURL @"http://114.55.224.29/blacksheepservice/prefervideo?"

#define KPreferPlayer @"http://114.55.224.29/blacksheepservice/preferplayer"

//顶部推荐的视频
#define KPreferVideoURL @"http://114.55.224.29/blacksheepservice/prefervideo"

//首页新主播视频
#define kNewPlayerVideo @"http://114.55.224.29/blacksheepservice/newplayervideo"

//首页大主播视频
#define kHotPlayerVideo @"http://114.55.224.29/blacksheepservice/hotplayervideo"

//首页视频排行
#define kTopVideo @"http://114.55.224.29/blacksheepservice/topvideo"

//搜索
#define kQueryInfo  @"http://114.55.224.29/blacksheepservice/search?query="

//注册  @"http://114.55.224.29/blacksheepservice/register?name=username&pwd=password"
#define kRegisterMethod @"http://114.55.224.29/blacksheepservice/register?"

//登录  http://114.55.224.29/blacksheepservice/login?name=username&pwd=password
#define kLoginMethod @"http://114.55.224.29/blacksheepservice/login?"

//我的爆款 登录之后才能查询；
#define kMyPopular @"http://114.55.224.29/blacksheepservice/selfprefer?name="

//打开视频商品
#define kGoodsVideo @"http://114.55.224.29/blacksheepservice/goodsvideo?param="

//查询是否收藏 name=params&id=params
#define kQueryIsFavorite @"http://114.55.224.29/blacksheepservice/isfavorite?"

//添加取消收藏；name=params&id=params
#define kDoFavorite @"http://114.55.224.29/blacksheepservice/favorite?"
#endif /* UrlDefine_h */
