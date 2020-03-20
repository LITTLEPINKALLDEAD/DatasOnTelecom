select * from received_message where crm_order_number in('WMX2020021305150748','WMX2020021305150749','WMX2020021305150750','WMX2020021305150751'); --查SOP是否收到CRM提交的订单
---received_message中CRM_ORDER_VERSION为CRM订单版本号：1，2，3，订单不同的版本，数据库就有不同的记录条数

select * from p6_order_info where crm_order_number in('WMX2020021305150748','WMX2020021305150749','WMX2020021305150750','WMX2020021305150751'); -- 查SOP发P7的状态
---p6_order_info中的STATUS为发送状态：失败Failed，成功Processing，完工Finished

select * from SERVICE_ORDER_SENT where CRM_ORDER_NUMBER in('WMX2020021305150748','WMX2020021305150749','WMX2020021305150750','WMX2020021305150751'); -- 查SOP发P7报文的报文
---SERVICE_ORDER_SENT中CRM_ORDER_VERSION为CRM订单版本号：1，2，3，订单不同的版本，数据库就有不同的记录条数


--where crm_order_number = '2-29936865024'
--ORDER BY status_time DESC
--2-29936865024 
--(2019)/19076141_0002C


select r.message_body from received_message r where r.crm_order_number in ('WMX2019121900526637')
-- 查询报文中Relay Type的值

select r.message_body from received_message r where r.crm_order_number in ('WMZ2019122500531058')
-- 在报文中搜索子产品名称“组数据集群音证”

--SOP 帐号：testorder   密码：testorder
