select * from intf_requestlog where crmquotenumber in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100');--接口表，IBP发给综资的信息
-- intf_requestlog表中的TARGETMETHOD为订单配置状态，createService是创服务，checkService是资源审核，queryService是原资产查询,archiveService是完工归档
-- TARGETMETHOD状态为createService创服务时需要查看REQUESTOBJECT字段的报文内容，checkService资源审核，queryService原资产查询时需要查看RESPONSEOBJECT字段的报文内容
SELECT * from c_serviceorder where crmquotenumber in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100'); --订单表
-- c_serviceorder会有一条记录，其中SERVICE_ID为空，因为该项为主单。SERVICE_ID有值的为子单
-- 在综资界面配置的时候，都是在子单中操作
SELECT * from c_Servicecurrent WHERE globalserviceid in ('KD2003070464','KD2003070465');--在途服务表,根据c_serviceorder的GLOBALSERVICEID查询,即设备编号
SELECT * from intf_datafortelement where CRMQUOTENUMBER in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100');  
--综资返回IBP是否收到的表

select * from INTF_FAILEDREQLOG_IFCARCHIVE WHERE SERVICEID LIKE 'M2049022%'; -- 综资归档表

Select t.*,t.rowid From intf_failedrequestlog_forifc t Where t.serviceid like 'M2049022%'

SELECT * FROM INTF_FAILEDREQUESTLOG_FORIFC where SERVICEID = 'M2049022'; --综资配置完发出去的表

select * from C_CIRCUIT where rownum<11; --综资电路表

select * from C_ADDRESS where rownum<11; --综资地址表

select * from mm_dictionary where id in (SELECT PROCESSTYPE from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
 -- 从c_serviceorder表中查询PROCESSTYPE的为订单类型
select * from mm_dictionary where id in (SELECT DOTYPE from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
-- DOTYPE是操作状态，
select * from mm_dictionary where id in (SELECT PROCESSTYPE from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
-- PROCESSTYPE是订单类型，
select * from mm_dictionary where id in (SELECT ORDERTYPE from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
-- ORDERTYPE是来源订单类型,
select * from mm_dictionary where id in (SELECT STATUS from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
-- STATUS是订单配置状态，
select * from mm_dictionary where id in (SELECT ISLEGAL from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
-- ISLEGAL是否合法,
select * from mm_dictionary where id in (SELECT OPERATION_TYPE from c_serviceorder where crmquotenumber like 'WMZ2020032305208888');
-- OPERATION_TYPE流程操作类型

select DISTINCT(STATUS) from C_SERVICEORDER;

select * from mm_dictionary where id in (select DISTINCT(OPERATION_TYPE) from C_SERVICEORDER);

select * from mm_dictionary where id in (SELECT STATUS from intf_datafortelement where CRMQUOTENUMBER = 'WMZ2020032305208888');
