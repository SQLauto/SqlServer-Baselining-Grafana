declare @object_name varchar(255);
set @object_name = (case when @@SERVICENAME = 'MSSQLSERVER' then 'SQLServer' else 'MSSQL$'+@@SERVICENAME end);

SELECT /* -- all performance counters that do not require additional calculation */
		distinct
		--[collection_time] = SYSDATETIME(), server_name = @@SERVERNAME,
		rtrim(object_name) as object_name, rtrim(counter_name) as counter_name, rtrim(instance_name) as instance_name
		--, cntr_value ,cntr_type
		--,id = ROW_NUMBER()OVER(ORDER BY SYSDATETIME())
--into dbo.dm_os_performance_counters
FROM sys.dm_os_performance_counters as pc
WHERE cntr_type in ( 272696576,  272696320)


select * 
from sys.dm_os_performance_counters as pc
where pc.object_name like 'SQLServer:Resource Pool Stats%'
	and pc.counter_name in ('')

select *
from dbo.dm_os_performance_counters as pc
where pc.object_name = 'SQLServer:Resource Pool Stats'
	and counter_name in ('CPU usage %')



