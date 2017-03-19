# Datetime Truncation User-Defined Functions for SQL Server

This project contains two user-defined functions. One is a scalar-value function, the other is table-valued function.

## dt_trunc
**dt_trunc** is a scalar-valued function and accepts two parameters @trunctype and @date and return a datetime datatype.

### dt_trunc Function Syntax:
```
dbo.dt_trunc( '<trunctype>'  , <datetime field> || <expression> )
```
There are 17 predefined options for the 'trunctype' parameter:
```sql
'day'     - Rounds down to the start of day
'week'    - Rounds down to the start of week (Sunday)
'weekmon' - Rounds down to the start of week (Monday)
'month'   - Rounds down to the start of month
'quarter' - Rounds down to the start of quarter
'halfyear'- Rounds down to the start of half year (6 month period)
'year'    - Rounds down to the start of year
'hour'    - Rounds down to the start of hour
'30min'   - Rounds down to the start of 30 min period
'15min'   - Rounds down to the start of 15 min period
'10min'   - Rounds down to the start of 10 min period
'5min'    - Rounds down to the start of 5 min period
'1min'    - Rounds down to the start of 1 min period
'30sec'   - Rounds down to the start of 30 sec period
'10sec'   - Rounds down to the start of 10 sec period
'5sec'    - Rounds down to the start of 5 second period
'1sec'    - Rounds down to the start of 1 second period
```

### Example of output:
```
+------------------+-------------------------+-------------------------+
| Function_Options |    Original_DateTime    |     DateTime_Result     |
+------------------+-------------------------+-------------------------+
| year             | 2017-11-07 11:56:58.357 | 2017-01-01 00:00:00.000 |
| halfyear         | 2017-11-07 11:56:58.357 | 2017-07-01 00:00:00.000 |
| quarter          | 2017-11-07 11:56:58.357 | 2017-10-01 00:00:00.000 |
| month            | 2017-11-07 11:56:58.357 | 2017-11-01 00:00:00.000 |
| week             | 2017-11-07 11:56:58.357 | 2017-11-05 00:00:00.000 |
| weekmon          | 2017-11-07 11:56:58.357 | 2017-11-06 00:00:00.000 |
| day              | 2017-11-07 11:56:58.357 | 2017-11-07 00:00:00.000 |
| hour             | 2017-11-07 11:56:58.357 | 2017-11-07 11:00:00.000 |
| 30min            | 2017-11-07 11:56:58.357 | 2017-11-07 11:30:00.000 |
| 15min            | 2017-11-07 11:56:58.357 | 2017-11-07 11:45:00.000 |
| 10min            | 2017-11-07 11:56:58.357 | 2017-11-07 11:50:00.000 |
| 5min             | 2017-11-07 11:56:58.357 | 2017-11-07 11:55:00.000 |
| 1min             | 2017-11-07 11:56:58.357 | 2017-11-07 11:56:00.000 |
| 30sec            | 2017-11-07 11:56:58.357 | 2017-11-07 11:56:30.000 |
| 10sec            | 2017-11-07 11:56:58.357 | 2017-11-07 11:56:50.000 |
| 5sec             | 2017-11-07 11:56:58.357 | 2017-11-07 11:56:55.000 |
| 1sec             | 2017-11-07 11:56:58.357 | 2017-11-07 11:56:58.000 |
+------------------+-------------------------+-------------------------+
```

## generate_dt_range
**generate_dt_range** is a table-valued function and accepts three parameters @interval, @startdt, and @enddt and returns a contiguous range of datatype fields. Before the range is generated, the @startdt parameter is rounded down the start of the interval defined in the @interval parameter. After that, the range will continue to generate until until it reaches the inclusive datetime boundry set in the @enddt parameter. 

### generate_dt_range Function Syntax:
```
dbo.generate_dt_range( '<interval>'  , <datetime value> , <datetime value> )
```
There are 17 predefined options for the 'trunctype' parameter:
```sql
'day'     - Rounds @startdt down to the start of day
'week'    - Rounds @startdt down to the start of week (Sunday)
'weekmon' - Rounds @startdt down to the start of week (Monday)
'month'   - Rounds @startdt down to the start of month
'quarter' - Rounds @startdt down to the start of quarter
'halfyear'- Rounds @startdt down to the start of half year (6 month period)
'year'    - Rounds @startdt down to the start of year
'hour'    - Rounds @startdt down to the start of hour
'30min'   - Rounds @startdt down to the start of 30 min period
'15min'   - Rounds @startdt down to the start of 15 min period
'10min'   - Rounds @startdt down to the start of 10 min period
'5min'    - Rounds @startdt down to the start of 5 min period
'1min'    - Rounds @startdt down to the start of 1 min period
'30sec'   - Rounds @startdt down to the start of 30 sec period
'10sec'   - Rounds @startdt down to the start of 10 sec period
'5sec'    - Rounds @startdt down to the start of 5 second period
'1sec'    - Rounds @startdt down to the start of 1 second period
```

### Example of use and output:

```sql
--Example of 'week' parameter option
SELECT t.Date_Range
FROM dbo.generate_dt_range( 'week', '20170105 3:56:47', '20170318 17:32:38' ) AS t;

returns:

+-------------------------+
|       Date_Range        |
+-------------------------+
| 2017-01-01 00:00:00.000 |
| 2017-01-08 00:00:00.000 |
| 2017-01-15 00:00:00.000 |
| 2017-01-22 00:00:00.000 |
| 2017-01-29 00:00:00.000 |
| 2017-02-05 00:00:00.000 |
| 2017-02-12 00:00:00.000 |
| 2017-02-19 00:00:00.000 |
| 2017-02-26 00:00:00.000 |
| 2017-03-05 00:00:00.000 |
| 2017-03-12 00:00:00.000 |
+-------------------------+

--Example of 'month' parameter option
SELECT t.Date_Range
FROM dbo.generate_dt_range( 'month', '20170105 3:56:47', '20170318 17:32:38' ) AS t;

returns:

+-------------------------+
|       Date_Range        |
+-------------------------+
| 2017-01-01 00:00:00.000 |
| 2017-02-01 00:00:00.000 |
| 2017-03-01 00:00:00.000 |
+-------------------------+

--Example of '15min' parameter option
SELECT t.Date_Range
FROM dbo.generate_dt_range( '15min', '20170318 3:56:47', '20170318 17:32:38' ) AS t;

returns:

+-------------------------+
|       Date_Range        |
+-------------------------+
| 2017-03-18 13:45:00.000 |
| 2017-03-18 14:00:00.000 |
| 2017-03-18 14:15:00.000 |
| 2017-03-18 14:30:00.000 |
| 2017-03-18 14:45:00.000 |
| 2017-03-18 15:00:00.000 |
| 2017-03-18 15:15:00.000 |
| 2017-03-18 15:30:00.000 |
| 2017-03-18 15:45:00.000 |
| 2017-03-18 16:00:00.000 |
| 2017-03-18 16:15:00.000 |
| 2017-03-18 16:30:00.000 |
| 2017-03-18 16:45:00.000 |
| 2017-03-18 17:00:00.000 |
| 2017-03-18 17:15:00.000 |
| 2017-03-18 17:30:00.000 |
+-------------------------+
```
