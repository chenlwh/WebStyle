#import "LocalizedCurrentLocation.h"

@implementation LocalizedCurrentLocation

+ (NSString *)currentLocationStringForCurrentLanguage {

    NSDictionary *localizedStringDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                               @"Huidige locatie", @"nl",
                                               @"Current Location", @"en",
                                               @"Lieu actuel", @"fr",
                                               @"Aktueller Ort", @"de",
                                               @"Posizione attuale", @"it",
                                               @"現在地", @"ja",
                                               @"Ubicación actual", @"es",
                                               @"الموقع الحالي", @"ar",
                                               @"Ubicació actual", @"ca",
                                               @"Současná poloha", @"cs",
                                               @"Aktuel lokalitet", @"da",
                                               @"Τρέχουσα τοποθεσία", @"el",
                                               @"Current Location", @"en-GB",
                                               @"Nykyinen sijainti", @"fi",
                                               @"מיקום נוכחי", @"he",
                                               @"Trenutna lokacija", @"hr",
                                               @"Jelenlegi helyszín", @"hu",
                                               @"Lokasi Sekarang", @"id",
                                               @"현재 위치", @"ko",
                                               @"Lokasi Semasa", @"ms",
                                               @"Nåværende plassering", @"no",
                                               @"Bieżące położenie", @"pl",
                                               @"Localização Atual", @"pt",
                                               @"Localização actual", @"pt-PT",
                                               @"Loc actual", @"ro",
                                               @"Текущее размещение", @"ru",
                                               @"Aktuálna poloha", @"sk",
                                               @"Nuvarande plats", @"sv",
                                               @"ที่ตั้งปัจจุบัน", @"th",
                                               @"Şu Anki Yer", @"tr",
                                               @"Поточне місце", @"uk",
                                               @"Vị trí Hiện tại", @"vi",
                                               @"当前位置", @"zh-CN",
                                               @"目前位置", @"zh-TW",
                                               @"当前位置", @"zh-Hans",
                                               @"目前位置", @"zh-Hant",
                                               nil];
    
    NSString *localizedString;
    NSString *currentLanguageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    if ([localizedStringDictionary valueForKey:currentLanguageCode]) {
        localizedString = [NSString stringWithString:[localizedStringDictionary valueForKey:currentLanguageCode]];
    } else {
        localizedString = [NSString stringWithString:[localizedStringDictionary valueForKey:@"en"]];
    }
    
    [localizedStringDictionary release];
    return localizedString;
}


+ (NSString *)currentLocalizedLocality:(NSString*)locality
{
    NSArray *nameChineseArray = [NSArray arrayWithObjects:
                                 @"上海",@"重庆",@"北京",
                                 @"杭州",@"富阳",@"宁波",@"嘉兴",@"绍兴",@"金华",@"余姚",@"湖州",@"温州",
                                 @"南京",@"无锡",@"常州",@"苏州",@"常熟",@"南通",@"昆山",
                                 @"广州",@"深圳",@"珠海",@"佛山",@"东莞",@"中山",
                                 @"成都",
                                 @"武汉", nil];
    NSArray *namePinYinArray = [NSArray arrayWithObjects:
                                @"shanghai",@"chongqing",@"beijing",
                                @"hangzhou",@"fuyang",@"ningbo",@"jiaxing",@"shaoxing",@"jinhua",@"yuyao",@"huzhou",@"wenzhou",
                                @"nanjing",@"wuxi",@"changzhou",@"suzhou",@"changshu",@"nantong",@"kunshan",
                                @"guangzhou",@"shenzhen",@"zhuhai",@"foshan",@"dongguan",@"zhongshan",
                                @"chengdu",
                                @"wuhan", nil];
    
    NSMutableDictionary *supportedCityDictionary = [NSMutableDictionary dictionaryWithObjects:nameChineseArray forKeys:namePinYinArray];
    [supportedCityDictionary addEntriesFromDictionary:[NSDictionary dictionaryWithObjects:nameChineseArray forKeys:nameChineseArray]];
    
    
    NSString *name = [[locality copy] autorelease];
    name=[name lowercaseString];
    name=[name stringByReplacingOccurrencesOfString:@" " withString:@""];
    name=[name stringByReplacingOccurrencesOfString:@"city" withString:@""];
    name=[name stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    NSString *localizedString = [supportedCityDictionary objectForKey:name];
    
    return localizedString==nil?locality:localizedString;

}

@end
