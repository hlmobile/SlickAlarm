//
//  Common.m
//  SlickTime
//
//  Created by Jin Bei on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

BOOL autoLockEnabled;

NSString *weatherSettingFileName()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WeatherSetting.dat"];
}

NSString *sleepSettingFileName()
{
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SleepSetting.dat"];
}

BOOL isIncludingWeekday(int value, int weekday)
{
    int temp = value;
    if (weekday == RepeatOptionOff)
    {
        if (value == 0)
            return YES;
        else
            return NO;
    }
    
    else
    {
        for (int i = 1; i < weekday; i++)
        {
            temp = temp / 10;
        }
        int digit = temp % 10;
        return (digit == 1);
    }
    return NO;
}

int setWeekday(int value, int weekday, BOOL bInclude)
{
    if (weekday == RepeatOptionOff)
        return 0;
    int digit = 1;
    for (int i = 1; i < weekday; i++)
        digit *= 10;
    BOOL bAlreadyIncluded = isIncludingWeekday(value, weekday);
    int temp = value;
    if (bAlreadyIncluded && !bInclude)
        temp -=digit;
    else if (!bAlreadyIncluded && bInclude)
        temp += digit;
    return temp;
    
}

void logAllNotifications(NSString *message)
{
    NSLog(@"------------------------------------------------");
    if (message)
        NSLog(@"%@", message);
    
    NSArray *schedule = [UIApplication sharedApplication].scheduledLocalNotifications;
	
	int count = [schedule count];
    //Getting Schedules;
	for (int idx = 0; idx < count; idx++) {
		
		id obj = [schedule objectAtIndex: idx];
		if (obj && [obj isKindOfClass:[UILocalNotification class]]) {
            
            unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSLog(@"Notification %d > ", idx);
            UILocalNotification *wakeUp = (UILocalNotification *)obj;
            NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]; 
            NSDateComponents *logAlarmComps = [gregorian components: unitFlags fromDate: wakeUp.fireDate];
            NSLog(@"Fire Date: %d/%d/%d - %d:%d", [logAlarmComps year], [logAlarmComps month], [logAlarmComps day], [logAlarmComps hour], [logAlarmComps minute] );

		}
		
	}
    
}

WeatherType weatherTypeFromCode(int code)
{
    int weatherTypeList[] = {
        WeatherTypeThunderStorm,    //0	tornado
        WeatherTypeThunderStorm,    //1	tropical storm
        WeatherTypeThunderStorm,    //2	hurricane
        WeatherTypeThunderStorm,    //3	severe thunderstorms
        WeatherTypeThunderStorm,    //4	thunderstorms
        WeatherTypeSnowy,           //5	mixed rain and snow
        WeatherTypeSnowy,           //6	mixed rain and sleet
        WeatherTypeSnowy,           //7	mixed snow and sleet
        WeatherTypeRainy,           //8	freezing drizzle
        WeatherTypeRainy,           //9	drizzle
        WeatherTypeRainy,           //10	freezing rain
        WeatherTypeRainy,           //11	showers
        WeatherTypeRainy,           //12	showers
        WeatherTypeSnowy,           //13	snow flurries
        WeatherTypeSnowy,           //14	light snow showers
        WeatherTypeSnowy,           //15	blowing snow
        WeatherTypeSnowy,           //16	snow
        WeatherTypeSnowy,           //17	hail
        WeatherTypeSnowy,           //18	sleet
        WeatherTypePartlyCloudy,    //19	dust
        WeatherTypePartlyCloudy,    //20	foggy
        WeatherTypePartlyCloudy,    //21	haze
        WeatherTypePartlyCloudy,    //22	smoky
        WeatherTypePartlyCloudy,    //23	blustery
        WeatherTypePartlyCloudy,    //24	windy
        WeatherTypePartlyCloudy,    //25	cold
        WeatherTypePartlyCloudy,    //26	cloudy
        WeatherTypePartlyCloudy,    //27	mostly cloudy (night)
        WeatherTypePartlyCloudy,    //28	mostly cloudy (day)
        WeatherTypePartlyCloudy,    //29	partly cloudy (night)
        WeatherTypePartlyCloudy,    //30	partly cloudy (day)
        WeatherTypeSunny,           //31	clear (night)
        WeatherTypeSunny,           //32	sunny
        WeatherTypeSunny,           //33	fair (night)
        WeatherTypeSunny,           //34	fair (day)
        WeatherTypeRainy,           //35	mixed rain and hail
        WeatherTypeSunny,           //36	hot
        WeatherTypeThunderStorm,    //37	isolated thunderstorms
        WeatherTypeThunderStorm,    //38	scattered thunderstorms
        WeatherTypeThunderStorm,    //39	scattered thunderstorms
        WeatherTypeRainy,           //40	scattered showers
        WeatherTypeSnowy,           //41	heavy snow
        WeatherTypeSnowy,           //42	scattered snow showers
        WeatherTypeSnowy,           //43	heavy snow
        WeatherTypePartlyCloudy,    //44	partly cloudy
        WeatherTypeThunderStorm,    //45	thundershowers
        WeatherTypeSnowy,           //46	snow showers
        WeatherTypeThunderStorm    //47	isolated thundershowers
    };
    if (code < 0 || code > 47)
        return WeatherTypeSunny;
    return weatherTypeList[code];
}

int celciusToFahrenheit(int temp)
{
    return temp * 9 / 5 + 32;
}

NSString *soundFileNameAtIndex(int index)
{
    NSArray *songList = [NSArray arrayWithObjects:ALARM_SOUND_LIST, nil];
    return [songList objectAtIndex:index];
}

float getBatteryLevel()
{
    float batLeft;
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    batLeft = [myDevice batteryLevel];
    
    if ([[UIDevice currentDevice] batteryState] != UIDeviceBatteryStateUnplugged)
    {
        batLeft *= -1;
    }
    return batLeft;
}