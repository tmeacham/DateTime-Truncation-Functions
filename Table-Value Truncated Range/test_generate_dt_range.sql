DECLARE @interval AS NVARCHAR(8) = 'week'
      , @startdt AS  DATETIME    = '20170105' 
      , @enddt AS    DATETIME    = '20170318';

/*
@startdt is truncated to the start of the interval selected before the
range generates
Interval Options:
day, week, weekmon, month, quarter, halfyear, year, hour, 30min, 15min, 
10min, 5min, 1min, 30sec, 10sec, 5sec, 1sec
*/

SELECT dtrange.Date_Range
FROM dbo.generate_dt_range(@interval, @startdt, @enddt) AS dtrange;