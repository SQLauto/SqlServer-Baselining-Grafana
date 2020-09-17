/* *********************** For Multi Instance Scenario ********************************************
-- ************************ CAUTION *************************************************************--
*/
use DBA
go

select @@SERVERNAME
go

if object_id('dbo.dm_os_performance_counters_nonsql') is not null
	drop table dbo.dm_os_performance_counters_nonsql;
go
create view dbo.dm_os_performance_counters_nonsql
as
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [SQL-A].[DBA].[dbo].[dm_os_performance_counters_nonsql]
go

if object_id('dbo.dm_os_performance_counters_nonsql_aggregated') is not null
	drop view dbo.dm_os_performance_counters_nonsql_aggregated;
go
create view dbo.dm_os_performance_counters_nonsql_aggregated
as
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [SQL-A].[DBA].[dbo].[dm_os_performance_counters_nonsql_aggregated_90days]
union all
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [SQL-A].[DBA].[dbo].[dm_os_performance_counters_nonsql_aggregated_1year]
go