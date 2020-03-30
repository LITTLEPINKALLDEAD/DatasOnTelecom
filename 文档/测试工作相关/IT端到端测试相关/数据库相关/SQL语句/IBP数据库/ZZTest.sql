select * from intf_requestlog where crmquotenumber='WMX2020021405150807';--接口表，IBP发给综资的信息
-- intf_requestlog表中的TARGETMETHOD为订单配置状态，createService是创服务，checkService是资源审核
SELECT * from c_serviceorder where crmquotenumber like 'WMX2020021405150807'; --订单表
-- c_serviceorder会有一条记录，其中SERVICE_ID为空，因为该项为主单。SERVICE_ID有值的为子单
-- 在综资界面配置的时候，都是在子单中操作
SELECT * from c_Servicecurrent WHERE globalserviceid='M2049021';--在途服务表,根据c_serviceorder的GLOBALSERVICEID查询,即设备编号
SELECT * from intf_datafortelement where CRMQUOTENUMBER = 'WMX2020011705148008';  
--综资返回IBP是否收到的表

select * from INTF_FAILEDREQLOG_IFCARCHIVE WHERE SERVICEID LIKE 'M2049022%'; -- 综资归档表

Select t.*,t.rowid From intf_failedrequestlog_forifc t Where t.serviceid like 'M2049022%'

SELECT * FROM INTF_FAILEDREQUESTLOG_FORIFC where SERVICEID = 'M2049022'; --综资配置完发出去的表

select * from mm_dictionary where id in (SELECT PROCESSTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
 -- 从c_serviceorder表中查询PROCESSTYPE的为订单类型
select * from mm_dictionary where id in (SELECT DOTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- DOTYPE是操作状态，
select * from mm_dictionary where id in (SELECT PROCESSTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- PROCESSTYPE是订单类型，
select * from mm_dictionary where id in (SELECT ORDERTYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- ORDERTYPE是来源订单类型,
select * from mm_dictionary where id in (SELECT STATUS from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- STATUS是订单配置状态，
select * from mm_dictionary where id in (SELECT ISLEGAL from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- ISLEGAL是否合法,
select * from mm_dictionary where id in (SELECT OPERATION_TYPE from c_serviceorder where crmquotenumber like 'WMZ2020011705147885');
-- OPERATION_TYPE流程操作类型

select DISTINCT(STATUS) from C_SERVICEORDER;

select * from mm_dictionary where id in (select DISTINCT(OPERATION_TYPE) from C_SERVICEORDER);

select * from mm_dictionary where id in (SELECT STATUS from intf_datafortelement where CRMQUOTENUMBER = 'WMZ2020011705147885');
