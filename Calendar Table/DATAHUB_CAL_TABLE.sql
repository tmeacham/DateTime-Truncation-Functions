SELECT

/*
THIS SCRIPT WILL CREATE A RESULT SET IN THE FORM OF A CALENDAR TABLE
WITH THE ATTRIBUTES DESCRIBED BELOW. USE THE TABLE TO SET THE DATATYPES
FOR THE LOAD TASK OF THE ETL JOB. IT ONLY NEEDS TO BE RUN ONCE.
GO TO LINE 248 OF SCRIPT TO MODIFY START AND END DATE OF CALENDER
YOU MAY ALSO NEED ADJUST CREATTION OF THE NUMBER TABLE THERE
+------------------+--------------------------+-----------+
| ORDINAL_POSITION |       COLUMN_NAME        | DATA_TYPE |
+------------------+--------------------------+-----------+
|                1 | DateKey                  | int       |
|                2 | DateDT                   | datetime  |
|                3 | DateStyle112             | char      |
|                4 | DateStyle101             | char      |
|                5 | DateStyleMMYYY           | char      |
|                6 | DayOfWeek                | int       |
|                7 | DayOfWeek_Mon_First      | int       |
|                8 | DayOfWeekName            | nvarchar  |
|                9 | DayOfWeekNameShort       | nvarchar  |
|               10 | DayIsWeekDay             | int       |
|               11 | DayIsWeekEnd             | int       |
|               12 | DayOfWeekInstanceInMonth | bigint    |
|               13 | DayOfMonth               | int       |
|               14 | DayOfMonthSuffix         | varchar   |
|               15 | DayOfYear                | int       |
|               16 | WeekOfYear               | int       |
|               17 | ISOweekOfYear            | int       |
|               18 | MonthOfYear              | int       |
|               19 | MonthName                | nvarchar  |
|               20 | MonthNameShort           | nvarchar  |
|               21 | QuarterOfYear            | int       |
|               22 | QuarterOfYearString      | varchar   |
|               23 | Year                     | int       |
|               24 | YearAndQuarter           | varchar   |
|               25 | FirstDayOfWeek_Sun       | datetime  |
|               26 | FirstDayOfWeek_Mon       | datetime  |
|               27 | FirstDayOfMonth          | datetime  |
|               28 | FirstDayOfQuarter        | datetime  |
|               29 | FirstDayOfYear           | datetime  |
|               30 | LastDayOfWeek_Sat        | datetime  |
|               31 | LastDayOfWeek_Sun        | datetime  |
|               32 | LastDayOfMonth           | datetime  |
|               33 | LastDayOfQuarter         | datetime  |
|               34 | LastDayOfYear            | datetime  |
|               35 | FirstDayOfNextWeek_Sun   | datetime  |
|               36 | FirstDayOfNextWeek_Mon   | datetime  |
|               37 | FirstDayOfNextMonth      | datetime  |
|               38 | FirstDayOfNextQuarter    | datetime  |
|               39 | FirstDayOfNextYear       | datetime  |
|               40 | LastDOWInMonth           | int       |
|               41 | HOLIDAY_NAME             | varchar   |
+------------------+--------------------------+-----------+
*/

       [FIN].[DateKey]
     , [FIN].[DateDT]
     , [FIN].[DateStyle112]
     , [FIN].[DateStyle101]
     , [FIN].[DateStyleMMYYY]
     , [FIN].[DayOfWeek]
     , [FIN].[DayOfWeek_Mon_First]
     , [FIN].[DayOfWeekName]
     , [FIN].[DayOfWeekNameShort]
     , [FIN].[DayIsWeekDay]
     , [FIN].[DayIsWeekEnd]
     , [FIN].[DayOfWeekInstanceInMonth]
     , [FIN].[DayOfMonth]
     , [FIN].[DayOfMonthSuffix]
     , [FIN].[DayOfYear]
     , [FIN].[WeekOfYear]
     , [FIN].[ISOweekOfYear]
     , [FIN].[MonthOfYear]
     , [FIN].[MonthName]
     , [FIN].[MonthNameShort]
     , [FIN].[QuarterOfYear]
     , [FIN].[QuarterOfYearString]
     , [FIN].[Year]
     , [FIN].[YearAndQuarter]
     , [FIN].[FirstDayOfWeek_Sun]
     , [FIN].[FirstDayOfWeek_Mon]
     , [FIN].[FirstDayOfMonth]
     , [FIN].[FirstDayOfQuarter]
     , [FIN].[FirstDayOfYear]
     , [FIN].[LastDayOfWeek_Sat]
     , [FIN].[LastDayOfWeek_Sun]
     , [FIN].[LastDayOfMonth]
     , [FIN].[LastDayOfQuarter]
     , [FIN].[LastDayOfYear]
     , [FIN].[FirstDayOfNextWeek_Sun]
     , [FIN].[FirstDayOfNextWeek_Mon]
     , [FIN].[FirstDayOfNextMonth]
     , [FIN].[FirstDayOfNextQuarter]
     , [FIN].[FirstDayOfNextYear]
     , [FIN].[LastDOWInMonth] 
  
/********************************************************************************* 
BELOW ARE EXAMPLES OF HOW TO ADD DETERMINISTIC COMPANY HOLIDAYS 
YOU CAN USE EXPRESSIONS OR MODIFY THIS SCRIPT TO CREATE A BOOLEAN 
IsHoliday FIELD TO TO DETERMIN IF WORK IS BEING DONE OF THAT DAY FOR EXAMPLE 
*********************************************************************************/ 
  
     , CASE
           WHEN([FIN].[DateDT] = [FirstDayOfYear])
           THEN 'New Year''s Day'
           WHEN([DayOfWeekInstanceInMonth] = 3
                AND [MonthName] = 'January'
                AND [DayOfWeekName] = 'Monday')
           THEN 'Martin Luther King Day'    -- (3rd Monday in January) 
           WHEN([DayOfWeekInstanceInMonth] = 3
                AND [MonthName] = 'February'
                AND [DayOfWeekName] = 'Monday')
           THEN 'President''s Day'          -- (3rd Monday in February) 
           WHEN([LastDOWInMonth] = 1
                AND [MonthName] = 'May'
                AND [DayOfWeekName] = 'Monday')
           THEN 'Memorial Day'              -- (last Monday in May) 
           WHEN([MonthName] = 'July'
                AND [DayOfMonth] = 4)
           THEN 'Independence Day'          -- (July 4th) 
           WHEN([DayOfWeekInstanceInMonth] = 1
                AND [MonthName] = 'September'
                AND [DayOfWeekName] = 'Monday')
           THEN 'Labour Day'                -- (first Monday in September) 
           WHEN([DayOfWeekInstanceInMonth] = 2
                AND [MonthName] = 'October'
                AND [DayOfWeekName] = 'Monday')
           THEN 'Columbus Day'              -- Columbus Day (second Monday in October) 
           WHEN([MonthName] = 'November'
                AND [DayOfMonth] = 11)
           THEN 'Veterans'' Day'            -- Veterans' Day (November 11th) 
           WHEN([DayOfWeekInstanceInMonth] = 4
                AND [MonthName] = 'November'
                AND [DayOfWeekName] = 'Thursday')
           THEN 'Thanksgiving Day'          -- Thanksgiving Day (fourth Thursday in November) 
           WHEN([MonthName] = 'December'
                AND [DayOfMonth] = 25)
           THEN 'Christmas Day'
       END AS [HOLIDAY_NAME]
FROM
(
    SELECT
           CAST([BASETABLE].[DateStyle112] AS INT) AS [DateKey] --For Clustered Indexing 
         , [BASETABLE].[DateDT]
         , [BASETABLE].[DateStyle112]
         , [BASETABLE].[DateStyle101]
         , [BASETABLE].[DateStyleMMYYY]
         , [BASETABLE].[DayOfWeek]
         , [BASETABLE].[DayOfWeek_Mon_First]
         , [BASETABLE].[DayOfWeekName]
         , [BASETABLE].[DayOfWeekNameShort]
         , [BASETABLE].[DayIsWeekDay]
         , [BASETABLE].[DayIsWeekEnd]
         , ROW_NUMBER() OVER(PARTITION BY [BASETABLE].[FirstDayOfMonth]
                                        , [BASETABLE].[DayOfWeek] ORDER BY [BASETABLE].[DateDT]) AS [DayOfWeekInstanceInMonth]
         , [BASETABLE].[DayOfMonth]
         , [BASETABLE].[DayOfMonthSuffix]
         , [BASETABLE].[DayOfYear]
         , [BASETABLE].[WeekOfYear]
         , [BASETABLE].[ISOweekOfYear]
         , [BASETABLE].[MonthOfYear]
         , [BASETABLE].[MonthName]
         , [BASETABLE].[MonthNameShort]
         , [BASETABLE].[QuarterOfYear]
         , [BASETABLE].[QuarterOfYearString]
         , [BASETABLE].[Year]
         , [BASETABLE].[YearAndQuarter]
         , [BASETABLE].[FirstDayOfWeek_Sun]
         , [BASETABLE].[FirstDayOfWeek_Mon]
         , [BASETABLE].[FirstDayOfMonth]
         , [BASETABLE].[FirstDayOfQuarter]
         , [BASETABLE].[FirstDayOfYear]
         , DATEADD(DAY, -1, DATEADD(WEEK, 1, [BASETABLE].[FirstDayOfWeek_Sun])) AS [LastDayOfWeek_Sat]
         , DATEADD(DAY, -1, DATEADD(WEEK, 1, [BASETABLE].[FirstDayOfWeek_Mon])) AS [LastDayOfWeek_Sun]
         , DATEADD(DAY, -1, DATEADD(MONTH, 1, [BASETABLE].[FirstDayOfMonth])) AS [LastDayOfMonth]
         , DATEADD(DAY, -1, DATEADD(QUARTER, 1, [BASETABLE].[FirstDayOfQuarter])) AS [LastDayOfQuarter]
         , DATEADD(DAY, -1, DATEADD(YEAR, 1, [BASETABLE].[FirstDayOfYear])) AS [LastDayOfYear]
         , DATEADD(WEEK, 1, [BASETABLE].[FirstDayOfWeek_Sun]) AS [FirstDayOfNextWeek_Sun]
         , DATEADD(WEEK, 1, [BASETABLE].[FirstDayOfWeek_Mon]) AS [FirstDayOfNextWeek_Mon]
         , DATEADD(MONTH, 1, [BASETABLE].[FirstDayOfMonth]) AS [FirstDayOfNextMonth]
         , DATEADD(QUARTER, 1, [BASETABLE].[FirstDayOfQuarter]) AS [FirstDayOfNextQuarter]
         , DATEADD(YEAR, 1, [BASETABLE].[FirstDayOfYear]) AS [FirstDayOfNextYear]
         , CONVERT(INT, ROW_NUMBER() OVER(PARTITION BY [BASETABLE].[FirstDayOfMonth]
                                                     , [BASETABLE].[DayOfWeek] ORDER BY [DateDT] DESC)) AS [LastDOWInMonth]
    FROM
(
    SELECT
           [DATES].[DateDT]
         , CONVERT(CHAR(8), [DATES].[DateDT], 112) AS [DateStyle112]
         , CONVERT(CHAR(10), [DATES].[DateDT], 101) AS [DateStyle101]
         , CONVERT(CHAR(6), LEFT(CONVERT(CHAR(10), [DATES].[DateDT], 101), 2) + LEFT(CONVERT(CHAR(8), [DATES].[DateDT], 112), 4)) AS [DateStyleMMYYY]
         , DATEPART([WEEKDAY], [DATES].[DateDT]) AS [DayOfWeek]
         , (DATEPART([WEEKDAY], [DATES].[DateDT]) + 5) % 7 + 1 AS [DayOfWeek_Mon_First]
         , DATENAME([DW], [DATES].[DateDT]) AS [DayOfWeekName]
         , LEFT(DATENAME([DW], [DATES].[DateDT]), 3) AS [DayOfWeekNameShort]
         , CASE
               WHEN DATEPART([WEEKDAY], [DATES].[DateDT]) NOT IN(1, 7)
               THEN 1
               ELSE 0
           END AS [DayIsWeekDay]
         , CASE
               WHEN DATEPART([WEEKDAY], [DATES].[DateDT]) IN(1, 7)
               THEN 1
               ELSE 0
           END AS [DayIsWeekEnd]
         , DATEPART(DAY, [DATES].[DateDT]) AS [DayOfMonth]
         , CASE
               WHEN DATEPART(DAY, [DATES].[DateDT]) / 10 = 1
               THEN 'th'
               ELSE CASE RIGHT(DATEPART(DAY, [DATES].[DateDT]), 1)
                        WHEN '1'
                        THEN 'st'
                        WHEN '2'
                        THEN 'nd'
                        WHEN '3'
                        THEN 'rd'
                        ELSE 'th'
                    END
           END AS [DayOfMonthSuffix]
         , DATEPART([DAYOFYEAR], [DATES].[DateDT]) AS [DayOfYear]
         , DATEPART(WEEK, [DATES].[DateDT]) AS [WeekOfYear]
         , DATEPART([ISO_WEEK], [DATES].[DateDT]) AS [ISOweekOfYear]
         , DATEPART(MONTH, [DATES].[DateDT]) AS [MonthOfYear]
         , DATENAME([MM], [DATES].[DateDT]) AS MonthName
         , LEFT(DATENAME(MONTH, [DATES].[DateDT]), 3) AS [MonthNameShort]
         , DATEPART(QUARTER, [DATES].[DateDT]) AS [QuarterOfYear]
         , 'Q'+CAST(DATEPART(QUARTER, [DATES].[DateDT]) AS CHAR(1)) AS [QuarterOfYearString]
         , DATEPART(YEAR, [DATES].[DateDT]) AS [Year]
         , CONVERT(CHAR(4), DATEPART(YEAR, [DATES].[DateDT]))+'-Q'+CONVERT(CHAR(1), DATEPART(QUARTER, [DATES].[DateDT])) AS [YearAndQuarter]
         , CONVERT(DATETIME, DATEADD(dd, ((DATEPART(dw, CONVERT(DATE, [DATES].[DateDT])) + @@DateFirst - 7 + 13) % 7) * -1, CONVERT(DATE, [DATES].[DateDT]))) AS [FirstDayOfWeek_Sun]
         , CONVERT(DATETIME, DATEADD(dd, ((DATEPART(dw, CONVERT(DATE, [DATES].[DateDT])) + @@DateFirst - 1 + 13) % 7) * -1, CONVERT(DATE, [DATES].[DateDT]))) AS [FirstDayOfWeek_Mon]
         , DATEADD(MONTH, DATEDIFF(MONTH, 0, [DATES].[DateDT]), 0) AS [FirstDayOfMonth]
         , DATEADD(QUARTER, DATEDIFF(QUARTER, 0, [DATES].[DateDT]), 0) AS [FirstDayOfQuarter]
         , DATEADD(YEAR, DATEDIFF(YEAR, 0, [DATES].[DateDT]), 0) AS [FirstDayOfYear]
    FROM
( 
  
/******************************************************************************** 
THIS QUERY RETURNS A RANGE DATES AT AND INTERVAL OF 1 DAY IN DATETIME FORMAT. 
IT IS LIMITED BY THE PARAMETERS PROVIDED 
***********************************************************************************/ 
  
    SELECT
           CAST([SeedTable].[DayDate] AS DATETIME) AS [DateDT]
    FROM
(
    SELECT
           DATEADD([dd], ROW_NUMBER() OVER(ORDER BY
(
    SELECT
           NULL
)), DATEADD([dd], DATEDIFF([dd], 0, '20000101'), 0)-1) AS [DayDate] --StartDate Parameter Goes Here /*@startdate*/ 
    FROM sys.objects AS s1
         CROSS JOIN sys.objects AS s2
         CROSS JOIN sys.objects AS S3 
                -- CROSS JOIN MORE OR LESS FOR NUMBERS TO SEED ON 
) AS SeedTable
    WHERE [DayDate] <= '20700101' --EndDate Paramerter Goes Here @enddate  
) AS DATES
) AS BASETABLE
) AS FIN
ORDER BY
         [FIN].[DateDT]
