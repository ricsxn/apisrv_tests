--
-- apisrv_appconfig_db.sql
--
-- Script that creates the structure for application configuration
-- into the APISRV
--


drop database if exists apisrv;
create database apisrv;
grant all on apisrv.* TO 'apisrv'@'%' IDENTIFIED BY 'apisrv';
grant all on apisrv.* TO 'apisrv'@'localhost' IDENTIFIED BY "apisrv";
use apisrv;



-- Schema Groups
-- Each data schema is built collecting one or more
-- groups of keys. Different adaptors may share some
-- schema groups.
create table apisrv_schema_group (
    id           int unsigned not null auto_increment  -- Group Id
   ,name         varchar(64) not null                  -- Group name
   ,array_name   varchar(64) default null              -- Multiple values allowed (array name)
   
   ,primary key(id,name)
);

-- Baselins (Group of keys) 
insert into apisrv_schema_group (id,name,array_name) values (1,"rOCCI-infrastructure","infrastructure");
insert into apisrv_schema_group (id,name,array_name) values (2,"EMIGrid-infrastructure","infrastructure");
insert into apisrv_schema_group (id,name,array_name) values (3,"genericInfo",NULL);
insert into apisrv_schema_group (id,name,array_name) values (4,"robotSecuriry",NULL);
insert into apisrv_schema_group (id,name,array_name) values (5,"appSettings",NULL);
insert into apisrv_schema_group (id,name,array_name) values (6,"JSAGA",NULL);
insert into apisrv_schema_group (id,name,array_name) values (7,"resourceList","resource");
insert into apisrv_schema_group (id,name,array_name) values (8,"EMIGrid",NULL);

-- group_keys
-- Each schema group foresees a specific set of keys
-- a key could refer to another group
create table apisrv_group_keys (
    group_id    int unsigned not null    -- group belonging
   ,seq_num     int unsigned not null    -- provide the right sequence representing keys
   ,schema_key  varchar(64)              -- schema key
   ,group_ref   int unsigned             -- reference to another schema_group

   -- ,primary key(group_id,seq_num);
);

-- Baseline (GroupKey) 

-- genericInfo
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (3,1,'Name',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (3,2,'Description',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (3,3,'Enabled',NULL);
-- 
-- robotSecurity
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,1,'eTokenHost',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,2,'eTokenPort',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,3,'eTokenMd5Sum',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,4,'eTokenVO',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,5,'eTokenVOGroup',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,6,'eTokenProxyRenewal',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (4,7,'ProxyRFC',NULL);

-- JSAGA
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (6,1,'Executable',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (6,2,'Arguments',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (6,3,'InputSandbox',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (6,4,'OutputSandbox',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (6,5,'OutputFile',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (6,6,'ErrorFile',NULL);

-- resourceList
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,1,'hostname',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,2,'port',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,3,'resource',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,4,'action',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,5,'attributes_title',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,6,'mixin_os_tpl',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,7,'mixin_resource_tpl',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,8,'auth',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,9,'publickey_file',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (7,10,'privatekey_file',NULL);

-- EMIGrid
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (8,1,'softwareTag',NULL);
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (8,2,'jdlRequirements',NULL);


-- rOCCI-infrastrucutre-components
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (1,1,NULL,3); -- Group: genericInfo
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (1,2,NULL,4); -- Group: robotSecurity
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (1,3,NULL,6); -- Group: JSAGA
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (1,4,NULL,7); -- Array: resourceList 

-- EMIGrid-infrastructure-components
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (2,1,NULL,3); -- Group: genericInfo
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (2,2,NULL,4); -- Group: robotSecurity
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (2,3,NULL,6); -- Group: JSAGA
insert into apisrv_group_keys (group_id,seq_num,schema_key,group_ref) values (2,4,NULL,8); -- Group: EMIGrid


