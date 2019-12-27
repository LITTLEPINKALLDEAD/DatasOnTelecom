select * from ra_workorder_request where crm_order_number = '(2019)/19076533-0001'; --P7-综资
select * from ra_workorder_request where crm_order_number = '2-30039336430'; --P7-综资，订单原资产报错
select * from ra_workorder_request where ORDER_SEQ_ID = '28471' order by RA_COMPLELED_TIME DESC; --P7-综资，用P7号查询
select * from ra_workorder_request where ORDER_SEQ_ID = '28471' order by RECEIVE_TIME DESC; --P7-综资，用P7号查询
select * from ra_workorder_request where crm_order_number like '%2-30261405580%' order by RECEIVE_TIME DESC;
select * from ra_workorder_request where crm_order_number in ('2-30059571205','2-30059578041','2-30059598956') order by RECEIVE_TIME DESC;
select * from ra_workorder_request where USER_ID_97 like '%M1323110%' order by RECEIVE_TIME DESC;--(Servrice ID，设备号，工程单编号)等97ID查询

select USER_ID_97 from ra_workorder_request where crm_order_number like '%2-30039336430%' order by RECEIVE_TIME DESC;
--查询CRM订单的Service ID设备号

select CRM_ORDER_NUMBER from ra_workorder_request where USER_ID_97 like '%M1307690%' order by RECEIVE_TIME DESC;
--根据Service ID设备号查询CRM订单号

--20190313:(2019)/19076920-0001
--20190314:2-29999072116
--WMX2019012100117301,WMX2019012600123517
--(2019)/19075950_0001C ,(2019)/19076141_0002C
--(2019)/19076225_0001PZ,修订过的工程订单的P6号为15094
--(2019)/19076222_0001PZ,P6号为15091

select t.work_order_return from  ra_workorder_request t  where crm_order_number like '%(2019)/19065599%' and t.request_type='queryIntResService'
--验证资源信息中新增字段虚中继信息节点（vtrunkinfo）和分配号码信息节点(alloccodeinfo) IBP是否收到

select * from pai_workorder_request where crm_order_number = '2-29978524433'; --P7-PAI --2-29936482320
select * from asap_workorder_request where crm_order_number = '2-29978513149';  --P7-asap


--帐号：nonphs_aa    密码nophsq
