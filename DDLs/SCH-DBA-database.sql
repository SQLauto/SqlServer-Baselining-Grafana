use master
go

CREATE DATABASE DBA
-- ON  PRIMARY
--( NAME = N'DBA', FILENAME = N'E:\MSSQL14.V17\Data\DBA.mdf' , SIZE = 500MB , FILEGROWTH = 200MB )
-- LOG ON 
--( NAME = N'DBA_log', FILENAME = N'E:\MSSQL14.V17\Log\DBA_log.ldf' , SIZE = 500MB , FILEGROWTH = 200MB )
GO

ALTER DATABASE DBA ADD FILEGROUP [fg_default]
GO
ALTER DATABASE DBA ADD FILE
	( NAME = N'DBA_fg_default', FILENAME = N'E:\MSSQL14.V17\Data\DBA_fg_default.ndf' , SIZE = 500MB , FILEGROWTH = 500MB )
	TO FILEGROUP [fg_default]
GO
ALTER DATABASE DBA MODIFY FILEGROUP [fg_default] DEFAULT
GO

ALTER DATABASE DBA ADD FILEGROUP [fg_ci]
GO
ALTER DATABASE DBA ADD FILE
	( NAME = N'DBA_1_fg_ci', FILENAME = N'E:\MSSQL14.V17\Data\DBA_1_fg_ci.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB ),
	( NAME = N'DBA_2_fg_ci', FILENAME = N'E:\MSSQL14.V17\Data\DBA_2_fg_ci.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB ),
	( NAME = N'DBA_3_fg_ci', FILENAME = N'E:\MSSQL14.V17\Data\DBA_3_fg_ci.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB ),
	( NAME = N'DBA_4_fg_ci', FILENAME = N'E:\MSSQL14.V17\Data\DBA_4_fg_ci.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB )
	TO FILEGROUP [fg_ci]
GO

ALTER DATABASE DBA ADD FILEGROUP [fg_nci]
GO
ALTER DATABASE DBA ADD FILE
	( NAME = N'DBA_1_fg_nci', FILENAME = N'E:\MSSQL14.V17\Data\DBA_1_fg_nci.ndf' , SIZE = 204800KB , FILEGROWTH = 204800KB ),
	( NAME = N'DBA_2_fg_nci', FILENAME = N'E:\MSSQL14.V17\Data\DBA_2_fg_nci.ndf' , SIZE = 204800KB , FILEGROWTH = 204800KB )
	TO FILEGROUP [fg_nci]
GO

ALTER DATABASE DBA ADD FILEGROUP [fg_heap]
GO
ALTER DATABASE DBA ADD FILE
	( NAME = N'DBA_1_fg_heap', FILENAME = N'E:\MSSQL14.V17\Data\DBA_1_fg_heap.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB )
	TO FILEGROUP [fg_heap]
GO

ALTER DATABASE DBA ADD FILEGROUP [fg_archive]
GO
ALTER DATABASE DBA ADD FILE
	( NAME = N'DBA_1_fg_archive', FILENAME = N'E:\MSSQL14.V17\Data\DBA_1_fg_archive.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB ),
	( NAME = N'DBA_2_fg_archive', FILENAME = N'E:\MSSQL14.V17\Data\DBA_2_fg_archive.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB ),
	( NAME = N'DBA_3_fg_archive', FILENAME = N'E:\MSSQL14.V17\Data\DBA_3_fg_archive.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB ),
	( NAME = N'DBA_4_fg_archive', FILENAME = N'E:\MSSQL14.V17\Data\DBA_4_fg_archive.ndf' , SIZE = 512000KB , FILEGROWTH = 512000KB )
	TO FILEGROUP [fg_archive]
GO

--alter database DBA set single_user with rollback immediate
--go
ALTER DATABASE [DBA] MODIFY FILEGROUP [PRIMARY] AUTOGROW_ALL_FILES
GO
ALTER DATABASE [DBA] MODIFY FILEGROUP [fg_default] AUTOGROW_ALL_FILES
GO
ALTER DATABASE [DBA] MODIFY FILEGROUP [fg_heap] AUTOGROW_ALL_FILES
GO
ALTER DATABASE [DBA] MODIFY FILEGROUP [fg_ci] AUTOGROW_ALL_FILES
GO
ALTER DATABASE [DBA] MODIFY FILEGROUP [fg_nci] AUTOGROW_ALL_FILES
GO
ALTER DATABASE [DBA] MODIFY FILEGROUP [fg_archive] AUTOGROW_ALL_FILES
GO
--alter database DBA set multi_user
--go

use DBA
go

select DB_NAME() as dbName, * from sys.database_files
go

/*
	primary (non-default)
	fg_ci
	fg_nci
	fg_heap
	fg_archive
	fg_default

benefits
- maintenance
- backup/restore
- movement
- recoverability (piece-meal restore)

read-only file groups
- can be used to reduce contention for reporting-only data
- prevent modification of data
- no recovery process when database is brought online
- compression-enabled
- cost-saving (old-read0nly-archive data into slow disk)
-
*/

USE [DBA]
GO
CREATE SCHEMA [bkp]
GO
CREATE SCHEMA [poc]
GO
CREATE SCHEMA [stg]
GO
CREATE SCHEMA [tst]
GO

USE DBA
GO
SELECT table_name = tb.[name], index_name = ix.[name], located_filegroup_name = fg.[name] 
FROM sys.indexes ix
    INNER JOIN sys.filegroups fg
    ON ix.data_space_id = fg.data_space_id
    INNER JOIN sys.tables tb
    ON ix.[object_id] = tb.[object_id] 
WHERE ix.data_space_id = fg.data_space_id
--and fg.name = 'PRIMARY'
--and tb.name not in ('Queue','QueueDatabase','CommandLog','CounterDetails','CounterData','DisplayToID','IndexProcessing_IndexOptimize')
--and tb.name like '%aggregated'
GO

/*
-- Move non-clustered index
CREATE NONCLUSTERED INDEX [UQ__DisplayT__FA63CFA69449BD52] ON dbo.DisplayToID
	(DisplayString)
WITH (DROP_EXISTING = ON)  
ON [fg_nci];  
GO

-- Move Clustered Index
CREATE UNIQUE CLUSTERED INDEX UQ__DisplayT__FA63CFA69449BD52 ON dbo.DisplayToID
	(DisplayString)
	WITH (DROP_EXISTING = ON)  
	ON [fg_ci]
GO
*/