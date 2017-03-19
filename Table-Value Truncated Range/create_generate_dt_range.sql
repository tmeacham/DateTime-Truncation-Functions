CREATE FUNCTION dbo.generate_dt_range(@interval AS NVARCHAR(8),
                                     @startdt AS  DATETIME,
                                     @enddt AS    DATETIME)
RETURNS @dt_range TABLE([DT_Range] DATETIME)
AS

/******************************************************************************************************
Author: Tom Meacham
Create date: 03/08/2017
Note: **Code is offered AS-IS with no warranties expressed or implied**
Description: 
Q. What Does this function do?
A. This Table valued function returns a range of dates based based on a three parameters.
1) @interval - one of the interval options from the list below
2) @startdt - the datetime value the interval range should start on
3) @enddt - the datetime value the interval range should end on
-
There are 17 predefined interval options:
(day, week, weekmon, month, quarter, halfyear, year, hour, 30min, 15min, 
10min, 5min, 1min, 30sec, 10sec, 5sec, 1sec)
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
         DECLARE @truncdate DATETIME;
         IF(@interval = N'day')
             BEGIN
                 SET @truncdate = DATEADD(dd, DATEDIFF(dd, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(dd, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(dd, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'week')
             BEGIN
                 SET @truncdate = DATEADD(ww, DATEDIFF(ww, 0, @startdt), 0) - 1;
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(ww, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ww, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'weekmon')
             BEGIN
                 SET @truncdate = DATEADD(ww, DATEDIFF(ww, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(ww, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ww, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'month')
             BEGIN
                 SET @truncdate = DATEADD(mm, DATEDIFF(mm, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(mm, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mm, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'quarter')
             BEGIN
                 SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(qq, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(qq, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'year')
             BEGIN
                 SET @truncdate = DATEADD(YY, DATEDIFF(YY, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(yy, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(yy, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'hour')
             BEGIN
                 SET @truncdate = DATEADD(hh, DATEDIFF(hh, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(hh, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(hh, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'30min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 30) * 30, 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(mi, 30, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 30, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'15min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 15) * 15, 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(mi, 15, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 15, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'10min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 10) * 10, 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(mi, 10, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 10, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'5min')
             BEGIN
                 SET @truncdate = DATEADD(mi, (DATEDIFF(mi, 0, @startdt) / 5) * 5, 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(mi, 5, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 5, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'1min')
             BEGIN
                 SET @truncdate = DATEADD(mi, DATEDIFF(mi, 0, @startdt), 0);
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(mi, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(mi, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'1sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, DATEDIFF(ss, '20000101', @startdt), '20000101');
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(ss, 1, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 1, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'30sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, '20000101', @startdt)/30*30), '20000101');
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(ss, 30, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 30, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'10sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, '20000101', @startdt)/10*10), '20000101');
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(ss, 10, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 10, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'5sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, '20000101', @startdt)/5*5), '20000101');
                 WITH dates
                      AS(
                      SELECT @truncdate AS [DT_RANGE]
                      UNION ALL
                      SELECT DATEADD(ss, 5, t.[DT_RANGE])
                      FROM dates AS t
                      WHERE DATEADD(ss, 5, t.[DT_RANGE]) <= @enddt)
                      INSERT INTO @dt_range
                             SELECT [DT_RANGE]
                             FROM dates
                             OPTION(MAXRECURSION 10000);
             END;
         IF(@interval = N'halfyear')
             BEGIN
                 IF DATEPART(qq, @startdt) IN(2, 4)
                     BEGIN
                         SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @startdt) - 1, 0);
                         WITH dates
                              AS(
                              SELECT @truncdate AS [DT_RANGE]
                              UNION ALL
                              SELECT DATEADD(MM, 6, t.[DT_RANGE])
                              FROM dates AS t
                              WHERE DATEADD(MM, 6, t.[DT_RANGE]) <= @enddt)
                              INSERT INTO @dt_range
                                     SELECT [DT_RANGE]
                                     FROM dates
                                     OPTION(MAXRECURSION 10000);
                     END;
                 ELSE
                     BEGIN
                         SET @truncdate = DATEADD(qq, DATEDIFF(qq, 0, @startdt), 0);
                         WITH dates
                              AS(
                              SELECT @truncdate AS [DT_RANGE]
                              UNION ALL
                              SELECT DATEADD(MM, 6, t.[DT_RANGE])
                              FROM dates AS t
                              WHERE DATEADD(MM, 6, t.[DT_RANGE]) <= @enddt)
                              INSERT INTO @dt_range
                                     SELECT [DT_RANGE]
                                     FROM dates
                                     OPTION(MAXRECURSION 10000);
                     END;
             END;
         RETURN;
     END;
GO
