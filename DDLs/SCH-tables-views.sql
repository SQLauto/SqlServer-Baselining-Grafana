USE [DBA]
GO
--	drop table dbo.[dm_os_performance_counters]
CREATE TABLE dbo.[dm_os_performance_counters]
(
	[collection_time] [datetime2] NOT NULL DEFAULT SYSDATETIME(),
	[server_name] varchar(256) NOT NULL DEFAULT @@SERVERNAME,
	[object_name] [nvarchar](128) NOT NULL,
	[counter_name] [nvarchar](128) NOT NULL,
	[instance_name] [nvarchar](128) NULL,
	[cntr_value] [bigint] NOT NULL,
	[cntr_type] [int] NOT NULL,
	[id] smallint NOT NULL
) ON [fg_ci]
GO
ALTER TABLE dbo.dm_os_performance_counters
   ADD CONSTRAINT pk_dm_os_performance_counters PRIMARY KEY CLUSTERED (collection_time, object_name, counter_name, id)
   WITH ( FILLFACTOR = 90, SORT_IN_TEMPDB = ON ) ON [fg_ci]
GO

-- drop table dbo.[dm_os_performance_counters_aggregated_90days]
CREATE TABLE dbo.[dm_os_performance_counters_aggregated_90days]
(
	[collection_time] [datetime2] NOT NULL,
	[server_name] varchar(256) NOT NULL DEFAULT @@SERVERNAME,
	[object_name] [nvarchar](128) NOT NULL,
	[counter_name] [nvarchar](128) NOT NULL,
	[instance_name] [nvarchar](128) NULL,
	[cntr_value] [bigint] NOT NULL,
	[cntr_type] [int] NOT NULL,
	[id] smallint NOT NULL
) ON [fg_archive]
GO
ALTER TABLE dbo.dm_os_performance_counters_aggregated_90days
   ADD CONSTRAINT pk_dm_os_performance_counters_aggregated_90days PRIMARY KEY CLUSTERED (collection_time, object_name, counter_name, id)
   WITH ( FILLFACTOR = 90, SORT_IN_TEMPDB = ON ) ON [fg_archive]
GO


-- drop table dbo.[dm_os_performance_counters_aggregated_1year]
CREATE TABLE dbo.[dm_os_performance_counters_aggregated_1year]
(
	[collection_time] [datetime2] NOT NULL,
	[server_name] varchar(256) NOT NULL DEFAULT @@SERVERNAME,
	[object_name] [nvarchar](128) NOT NULL,
	[counter_name] [nvarchar](128) NOT NULL,
	[instance_name] [nvarchar](128) NULL,
	[cntr_value] [bigint] NOT NULL,
	[cntr_type] [int] NOT NULL,
	[id] smallint NOT NULL
) ON [fg_archive]
GO
ALTER TABLE dbo.dm_os_performance_counters_aggregated_1year
   ADD CONSTRAINT pk_dm_os_performance_counters_aggregated_1year PRIMARY KEY CLUSTERED (collection_time, object_name, counter_name, id)
   WITH ( FILLFACTOR = 90, SORT_IN_TEMPDB = ON ) ON [fg_archive]
GO

-- drop view dbo.dm_os_performance_counters_aggregated
create view dbo.dm_os_performance_counters_aggregated
with schemabinding
as
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [dbo].[dm_os_performance_counters_aggregated_90days]
union all
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [dbo].[dm_os_performance_counters_aggregated_1year]
go


CREATE TABLE [dbo].[dm_os_sys_memory]
(
	[collection_time] [datetime2] NOT NULL DEFAULT SYSDATETIME(),
	[server_name] [nvarchar](128) NOT NULL DEFAULT @@SERVERNAME,
	[total_physical_memory_kb] [numeric](30, 2) NOT NULL,
	[available_physical_memory_kb] [numeric](30, 2) NOT NULL,
	[used_page_file_kb] [numeric](30, 2) NOT NULL,
	[system_cache_kb] [numeric](30, 2) NOT NULL,
	[free_memory_kb] [numeric](30, 2) NOT NULL,
	[system_memory_state_desc] [nvarchar](256) NOT NULL,
	[memory_usage_percentage] AS (cast(((total_physical_memory_kb-available_physical_memory_kb) * 100.0) / total_physical_memory_kb as numeric(20,2)))
) ON [fg_ci]
GO
ALTER TABLE [dbo].[dm_os_sys_memory]
   ADD CONSTRAINT pk_dm_os_sys_memory PRIMARY KEY CLUSTERED (collection_time) ON [fg_ci];
GO


-- drop table [dbo].[dm_os_sys_memory_aggregated]
CREATE TABLE [dbo].[dm_os_sys_memory_aggregated]
(
	[collection_time] [datetime2] NOT NULL,
	--[server_name] [nvarchar](128) NOT NULL,
	[total_physical_memory_kb] [numeric](30, 2) NOT NULL,
	[available_physical_memory_kb] [numeric](30, 2) NOT NULL,
	[used_page_file_kb] [numeric](30, 2) NOT NULL,
	[system_cache_kb] [numeric](30, 2) NOT NULL,
	[free_memory_kb] [numeric](30, 2) NOT NULL,
	--[system_memory_state_desc] [nvarchar](256) NOT NULL,
	[memory_usage_percentage] AS (cast(((total_physical_memory_kb-available_physical_memory_kb) * 100.0) / total_physical_memory_kb as numeric(20,2)))
)  ON [fg_archive]
GO
ALTER TABLE [dbo].[dm_os_sys_memory_aggregated] ADD CONSTRAINT pk_dm_os_sys_memory_aggregated PRIMARY KEY CLUSTERED (collection_time) ON [fg_archive];
GO


--DROP  TABLE [dbo].[dm_os_performance_counters_nonsql]
CREATE TABLE [dbo].[dm_os_performance_counters_nonsql]
(
	[collection_time] [datetime2] NOT NULL,
	[server_name] [varchar](256) NOT NULL,
	[object_name] [varchar](1024) NOT NULL,
	[counter_name] [varchar](1024) NOT NULL,
	[instance_name] [varchar](1024) NULL,
	[cntr_value] [float] NOT NULL,
	[cntr_type] [int] NOT NULL,
	[id] [smallint] NOT NULL
) ON [fg_ci]
GO
ALTER TABLE dbo.dm_os_performance_counters_nonsql
   ADD CONSTRAINT pk_dm_os_performance_counters_nonsql PRIMARY KEY CLUSTERED (collection_time, object_name, counter_name, id) ON [fg_ci];
GO


CREATE TABLE [dbo].[dm_os_performance_counters_nonsql_aggregated_90days]
(
	[collection_time] [datetime2] NOT NULL,
	[server_name] [varchar](256) NOT NULL,
	[object_name] [varchar](1024) NOT NULL,
	[counter_name] [varchar](1024) NOT NULL,
	[instance_name] [varchar](1024) NULL,
	[cntr_value] [float] NOT NULL,
	[cntr_type] [int] NOT NULL,
	[id] [smallint] NOT NULL
) ON [fg_archive]
GO
ALTER TABLE dbo.dm_os_performance_counters_nonsql_aggregated_90days
   ADD CONSTRAINT pk_dm_os_performance_counters_nonsql_aggregated_90days PRIMARY KEY CLUSTERED (collection_time, object_name, counter_name, id)
   ON [fg_archive];
GO

CREATE TABLE [dbo].[dm_os_performance_counters_nonsql_aggregated_1year]
(
	[collection_time] [datetime2] NOT NULL,
	[server_name] [varchar](256) NOT NULL,
	[object_name] [varchar](1024) NOT NULL,
	[counter_name] [varchar](1024) NOT NULL,
	[instance_name] [varchar](1024) NULL,
	[cntr_value] [float] NOT NULL,
	[cntr_type] [int] NOT NULL,
	[id] [smallint] NOT NULL
) ON [fg_archive]
GO
ALTER TABLE dbo.dm_os_performance_counters_nonsql_aggregated_1year
   ADD CONSTRAINT pk_dm_os_performance_counters_nonsql_aggregated_1year PRIMARY KEY CLUSTERED (collection_time, object_name, counter_name, id)
   ON [fg_archive];
GO

create view dbo.dm_os_performance_counters_nonsql_aggregated
with schemabinding
as
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [dbo].[dm_os_performance_counters_nonsql_aggregated_90days]
union all
select [collection_time], [server_name], [object_name], [counter_name], [instance_name], [cntr_value], [cntr_type], [id]
from [dbo].[dm_os_performance_counters_nonsql_aggregated_1year]
go


--DROP TABLE [dbo].[dm_os_sys_info]
CREATE TABLE [dbo].[dm_os_sys_info]
(
	[collection_time] [datetime2] NOT NULL,
	[server_name] [varchar](256) NOT NULL,
	[sqlserver_start_time] [datetime] NOT NULL,
	[wait_stats_cleared_time] [smalldatetime] NOT NULL,
	[cpu_count] [smallint] NOT NULL,
	[physical_memory_kb] [bigint] NOT NULL,
	[max_workers_count] [smallint] NOT NULL,
	[virtual_machine_type] [int] NOT NULL,
	[softnuma_configuration_desc] [varchar](256) NOT NULL,
	[socket_count] [tinyint] NOT NULL,
	[cores_per_socket] [smallint] NOT NULL,
	[numa_node_count] [tinyint] NOT NULL
) ON [fg_ci]
GO
ALTER TABLE [dbo].[dm_os_sys_info]
   ADD CONSTRAINT pk_dm_os_sys_info PRIMARY KEY CLUSTERED (collection_time) ON [fg_ci];
GO
CREATE NONCLUSTERED INDEX nci_dm_os_sys_info__sqlserver_start_time__wait_stats_cleared_time
	ON [dbo].[dm_os_sys_info] (sqlserver_start_time, wait_stats_cleared_time) ON [fg_nci]
GO


--	drop table [dbo].[WaitStats]
CREATE TABLE [dbo].[WaitStats]
(
	[Collection_Time] [datetime2](7) NOT NULL,
	[RowNum] [smallint] NOT NULL,
	[WaitType] [nvarchar](120) NOT NULL,
	[Wait_S] [decimal](20, 2) NOT NULL,
	[Resource_S] [decimal](20, 2) NOT NULL,
	[Signal_S] [decimal](20, 2) NOT NULL,
	[WaitCount] [bigint] NOT NULL,
	[Percentage] [decimal](5, 2) NULL,
	--[Percentage] AS ([Wait_S]*100)/SUM([Wait_S])OVER(PARTITION BY [CollectionTime]),
	[AvgWait_S] AS ([Wait_S]/[WaitCount]),
	[AvgRes_S] AS ([Resource_S]/[WaitCount]),
	[AvgSig_S] AS ([Signal_S]/[WaitCount]),
	[Help_URL] AS (CONVERT([xml],'https://www.sqlskills.com/help/waits/'+[WaitType]))
) ON [fg_ci]
GO
ALTER TABLE dbo.WaitStats
   ADD CONSTRAINT pk_WaitStats PRIMARY KEY CLUSTERED (Collection_Time, RowNum, WaitType) ON [fg_ci];
GO


--	drop table [dbo].[WaitStats_aggregated]
CREATE TABLE [dbo].[WaitStats_aggregated]
(
	[Collection_Time] [datetime2] NOT NULL,
	[RowNum] [smallint] NOT NULL,
	[WaitType] [nvarchar](120) NOT NULL,
	[Wait_S] [decimal](20, 2) NOT NULL,
	[Resource_S] [decimal](20, 2) NOT NULL,
	[Signal_S] [decimal](20, 2) NOT NULL,
	[WaitCount] [bigint] NOT NULL,
	[Percentage] [decimal](5, 2) NULL,
	--[Percentage] AS ([Wait_S]*100)/SUM([Wait_S])OVER(PARTITION BY [CollectionTime]),
	[AvgWait_S] AS ([Wait_S]/[WaitCount]),
	[AvgRes_S] AS ([Resource_S]/[WaitCount]),
	[AvgSig_S] AS ([Signal_S]/[WaitCount]),
	[Help_URL] AS (CONVERT([xml],'https://www.sqlskills.com/help/waits/'+[WaitType]))
) ON [fg_archive]
GO
ALTER TABLE dbo.WaitStats_aggregated
   ADD CONSTRAINT pk_WaitStats_aggregated PRIMARY KEY CLUSTERED (Collection_Time, RowNum, WaitType)  ON [fg_archive];
GO


CREATE TABLE [dbo].[dm_os_process_memory]
(
	[collection_time] [datetime2] NOT NULL DEFAULT SYSDATETIME(),
	[SQL Server Memory Usage (MB)] [bigint] NULL,
	[page_fault_count] [bigint] NOT NULL,
	[memory_utilization_percentage] [int] NOT NULL,
	[available_commit_limit_kb] [bigint] NOT NULL,
	[process_physical_memory_low] [bit] NOT NULL,
	[process_virtual_memory_low] [bit] NOT NULL,
	[SQL Server Locked Pages Allocation (MB)] [bigint] NULL,
	[SQL Server Large Pages Allocation (MB)] [bigint] NULL
) ON [fg_ci]
GO
alter table [dbo].[dm_os_process_memory]
	add constraint pk_dm_os_process_memory primary key clustered (collection_time) ON [fg_ci]
go


CREATE TABLE [dbo].[dm_os_process_memory_aggregated]
(
	[collection_time] [datetime2] NOT NULL,
	[SQL Server Memory Usage (MB)] [bigint] NULL,
	[page_fault_count] [bigint] NOT NULL,
	[memory_utilization_percentage] [int] NOT NULL,
	[available_commit_limit_kb] [bigint] NOT NULL,
	[process_physical_memory_low] [bit] NOT NULL,
	[process_virtual_memory_low] [bit] NOT NULL,
	[SQL Server Locked Pages Allocation (MB)] [bigint] NULL,
	[SQL Server Large Pages Allocation (MB)] [bigint] NULL
) ON [fg_archive]
GO
alter table [dbo].[dm_os_process_memory_aggregated]
	add constraint pk_dm_os_process_memory_aggregated primary key clustered (collection_time) ON [fg_archive]
go


CREATE TABLE [dbo].[dm_os_ring_buffers]
(
	[collection_time] [datetime2] NOT NULL DEFAULT SYSDATETIME(),
	[system_cpu_utilization] [int] NOT NULL,
	[sql_cpu_utilization] [int] NOT NULL
) ON [fg_ci]
GO
alter table [dbo].[dm_os_ring_buffers]
	add constraint pk_dm_os_ring_buffers primary key clustered (collection_time) ON [fg_ci]
go


CREATE TABLE [dbo].[dm_os_ring_buffers_aggregated]
(
	[collection_time] [datetime2] NOT NULL,
	[system_cpu_utilization] [int] NOT NULL,
	[sql_cpu_utilization] [int] NOT NULL
) ON [fg_archive]
GO
alter table [dbo].[dm_os_ring_buffers_aggregated]
	add constraint pk_dm_os_ring_buffers_aggregated primary key clustered (collection_time) ON [fg_archive]
go


CREATE TABLE [dbo].[dm_os_memory_clerks]
(
	[collection_time] [datetime2] NOT NULL DEFAULT SYSDATETIME(),
	[memory_clerk] [nvarchar](60) NOT NULL,
	[size_mb] [bigint] NULL
) ON [fg_ci]
GO
alter table [dbo].[dm_os_memory_clerks]
	add constraint pk_dm_os_memory_clerks primary key clustered (collection_time,memory_clerk)
	ON [fg_ci]
go

-- drop table [dbo].[dm_os_memory_clerks_aggregated]
CREATE TABLE [dbo].[dm_os_memory_clerks_aggregated]
(
	[collection_time] [datetime2] NOT NULL,
	[memory_clerk] [nvarchar](60) NOT NULL,
	[size_mb] [bigint] NULL
) ON [fg_archive]
GO
alter table [dbo].[dm_os_memory_clerks_aggregated]
	add constraint pk_dm_os_memory_clerks_aggregated primary key clustered (collection_time,memory_clerk)
	ON [fg_archive]
go
