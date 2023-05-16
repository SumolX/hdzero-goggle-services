#pragma once

/**
 *  RTC Driver Interface.
 *
 *  Provides management interfaces for accessing the
 *  Real-Time-Clock. All date/time representations
 *  are performed in UTC.
 */

#include <sys/time.h>

/**
 *  Structure representing the Date/Time of the RTC clock.
 */
struct rtc_date {
    int year;  // YYYY
    int month; // 1 - 12
    int day;   // 1 - 31
    int hour;  // 0 - 23
    int min;   // 0 - 59
    int sec;   // 0 - 59
};

/*
 * Returns number of days per month, month being (base 0).
 */
int rtc_days_per_month(unsigned int year, unsigned int month);

/*
 * Returns 0 if rtc_date is valid, otherwise -EINVAL (-22).
 */
int rtc_has_valid_date(struct rtc_date *rd);

/**
 *  Conversion Utils used to interact with system data types.
 */
void rtc_rd2tv(const struct rtc_date *rd, struct timeval *tv);
void rtc_tv2rd(const struct timeval *tv, struct rtc_date *rd);

/**
 *  Set Hardware Clock and synchronize OS Clock in UTC.
 *  Returns 0 upon success otherwise -1.
 */
int rtc_set_clock(const struct rtc_date *rd);

/**
 *  Get Hardware Clock in UTC.
 */
void rtc_get_clock(struct rtc_date *rd);
