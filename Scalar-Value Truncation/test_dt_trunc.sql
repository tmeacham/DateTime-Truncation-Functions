DECLARE @testdt DATETIME= '20171107 11:56:58:357';

SELECT
       upiv.[Function_Options] AS                   [Function_Options]
     , @testdt AS                                   Original_DateTime
     , upiv.DateTime_Result AS                      DateTime_Result
     --, DATEPART(year, upiv.DateTime_Result) AS      Year_INT
     --, DATEPART(QUARTER, upiv.DateTime_Result) AS   QuarterOfYear_INT
     --, DATEPART(month, upiv.DateTime_Result) AS     MonthOfYear_INT
     --, DATEPART(DAY, upiv.DateTime_Result) AS       DayOfMonth_INT
     --, DATEPART(DAYOFYEAR, upiv.DateTime_Result) AS DayOfYear_INT
     --, DATEPART(HOUR, upiv.DateTime_Result) AS      HourOfDay_INT
     --, DATEPART(MINUTE, upiv.DateTime_Result) AS    MinuteOfHour_INT
     --, DATEPART(SECOND, upiv.DateTime_Result) AS    SecondOfMinute_INT
     --, DATENAME(WEEKDAY, upiv.DateTime_Result) AS   NameOfDay
FROM
(
    SELECT
           dbo.dt_trunc('day', @testdt) AS      [day]
         , dbo.dt_trunc('week', @testdt) AS     [week]
         , dbo.dt_trunc('weekmon', @testdt) AS  [weekmon]
         , dbo.dt_trunc('month', @testdt) AS    [month]
         , dbo.dt_trunc('quarter', @testdt) AS  [quarter]
         , dbo.dt_trunc('halfyear', @testdt) AS [halfyear]
         , dbo.dt_trunc('year', @testdt) AS     [year]
         , dbo.dt_trunc('hour', @testdt) AS     [hour]
         , dbo.dt_trunc('30min', @testdt) AS    [30min]
         , dbo.dt_trunc('15min', @testdt) AS    [15min]
         , dbo.dt_trunc('10min', @testdt) AS    [10min]
         , dbo.dt_trunc('5min', @testdt) AS     [5min]
         , dbo.dt_trunc('1min', @testdt) AS     [1min]
         , dbo.dt_trunc('30sec', @testdt) AS    [30sec]
         , dbo.dt_trunc('10sec', @testdt) AS    [10sec]
         , dbo.dt_trunc('5sec', @testdt) AS     [5sec]
         , dbo.dt_trunc('1sec', @testdt) AS     [1sec]
) AS t1 UNPIVOT([DateTime_Result] FOR [Function_Options] IN(
                                                            [year]
                                                          , [halfyear]
                                                          , [quarter]
                                                          , [month]
                                                          , [week]
                                                          , [weekmon]
                                                          , [day]
                                                          , [hour]
                                                          , [30min]
                                                          , [15min]
                                                          , [10min]
                                                          , [5min]
                                                          , [1min]
                                                          , [30sec]
                                                          , [10sec]
                                                          , [5sec]
                                                          , [1sec])) upiv;