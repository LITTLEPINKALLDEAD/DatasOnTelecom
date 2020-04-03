select * from ra_workorder_request where crm_order_number = '(2019)/19076533-0001'; --P7-综资
select * from ra_workorder_request where crm_order_number = 'WMX2020040205288735'
select * from ra_workorder_request where P_RESULT is NOT null and rownum < 11 order by RECEIVE_TIME DESC; --根据订单的接收时间从近到远选取最近10张有报错信息的订单
select * from ra_workorder_request where crm_order_number = '2-30242684394'; --P7-综资，订单原资产报错
select * from ra_workorder_request where ORDER_SEQ_ID = '28471' order by RA_COMPLELED_TIME DESC; --P7-综资，用P7号查询
select * from ra_workorder_request where ORDER_SEQ_ID = '35174' order by RECEIVE_TIME DESC; --P7-综资，用P7号查询
select * from ra_workorder_request where crm_order_number like '%2-30285708158%' order by RECEIVE_TIME DESC;
select * from ra_workorder_request where crm_order_number in ('WMZ2019120500516845','WMZ2019120500519229') order by RECEIVE_TIME DESC;
select * from ra_workorder_request where USER_ID_97 like '%M1323110%' order by RECEIVE_TIME DESC;--(Servrice ID，设备号，工程单编号)等97ID查询

select * from RA_WORKORDER_REQUEST where CRM_ORDER_NUMBER = 'WMX2020040205289095' and REQUEST_TYPE like '%queryIntResService%' order by RECEIVE_TIME desc;

---STATE为返回订单状态，包括：
---（1：初始状态，准备发送；
---2：发送失败
---3：已发送，但未收到回单；
---4：未用
---5：已收到失败的回单结果
---6：工单结果准备回给P7
---7：工单结果回P7失败
---8：工单结果回P7成功
---）

---request_type为返回请求类型，包括：（
---createIntResService是创服务（固网的）
---dispatchMOrder(2M好像是创服务),checkService是资源审核(2M)
---queryIntResService（原资产查询）
---csOrder是返回客保工单的记录（2M）
---completeIntResService是订单完工（固网）,archiveNMResource是订单完工(2M)
---）

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

select p.work_order_request from pai_workorder_request p  where p.crm_order_number in ('2-30264173016'); 
-- 拆机：2-30264222174，WMZ2019122500529376, 设备号： ACC400807650785(新CRM新装), WMZ2019122500531058（新CRM拆机）,WMZ2019122500529380  设备号： ACC400807650815（新CRM新装不带子产品）
--验证字段：客户标识“service_account”、客户名称“account_number”、一级产品编码“一级子产品编号”、群组号“group_number”


select * from pai_workorder_request where crm_order_number = '2-29978524433'; --P7-PAI --2-29936482320
select * from asap_workorder_request where crm_order_number = '2-29978513149';  --P7-asap

select * from INT_RES_CONFIG_RESULT_NEW where CRM_ORDER_NO = 'WMX2019112100508401' --查询PAL配置情况的表

select q.wop_process_state from pai_workorder_request q where q.crm_order_number='WMZ2020032605228166' and q.platform='P027'; 
---云主机产品重派验证，wop_process_state为1时表示已重发工单

select q.pai_compleled_time from pai_workorder_request q  where q.crm_order_number='WMZ2020032605228166' and q.platform='P027';
---云主机产品重派验证，派发智能网管工单后过几分钟再去WOP调用重派,pai_compleled_time这个时间来验证重派是否有效

select q.pai_compleled_time from pai_workorder_request q  where q.crm_order_number in('WMZ2020032705236482','WMZ2020032705236546') and q.platform='P027';
---云主机产品重派验证，派发智能网管工单后过几分钟再去WOP调用重派,pai_comp

select userenv('language') from dual

select t.*,t.rowid from asap_workorder_request t where crm_order_number='WMX2020040205289121' and request_type='VIMS_OrderRequest' order by hist_seq_id;
--验证IBP派发了vims工单

select t.*,t.rowid from asap_workorder_request t where crm_order_number in ('WMX2020040205288719','WMX2020040205289095','WMX2020040205288724','WMX2020040205289121') and request_type='VIMS_OrderRequest' order by hist_seq_id;
--验证IBP派发了vims工单

--帐号：nonphs_aa    密码nophsq
