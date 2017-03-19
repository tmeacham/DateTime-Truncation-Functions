ALTER FUNCTION dbo.dt_trunc(@trunctype AS NVARCHAR(8),
                            @date AS      DATETIME)
RETURNS DATETIME
AS

/**********************************************************************************************
Author: Tom Meacham
Create date: 03/08/2017
Website: https://github.com/tmeacham/DateTime-Truncation-Functions
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
day		  - Truncates to the start of day
week		  - Truncates to the start of week (Sunday)
weekmon	  - Truncates to the start of week (Monday)
month	  - Truncates to the start of month
quarter	  - Truncates to the start of quarter
halfyear	  - Truncates to the start of half year (6 month period)
year		  - Truncates to the start of year

hour		  - Truncates to the start of hour
30min	  - Truncates to the start of 30 min window
15min	  - Truncates to the start of 15 min window
10min	  - Truncates to the start of 10 min window
5min		  - Truncates to the start of 5 min window
1min		  - Truncates to the start of 1 min window
30sec	  - Truncates to the start of 30 sec window
10sec	  - Truncates to the start of 10 sec window
5sec		  - Truncates to the start of 5 second window
1sec		  - Truncates to the start of 1 second window
**********************************************************************************************/

     BEGIN
         DECLARE @truncdate DATETIME;
         IF(@trunctype = N'day')
             BEGIN
                 SET @truncdate = DATEADD(dd, DATEDIFF(dd, 0, @date), 0);
             END;
         IF(@trunctype = N'week')
             BEGIN
                 SET @truncdate = DATEADD(ww, DATEDIFF(ww, 0, @date), 0) - 1;
             END;
         IF(@trunctype = N'weekmon')
             BEGIN
                 SET @truncdate = DATEADD(ww, DATEDIFF(ww, 0, @date), 0);
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
                 SET @truncdate = DATEADD(ss, DATEDIFF(ss, '20000101', @date), '20000101');
             END;
         IF(@trunctype = N'30sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, '20000101', @date)/30*30), '20000101');
             END;
         IF(@trunctype = N'10sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, '20000101', @date)/10*10), '20000101');
             END;
         IF(@trunctype = N'5sec')
             BEGIN
                 SET @truncdate = DATEADD(ss, (DATEDIFF(ss, '20000101', @date)/5*5), '20000101');
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