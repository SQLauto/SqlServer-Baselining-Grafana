
USE [master]
GO
EXEC master.dbo.sp_addlinkedserver @server = N'SQL-A\V17', @srvproduct=N'SQL Server'

GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'connect timeout', @optvalue=N'120'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'query timeout', @optvalue=N'300'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'SQL-A\V17', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
USE [master]
GO
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'SQL-A\V17', @locallogin = NULL , @useself = N'False', @rmtuser = N'grafana', @rmtpassword = N'grafana'
GO