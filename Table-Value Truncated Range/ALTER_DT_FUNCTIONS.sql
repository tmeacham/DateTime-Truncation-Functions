ALTER FUNCTION dbo.dt_trunc(@trunctype AS NVARCHAR(8), @date AS DATETIME)
RETURNS DATETIME
AS

/**********************************************************************************************
Author: Tom Meacham
Website: https://github.com/tmeacham/DateTime-Truncation-Functions
Create date: 03/08/2017
Last Update: 02/18/2019
Note: **Code is offered AS-IS with no warranties expressed or implied**
Description: 
Q. What Does this function do?
A. This function truncates datetime to the level specified in the first parameter. 
The second parameter is the column in your data with the datetime attribute.
-
Q. Wait, what heck does 'truncate' mean?
A. In this context it means to remove a level of precision from your datetime field.
To clarify, it is likely your datetime data is captured at a certain level of granularity
anywhere from to the date to the millisecond. 
For time-series analysis in reporting, it is often necessary to summarize your data 
against consistent datetime intervals. Another way to think about it truncate is "round down to"
-
-
There are 17 predefined options:

+--------------------+------------------------------------------------------+
| Interval Parameter |                        Result                        |
+--------------------+------------------------------------------------------+
| day                | Truncates to the start of day                        |
| week               | Truncates to the start of week (Sunday)              |
| weekmon            | Truncates to the start of week (Monday)              |
| month              | Truncates to the start of month                      |
| quarter            | Truncates to the start of quarter                    |
| halfyear           | Truncates to the start of half year (6 month period) |
| year               | Truncates to the start of year                       |
| hour               | Truncates to the start of hour                       |
| 30min              | Truncates to the start of 30 min window              |
| 15min              | Truncates to the start of 15 min window              |
| 10min              | Truncates to the start of 10 min window              |
| 5min               | Truncates to the start of 5 min window               |
| 1min               | Truncates to the start of 1 min window               |
| 30sec              | Truncates to the start of 30 sec window              |
| 10sec              | Truncates to the start of 10 sec window              |
| 5sec               | Truncates to the start of 5 second window            |
| 1sec               | Truncates to the start of 1 second window            |
+--------------------+------------------------------------------------------+
**********************************************************************************************/

     BEGIN
         DECLARE @truncdate DATETIME;
		 --Declare the reference point variable. This is used to calculate the relative difference
		 --in smaller interval datetime calculations such as seconds to avoid an arithmetic overflow error.
         DECLARE @dtreferencepoint DATETIME= CONVERT(DATETIME, '20100101');
         IF(@trunctype = N'day')
             BEGIN
                 SET @truncdate = DATEADD(dd, DATEDIFF(dd, 0, @date), 0);
             END;
         IF(@trunctype = N'week')
             BEGIN
			     --Updated to be datefirst agnostic
                 SET @truncdate = DATEADD(dd, ((DATEPART(dw, CONVERT(DATE, @date)) + @@DateFirst - 7 + 13) % 7) * -1, CONVERT(DATE, @date));
             END;
         IF(@trunctype = N'weekmon')
             BEGIN
			     --Updated to be datefirst agnostic, as well as work correctly
                 SET @truncdate = DATEADD(dd, ((DATEPART(dw, CONVERT(DATE, @date)) + @@DateFirst - 1 + 13) % 7) * -1, CONVERT(DATE, @date));
             END;
         IF(@trunctype = N'month')
             BEGIN
                 SET @truncdate = DATEADD(mm, DATEDIFF(mm, 0, @date), 0);
             END;
         IF(@trunctype = N'quarter')
             BEGIN
                 SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @date), 0);
             END;
         IF(@trunctype = N'year')
             BEGIN
                 SET @truncdate = DATEADD(YY, DATEDIFF(YY, 0, @date), 0);
             END;
         IF(@trunctype = N'hour')
             BEGIN
                 SET @truncdate = DATEADD(hh, DATEDIFF(hh, 0, @date), 0);
             END;
         IF(@trunctype = N'30min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @date) / 30) * 30, 0);
             END;
         IF(@trunctype = N'15min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @date) / 15) * 15, 0);
             END;
         IF(@trunctype = N'10min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @date) / 10) * 10, 0);
             END;
         IF(@trunctype = N'5min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @date) / 5) * 5, 0);
             END;
         IF(@trunctype = N'1min')
             BEGIN
                 SET @truncdate = DATEADD(mi, DATEDIFF(mi, 0, @date), 0);
             END;
         IF(@trunctype = N'1sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, DATEDIFF(ss, @dtreferencepoint, @date), @dtreferencepoint);
             END;
         IF(@trunctype = N'30sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, @dtreferencepoint, @date) / 30 * 30), @dtreferencepoint);
             END;
         IF(@trunctype = N'10sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, @dtreferencepoint, @date) / 10 * 10), @dtreferencepoint);
             END;
         IF(@trunctype = N'5sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, @dtreferencepoint, @date) / 5 * 5), @dtreferencepoint);
             END;
         IF(@trunctype = N'halfyear')
             BEGIN
                 IF DATEPART(qq, @date) IN(2, 4)
                     BEGIN
                         SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @date) - 1, 0);
                     END;
                     ELSE
                     BEGIN
                         SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @date), 0);
                     END;
             END;
         RETURN(@truncdate);
     END;
GO
ALTER FUNCTION dbo.generate_dt_range(@interval AS NVARCHAR(8),
                                     @startdt AS  DATETIME,
                                     @enddt AS    DATETIME)
RETURNS @dt_range TABLE([DT_Range] DATETIME)
AS

/******************************************************************************************************
Author: Tom Meacham
Website: https://github.com/tmeacham/DateTime-Truncation-Functions
Created: 03/08/2017
Updated: 02/19/2019
Note: **Code is offered AS-IS with no warranties expressed or implied**
Description: 
Q. What Does this function do?
A. This Table valued function returns a range of dates based based on a three parameters.
1) @interval - one of the interval options from the list below
2) @startdt - the datetime value the interval range should start on
3) @enddt - the datetime value the interval range should end on
-
There are 17 predefined interval options:
+--------------------+------------------------------------------------------+
| Interval Parameter |                        Result                        |
+--------------------+------------------------------------------------------+
| day                | Truncates to the start of day                        |
| week               | Truncates to the start of week (Sunday)              |
| weekmon            | Truncates to the start of week (Monday)              |
| month              | Truncates to the start of month                      |
| quarter            | Truncates to the start of quarter                    |
| halfyear           | Truncates to the start of half year (6 month period) |
| year               | Truncates to the start of year                       |
| hour               | Truncates to the start of hour                       |
| 30min              | Truncates to the start of 30 min window              |
| 15min              | Truncates to the start of 15 min window              |
| 10min              | Truncates to the start of 10 min window              |
| 5min               | Truncates to the start of 5 min window               |
| 1min               | Truncates to the start of 1 min window               |
| 30sec              | Truncates to the start of 30 sec window              |
| 10sec              | Truncates to the start of 10 sec window              |
| 5sec               | Truncates to the start of 5 second window            |
| 1sec               | Truncates to the start of 1 second window            |
+--------------------+------------------------------------------------------+
-
Notes:
Before the range set is generated, the @startdt value is truncated (rounded down) to the selected
interval option. Once this is done the range will generate (by the selected interval option) until 
a range value is reached that is less than or equal to the @enddt parameter.
*all results are limited to a max of 10,000 rows.
-
Example of use:
SELECT dr.Date_Range
FROM dbo.generate_dt_range('week', '20170101', '20170318') AS dr;
-Returns
Date_Range
2017-01-01 00:00:00.000
2017-01-08 00:00:00.000
2017-01-15 00:00:00.000
2017-01-22 00:00:00.000
2017-01-29 00:00:00.000
2017-02-05 00:00:00.000
2017-02-12 00:00:00.000
2017-02-19 00:00:00.000
2017-02-26 00:00:00.000
2017-03-05 00:00:00.000
2017-03-12 00:00:00.000
-
Use Case:
The most common use for this table valued function would be to outer join your query into 
it so that there are no "gaps" in your time-series. For example, if you are looking for sales by
day, and there are days that do not have sales, this would lead to a gap in your data. 
**To acheive this join, I recommended using the 'dt_trunc' function in your summary query.
Example: 
SELECT
       dr.date_range
     , s.daily_sales
FROM   dbo.generate_dt_range('day', '20170101', '20170318') AS dr
       LEFT JOIN
(
    SELECT
           dbo.dt_trunc('day', sales.sale_date) AS [day_of_sale]
         , SUM(sales.sale_amount) AS               [daily_sales]
    FROM   sales_line_items AS sales
    GROUP BY
             dbo.dt_trunc('day', sales.sale_date)
) AS s ON dr.date_range = s.day_of_sale;

******************************************************************************************************/

     BEGIN
		 --Declare the trucated date variable
         DECLARE @truncdate DATETIME;
		 --Declare the reference point variable. This is used to calculate the relative difference
		 --in smaller interval datetime calculations such as seconds to avoid an arithmetic overflow error.
         DECLARE @dtreferencepoint DATETIME= CONVERT(DATETIME, '20100101');
         IF(@interval = N'day')
             BEGIN
                 SET @truncdate = DATEADD(dd, DATEDIFF(dd, 0, @startdt), 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(dd, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(dd, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'week')
             BEGIN --Datefirst agnostic method of getting the Sunday the input date "belongs to"
                 SET @truncdate = DATEADD(dd, ((DATEPART(dw, CONVERT(DATE, @startdt)) + @@DateFirst - 7 + 13) % 7) * -1, CONVERT(DATE, @startdt));
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(ww, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ww, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'weekmon')
             BEGIN --Datefirst agnostic method of getting the Monday the input date "belongs to"
                 SET @truncdate = DATEADD(dd, ((DATEPART(dw, CONVERT(DATE, @startdt)) + @@DateFirst - 1 + 13) % 7) * -1, CONVERT(DATE, @startdt));
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(ww, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ww, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'month')
             BEGIN
                 SET @truncdate = DATEADD(mm, DATEDIFF(mm, 0, @startdt), 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(mm, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mm, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'quarter')
             BEGIN
                 SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @startdt), 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(qq, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(qq, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'year')
             BEGIN
                 SET @truncdate = DATEADD(YY, DATEDIFF(YY, 0, @startdt), 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(yy, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(yy, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'hour')
             BEGIN
                 SET @truncdate = DATEADD(hh, DATEDIFF(hh, 0, @startdt), 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(hh, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(hh, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'30min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 30) * 30, 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(mi, 30, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 30, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'15min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 15) * 15, 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(mi, 15, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 15, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'10min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 10) * 10, 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(mi, 10, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 10, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'5min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 5) * 5, 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(mi, 5, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 5, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 10000);
             END;
         IF(@interval = N'1min')
             BEGIN
                 SET @truncdate = DATEADD(mi, DATEDIFF(mi, 0, @startdt), 0);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(mi, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 30000);
             END;
         IF(@interval = N'1sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, DATEDIFF(ss, @dtreferencepoint, @startdt), @dtreferencepoint);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(ss, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 30000);
             END;
         IF(@interval = N'30sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, @dtreferencepoint, @startdt) / 30 * 30), @dtreferencepoint);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(ss, 30, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 30, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 30000);
             END;
         IF(@interval = N'10sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, @dtreferencepoint, @startdt) / 10 * 10), @dtreferencepoint);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(ss, 10, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 10, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 30000);
             END;
         IF(@interval = N'5sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, @dtreferencepoint, @startdt) / 5 * 5), @dtreferencepoint);
                 WITH dates
                      AS (
                      SELECT
                             @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT
                             DATEADD(ss, 5, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 5, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT
                                    [DT_RANGE]
                             FROM dates OPTION(
                                               MAXRECURSION 30000);
             END;
         IF(@interval = N'halfyear')
             BEGIN
                 IF DATEPART(qq, @startdt) IN(2, 4)
                     BEGIN
                         SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @startdt) - 1, 0);
                         WITH dates
                              AS (
                              SELECT
                                     @truncdate AS [DT_RANGE]
                              UNION ALL
                              SELECT
                                     DATEADD(MM, 6, t.[DT_RANGE])
                              FROM dates AS t
                              WHERE DATEADD(MM, 6, t.[DT_RANGE]) <= @enddt)
                              INSERT INTO @dt_range
                                     SELECT
                                            [DT_RANGE]
                                     FROM dates OPTION(
                                                       MAXRECURSION 10000);
                     END;
                     ELSE
                     BEGIN
                         SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @startdt), 0);
                         WITH dates
                              AS (
                              SELECT
                                     @truncdate AS [DT_RANGE]
                              UNION ALL
                              SELECT
                                     DATEADD(MM, 6, t.[DT_RANGE])
                              FROM dates AS t
                              WHERE DATEADD(MM, 6, t.[DT_RANGE]) <= @enddt)
                              INSERT INTO @dt_range
                              SELECT
                                     [DT_RANGE]
                              FROM dates OPTION(
                                                MAXRECURSION 10000);
                     END;
             END;
         RETURN;
     END;
GO
