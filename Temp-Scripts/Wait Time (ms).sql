declare @p_start_time datetime2;
declare @p_end_time datetime2;
declare @object_name varchar(255);
set @object_name = (case when @@SERVICENAME = 'MSSQLSERVER' then 'SQLServer' else 'MSSQL$'+@@SERVICENAME end);

select @p_start_time = st.local_time, @p_end_time = et.local_time 
from dbo.utc2local('2020-09-17T14:58:49Z') as st join dbo.utc2local('2020-09-17T15:28:49Z') et on 1 = 1;

SELECT l2u.utc_time as time, counter_name as metric, cntr_value as [value], object_name, instance_name, cntr_type
FROM (	
		select collection_time, counter_name, cntr_value, instance_name, object_name, cntr_type
		from dbo.dm_os_performance_counters as pc
		where ( collection_time BETWEEN @p_start_time AND @p_end_time )
			and 
			  (	( pc.object_name = (@object_name+':Latches') and pc.counter_name like '%Wait Time (ms)')
			  or
				( pc.object_name = (@object_name+':Locks') and pc.counter_name like '%Wait Time (ms)')
			  )
		--
		union all
		--
		select collection_time, counter_name, cntr_value, instance_name, object_name, cntr_type
		from dbo.dm_os_performance_counters_aggregated as pc
		where ( collection_time BETWEEN @p_start_time AND @p_end_time )
			and 
			  (	( pc.object_name = (@object_name+':Latches') and pc.counter_name like '%Wait Time (ms)')
			  or
				( pc.object_name = (@object_name+':Locks') and pc.counter_name like '%Wait Time (ms)')
			  )
) AS pc
cross apply dbo.local2utc(collection_time) as l2u
order by collection_time;