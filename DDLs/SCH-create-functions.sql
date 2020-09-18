use DBA
go

-- drop function dbo.utc2local
-- Deterministic. CI Index Seek doing Seek Predicate for all Keys. Parallelism
declare @tsql nvarchar(max);
declare @utc_2_local_diff_ms bigint = Datediff(MILLISECOND, SYSUTCDATETIME(), SYSDATETIME());

set @tsql = '
create or alter function dbo.utc2local (@utc_datetime datetime2)
returns table with schemabinding
as
return
(
	select [local_time] = Dateadd(MILLISECOND, '+cast(@utc_2_local_diff_ms as varchar)+', @utc_datetime)
)
'
--print @tsql
EXEC (@tsql)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.utc2local'), 'IsDeterministic')
go

-- drop function dbo.local2utc
-- Deterministic. CI Index Seek doing Seek Predicate for all Keys. Parallelism
declare @tsql nvarchar(max);
declare @local_2_utc_diff_ms bigint = Datediff(MILLISECOND, SYSDATETIME(), SYSUTCDATETIME());

set @tsql = '
create or alter function dbo.local2utc (@local_datetime datetime2)
returns table with schemabinding
as
return
(
	select [utc_time] = DATEADD(MILLISECOND, '+cast(@local_2_utc_diff_ms as varchar)+', @local_datetime)
)
'
--print @tsql
EXEC (@tsql)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.local2utc'), 'IsDeterministic')
go


-- drop function dbo.perfmon2utc
-- Deterministic. CI Index Seek doing Seek Predicate for all Keys. Parallelism
declare @tsql nvarchar(max);
declare @local_2_utc_diff_s bigint = Datediff(MILLISECOND, SYSDATETIME(), SYSUTCDATETIME());

set @tsql = '
create or alter function dbo.perfmon2utc (@CounterDateTime varchar(24))
returns table with schemabinding
as
return
(
	--select [utc_time] = DATEADD(second, '+cast(@local_2_utc_diff_s as varchar)+', @local_datetime)
	select [utc_time] = DATEADD(MILLISECOND, '+cast(@local_2_utc_diff_s as varchar)+', CONVERT(DATETIME2, SUBSTRING(@CounterDateTime, 1, 23), 102))
)
'
--print @tsql
EXEC (@tsql)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.perfmon2utc'), 'IsDeterministic')
go

-- drop function dbo.perfmon2local 
create or alter function dbo.perfmon2local (@CounterDateTime varchar(24))
returns table with schemabinding
as
return
(
	--select [local_time] = Cast(Cast(@CounterDateTime as CHAR(23)) as datetime2)
	--select [local_time] = convert(datetime2, convert(CHAR(23), @CounterDateTime))
	select [local_time] = CONVERT(datetime2, SUBSTRING(@CounterDateTime, 1, 23), 102)
)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.perfmon2local'), 'IsDeterministic')
go

create or alter function dbo.aggregate_time (@collection_time datetime2, @time_interval_minutes smallint = 10)
returns table with schemabinding
as
return
with t_date_string as
(
	select [aggregate_time] = CONVERT(varchar(10),@collection_time,120) +' '+ RIGHT('0' + CAST(DATEPART(HOUR,@collection_time) AS Varchar(2)), 2) + ':' + RIGHT('0' + CAST(DATEPART(MINUTE,@collection_time)/@time_interval_minutes*@time_interval_minutes AS varchar(2)), 2)+ ':00'
)
select convert(smalldatetime,aggregate_time,21) as aggregate_time from t_date_string
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.aggregate_time'), 'IsDeterministic')
go


--	drop function dbo.time2duration
create or alter function dbo.time2duration (@time varchar(27), @unit varchar(20) = 'second')
returns table with schemabinding
as
return
(
	select [duration] =
			case when @unit in ('datetime','datetime2','smalldatetime')
				then	Concat
							(
								RIGHT('00'+CAST(ISNULL((datediff(second,@time,GETDATE()) / 3600 / 24), 0) AS VARCHAR(2)),2)
								,' '
								,RIGHT('00'+CAST(ISNULL(datediff(second,@time,GETDATE()) / 3600  % 24, 0) AS VARCHAR(2)),2)
								,':'
								,RIGHT('00'+CAST(ISNULL(datediff(second,@time,GETDATE()) / 60 % 60, 0) AS VARCHAR(2)),2)
								,':'
								,RIGHT('00'+CAST(ISNULL(datediff(second,@time,GETDATE()) % 3600 % 60, 0) AS VARCHAR(2)),2)
							)
				when @unit in ('second','ss','s')
				then	Concat
							(
								RIGHT('00'+CAST(ISNULL((@time / 3600 / 24), 0) AS VARCHAR(2)),2)
								,' '
								,RIGHT('00'+CAST(ISNULL(@time / 3600  % 24, 0) AS VARCHAR(2)),2)
								,':'
								,RIGHT('00'+CAST(ISNULL(@time / 60 % 60, 0) AS VARCHAR(2)),2)
								,':'
								,RIGHT('00'+CAST(ISNULL(@time % 3600 % 60, 0) AS VARCHAR(2)),2)
							)
				else null
			end
)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.aggregate_time_dummy'), 'IsDeterministic')
go



--select /* Convert 5428424 seconds into [DD hh:mm:ss] */	master.dbo.time2duration(5428424,'s');

/*

use DBA
go
 
-- Version 01 - Scaler Function without schemabinding. CI index Seek doing RANGE SCAN
create function dbo.utc2local (@utc_datetime datetime2)
returns datetime2
as
begin
    declare @local_time datetime2;
    select @local_time = Dateadd(MILLISECOND, Datediff(MILLISECOND, Getutcdate(), Getdate()), @utc_datetime);
 
    return (@local_time);
end
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.utc2local'), 'IsDeterministic')
go


-- Version 02 - Scaler Function with Schemabinding. CI index Seek doing RANGE SCAN
create function dbo.utc2local (@utc_datetime datetime2)
returns datetime2 with schemabinding
as
begin
    declare @local_time datetime2;
    select @local_time = Dateadd(MILLISECOND, Datediff(MILLISECOND, Getutcdate(), Getdate()), @utc_datetime);
 
    return (@local_time);
end
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.utc2local'), 'IsDeterministic')
go


-- Version 03 - Deterministic. CI index Seek doing Seek Predicate for all keys. But No Parallelism
declare @tsql nvarchar(max);
declare @utc_2_local_diff_ms bigint = Datediff(MILLISECOND, SYSUTCDATETIME(), SYSDATETIME());

set @tsql = '
create or alter function dbo.utc2local (@utc_datetime datetime2)
returns datetime2 with schemabinding
as
begin
	declare @local_time datetime2;
	select @local_time = Dateadd(MILLISECOND, '+cast(@utc_2_local_diff_ms as varchar)+', @utc_datetime);

	return (@local_time);
end
'
--print @tsql
EXEC (@tsql)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.utc2local'), 'IsDeterministic')
go


-- drop function dbo.utc2local
-- Version 04  - Deterministic. CI Index Seek doing Seek Predicate for all Keys. Parallelism
declare @tsql nvarchar(max);
declare @utc_2_local_diff_ms bigint = Datediff(MILLISECOND, SYSUTCDATETIME(), SYSDATETIME());

set @tsql = '
create or alter function dbo.utc2local (@utc_datetime datetime2)
returns table with schemabinding
as
return
(
	select [local_time] = Dateadd(MILLISECOND, '+cast(@utc_2_local_diff_ms as varchar)+', @utc_datetime)
)
'
--print @tsql
EXEC (@tsql)
go

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.utc2local'), 'IsDeterministic')
go

create or alter function dbo.perfmon2utc (@CounterDateTime varchar(24))
returns datetime2 with schemabinding
as
begin
	declare @utc_time datetime2;
	select @utc_time = DATEADD(second, DATEDIFF(second, SYSDATETIME(), GETUTCDATE()), CONVERT(DATETIME, SUBSTRING(@CounterDateTime, 1, 23), 102));

	return (@utc_time);
end
go

create or alter function dbo.aggregate_time (@collection_time datetime2, @time_interval_minutes smallint = 10)
returns datetime2 with schemabinding
as
begin
	declare @aggreate_time datetime2;
	select @aggreate_time = CONVERT(varchar(10),@collection_time,120) +' '+ RIGHT('0' + CAST(DATEPART(HOUR,@collection_time) AS Varchar(2)), 2) + ':' + RIGHT('0' + CAST(DATEPART(MINUTE,@collection_time)/@time_interval_minutes*@time_interval_minutes AS varchar(2)), 2)+ ':00';

	return (@aggreate_time);
end
go


create or alter function dbo.time2duration (@time varchar(27), @unit varchar(20) = 'second')
returns varchar(30) with schemabinding
as
begin
	declare @duration varchar(30);

	if @unit in ('datetime','datetime2','smalldatetime')
	begin
		select @duration =
				Concat
					(
						RIGHT('00'+CAST(ISNULL((datediff(second,@time,GETDATE()) / 3600 / 24), 0) AS VARCHAR(2)),2)
						,' '
						,RIGHT('00'+CAST(ISNULL(datediff(second,@time,GETDATE()) / 3600  % 24, 0) AS VARCHAR(2)),2)
						,':'
						,RIGHT('00'+CAST(ISNULL(datediff(second,@time,GETDATE()) / 60 % 60, 0) AS VARCHAR(2)),2)
						,':'
						,RIGHT('00'+CAST(ISNULL(datediff(second,@time,GETDATE()) % 3600 % 60, 0) AS VARCHAR(2)),2)
					) --as [dd hh:mm:ss]
	end

	if @unit in ('second','ss','s')
	begin
		select @duration =
				Concat
					(
						RIGHT('00'+CAST(ISNULL((@time / 3600 / 24), 0) AS VARCHAR(2)),2)
						,' '
						,RIGHT('00'+CAST(ISNULL(@time / 3600  % 24, 0) AS VARCHAR(2)),2)
						,':'
						,RIGHT('00'+CAST(ISNULL(@time / 60 % 60, 0) AS VARCHAR(2)),2)
						,':'
						,RIGHT('00'+CAST(ISNULL(@time % 3600 % 60, 0) AS VARCHAR(2)),2)
					) --as [dd hh:mm:ss]
	end

	return (@duration);
end
go

*/