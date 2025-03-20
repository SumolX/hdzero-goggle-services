/**
 *  RTC Driver Interface.
 *
 *  Provides management interfaces for accessing the
 *  Real-Time-Clock. All date/time representations
 *  are performed in UTC.
 */

#include "rtc.h"

#include <errno.h>
#include <fcntl.h>
#include <linux/rtc.h>
#include <memory.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <time.h>
#include <unistd.h>
#include <stdint.h>

/**
 *  Constants
 */
#define LEAPS_THRU_END_OF(y) ((y) / 4 - (y) / 100 + (y) / 400)

static const char *RTC_DEV = "/dev/rtc";
static const unsigned char RTC_DAYS_PER_MONTH[] = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

/**
 * Convert Gregorian date to seconds since 1970-01-01 00:00:00
 */
static inline uint64_t rtc_mktime(const struct rtc_date *rd) {
    unsigned int month = rd->month, year = rd->year;

    if (0 >= (int)(month -= 2)) {
        month += 12;
        year -= 1;
    }

    return ((((year / 4 - year / 100 + year / 400 + 367 * month / 12 + rd->day) +
              year * 365 - 719499) *
                 24 +
             rd->hour) *
                60 +
            rd->min) *
               60 +
           rd->sec;
}

/**
 *  Returns 1 if leap year is detected, otherwise 0.
 */
static inline int rtc_is_leap_year(unsigned int year) {
    return (!(year % 4) && (year % 100)) || !(year % 400);
}

/*
 * Returns number of days per month, month being (base 0).
 */
int rtc_days_per_month(unsigned int year, unsigned int month) {
    return (rtc_is_leap_year(year) && month == 1) + RTC_DAYS_PER_MONTH[month];
}

/*
 * Returns 0 if rtc_date is valid, otherwise -EINVAL (-22).
 */
int rtc_has_valid_date(struct rtc_date *rd) {
    return (rd->year - 1900 < 70 ||
            rd->month - 1 >= 12 ||
            rd->day > rtc_days_per_month(rd->year, rd->month - 1) ||
            rd->hour >= 24 ||
            rd->min >= 60 ||
            rd->sec >= 60)
               ? -EINVAL
               : 0;
}

/**
 *  Conversion Utils used to interact with internal data types.
 */
void rtc_rd2rt(const struct rtc_date *rd, struct rtc_time *rt) {
    rt->tm_year = rd->year - 1900;
    rt->tm_mon = rd->month - 1;
    rt->tm_mday = rd->day;
    rt->tm_hour = rd->hour;
    rt->tm_min = rd->min;
    rt->tm_sec = rd->sec;
}
void rtc_rt2rd(const struct rtc_time *rt, struct rtc_date *rd) {
    rd->year = rt->tm_year + 1900;
    rd->month = rt->tm_mon + 1;
    rd->day = rt->tm_mday;
    rd->hour = rt->tm_hour;
    rd->min = rt->tm_min;
    rd->sec = rt->tm_sec;
}

/**
 *  Conversion Utils used to interact with system data types.
 */
void rtc_rd2tv(const struct rtc_date *rd, struct timeval *tv) {
    tv->tv_sec = rtc_mktime(rd);
    tv->tv_usec = 0;
}
void rtc_tv2rd(const struct timeval *tv, struct rtc_date *rd) {
    struct rtc_time rt;
    unsigned int month, year;
    unsigned long secs;
    int days = tv->tv_sec / 86400;
    secs = tv->tv_sec - (unsigned int)days * 86400;
    rt.tm_wday = (days + 4) % 7;
    year = 1970 + days / 365;
    days -= (year - 1970) * 365 + LEAPS_THRU_END_OF(year - 1) - LEAPS_THRU_END_OF(1970 - 1);
    if (days < 0) {
        year -= 1;
        days += 365 + rtc_is_leap_year(year);
    }
    rt.tm_year = year - 1900;
    rt.tm_yday = days + 1;
    for (month = 0; month < 11; month++) {
        int newdays;

        newdays = days - rtc_days_per_month(year, month);
        if (newdays < 0) {
            break;
        }
        days = newdays;
    }
    rt.tm_mon = month;
    rt.tm_mday = days + 1;
    rt.tm_hour = secs / 3600;
    secs -= rt.tm_hour * 3600;
    rt.tm_min = secs / 60;
    rt.tm_sec = secs - rt.tm_min * 60;
    rt.tm_isdst = 0;
    rtc_rt2rd(&rt, rd);
}

/**
 *  Set Hardware Clock and synchronize OS Clock in UTC.
 */
int rtc_set_clock(const struct rtc_date *rd) {
    int ret = -1;
    int fd = open(RTC_DEV, O_WRONLY);
    if (fd >= 0) {
        struct rtc_time rt;
        struct timeval tv;
        rtc_rd2rt(rd, &rt);
        rtc_rd2tv(rd, &tv);

        if ((ret = settimeofday(&tv, NULL)) != 0) {
            printf("settimeofday(&tv, NULL) failed with errno(%d)", errno);
        }
        if (ret == 0 && (ret = ioctl(fd, RTC_SET_TIME, &rt)) != 0) {
            printf("ioctl(%d,RTC_SET_TIME,&rt) failed with errno(%d)", fd, errno);
        }
        close(fd);
    } else {
        printf("rtc_set_clock failed to open(%s, O_RDWR)", RTC_DEV);
    }
    return ret;
}

/**
 *  Get Hardware Clock
 */
void rtc_get_clock(struct rtc_date *rd) {
    int fd = open(RTC_DEV, O_RDONLY);
    if (fd >= 0) {
        struct rtc_time rt;
        if (ioctl(fd, RTC_RD_TIME, &rt) == 0) {
            rtc_rt2rd(&rt, rd);
        } else {
            printf("ioctl(%d,RTC_RD_TIME,rt) failed with errno(%d)", fd, errno);
        }
        close(fd);
    } else {
        printf("rtc_get_clock failed to open(%s, O_RDWR)", RTC_DEV);
    }
}

