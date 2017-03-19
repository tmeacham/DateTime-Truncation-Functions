# Datetime Truncation User-Defined Functions for SQL Server

This project contains two user-defined functions. One is a scalar-value function, the other is table-valued function.

## dt_trunc
**dt_trunc** accepts two parameters @trunctype and @date and return a datetime datatype.

### The syntax for the function is:
```
dbo.dt_trunc( '<trunctype>'  , <datetime field> || <expression> )
```
There are 17 options for the 'trunctype' parameter:
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



