select * from ra_workorder_request where crm_order_number = '(2019)/19076533-0001'; --P7-综资
select * from ra_workorder_request where crm_order_number LIKE '%(2020)/404841586%';
select * from ra_workorder_request where P_RESULT is NOT null and rownum < 11 order by RECEIVE_TIME DESC; --根据订单的接收时间从近到远选取最近10张有报错信息的订单
select * from ra_workorder_request where crm_order_number = '2-30242684394'; --P7-综资，订单原资产报错
select * from ra_workorder_request where ORDER_SEQ_ID = '28471' order by RA_COMPLELED_TIME DESC; --P7-综资，用P7号查询
select * from ra_workorder_request where ORDER_SEQ_ID = '35174' order by RECEIVE_TIME DESC; --P7-综资，用P7号查询
select * from ra_workorder_request where crm_order_number like 'WMZ2020032305208888%' order by RECEIVE_TIME DESC;
select * from ra_workorder_request where crm_order_number in ('WMZ2019120500516845','WMZ2019120500519229') order by RECEIVE_TIME DESC;
select * from ra_workorder_request where USER_ID_97 like '%M1323110%' order by RECEIVE_TIME DESC;--(Servrice ID，设备号，工程单编号)等97ID查询

select aa.STATE,aa.REQUEST_TYPE,aa.* from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER = '2-30309482575';

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
---dispatchMOrder(2M创服务),checkService是资源审核(2M)
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

select * from RA_WORKORDER_REQUEST where P_RESULT like '%Could%' and rownum<=10;

select aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER in ('WMX2020061905549744') and aa.REQUEST_TYPE like '%query%';
--有线宽带，专线宽带报文查询，在WORK_ORDER_REQUEST查找start_project_build字段

select pub_b2c(d.xmlinfo),D.* from t_Sf_Receive_Quene D WHERE D.SPS_APPLY_ID like '(2019)/19065595_0001PZ%';
--验证客保收到IBP工单报文中是否含有新增字段虚中继信息节点（vtrunkinfo）和分配号码信息节点(alloccodeinfo)on在途表
-- SN13新装：(2019)/19065595_0001PZ,(2019)/19065599_0001PC

select p.work_order_request from pai_workorder_request p  where p.crm_order_number in ('2-30264173016'); 
-- 拆机：2-30264222174，WMZ2019122500529376, 设备号： ACC400807650785(新CRM新装), WMZ2019122500531058（新CRM拆机）,WMZ2019122500529380  设备号： ACC400807650815（新CRM新装不带子产品）
--验证字段：客户标识“service_account”、客户名称“account_number”、一级产品编码“一级子产品编号”、群组号“group_number”


select * from pai_workorder_request where crm_order_number = '2-29978524433'; --P7-PAI --2-29936482320
select * from asap_workorder_request where crm_order_number = '2-29978513149';  --P7-asap

select * from INT_RES_CONFIG_RESULT_NEW where CRM_ORDER_NO = 'WMX2019112100508401' --查询PAL配置情况的表

select q.wop_process_state from pai_workorder_request q where q.crm_order_number='WMZ2020032605228633' and q.platform='P027'; 
---云主机产品重派验证，wop_process_state为1时表示已重发工单

select q.pai_compleled_time from pai_workorder_request q  where q.crm_order_number in('WMZ2020032705236482','WMZ2020032705236546') and q.platform='P027';
---云主机产品重派验证，派发智能网管工单后过几分钟再去WOP调用重派,pai_compleled_time这个时间来验证重派是否有效

select t.*,t.rowid from asap_workorder_request t where crm_order_number='WMZ2020040205289110' and request_type='VIMS_OrderRequest' order by hist_seq_id;
--验证IBP派发了vims工单

select t.*,t.rowid from asap_workorder_request t where crm_order_number in ('WMX2020040205288719','WMX2020040205289095','WMX2020040205288724','WMX2020040205289121','2-30309283705','2-30309482575') and request_type='VIMS_OrderRequest' order by hist_seq_id;
--验证IBP派发了vims工单，这些订单类型是要发VIMS工单的

select t.*,t.rowid from asap_workorder_request t where crm_order_number in ('WMZ2020040205288743','WMZ2020040305289921','WMZ2020040205289110','WMZ2020040305289948','2-30309707282','2-30309754240') and request_type='VIMS_OrderRequest' order by hist_seq_id;
--验证IBP派发了vims工单,这些订单类型是不发VIMS工单的

select p.work_order_request from pai_workorder_request p where p.crm_order_number in ('WMX2020040905308819','WMX2020040905308876','WMX2020040905308945') and p.platform='P017';

select p.work_order_request from pai_workorder_request p where p.crm_order_number in ('WMX2020040905308900','WMX2020040905308956','WMX2020040905308995') and p.platform='P017';

--验证字段工单中带有子产品ipoe_path（ipoe通道），子产品属性biz_type（业务类型）为云游戏，up_bandwidth（上行速率）为100M，down_bandwidth（下行速率）为500M

--select asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in ('WMX2020040905308819','WMX2020040905308876','WMX2020040905308945') and asap.request_type='ONU_OrderRequest';

select asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in ('WMX2020040905308900','WMX2020040905308956','WMX2020040905308995') and asap.request_type='ONU_OrderRequest';
--报文中含有yun_vlan（云网超宽vLan）并且值与资源信息返回的一致

select t.work_order_request from pai_workorder_request t where crm_order_number in ('WMZ2020041305323758','WMZ2020041405325093','WMZ2020041405325098','WMZ2020042005336888') and t.platform='P038d';
-- 验证新增的智能质检自动工单工单数据，验证字段：service_id（设备号）、Business_Type_AI（智能业务类型）、Channel_Name（渠道名称）、service_account（客户名称）、contact_person（联系人）、contact_tel（联系电话）

select t.work_order_request from pai_workorder_request t  where crm_order_number in ('WMZ2020041305324129','WMZ2020041405325065','WMZ2020041405325096') and t.platform='P038c';
-- 验证新增的智能语音自动工单工单数据，验证字段：service_id（设备号）、Business_Type_AI（智能业务类型）、Channel_Name（渠道名称）、Concurrency（并发数）、Concurrency_Fee（并发单价）、service_account（客户名称）、contact_person（联系人）、contact_tel（联系电话）

select asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number = 'WMX2020041605329388';
-- 验证方法ims、ONU、SHLR工单，serviceProperty_new这种是新节点，后面是old的是老节点，报文里应该只有新节点没有老节点的

select t.action_code,t.* from pai_workorder_request t where crm_order_number = 'WMX2020041605329388';
-- 验证action_code（操作类型）为装

select count(*) as count from ra_workorder_request where RECEIVE_TIME >= date '2020-4-7' AND RECEIVE_TIME <= date '2020-4-14'; 
-- 统计从2020年4月7日到2020年4月14日所有P7收到的订单

select count(*) from ra_workorder_request where to_char(RECEIVE_TIME,'yyyy-mm-dd hh:mm:ss') between '2020-04-07 09:00:00' AND '2020-04-14 21:00:00'; 
-- 统计从2020年4月7日早上9点到2020年4月14日晚上9点所有P7收到的订单

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020042705390546','WMX2020042705390547','WMX2020042705390821','WMX2020042705390832','WMX2020042705390877');
-- 验证预付费鹏博士宽带产品是否派发了ONU工单,老单子：'WMX2020042605389540','WMX2020042605389690','WMX2020042605389737','WMX2020042605389972'

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020042705390541','WMX2020042705390543','WMX2020042705390822','WMX2020042705390824','WMX2020042705390875');
-- 验证后付费鹏博士宽带产品是否派发了ONU工单

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in('WMX2020050905428062');
--查看固定电话非vims资产移机的报文，IBP派发vims装机单，老IMS的移拆工单

select aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER in ('WMX2020050605412739','WMX2020050605412755','WMX2020050605412758') and aa.REQUEST_TYPE like '%query%';
-- 查询固定电话移机单中的报文，ims_type的值为华为IMS

select aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN,AA.WORK_ORDER_REQUEST,aa.request_type from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER in ('WMZ2020050905427424','WMZ2020050905427428','WMZ2020050905430717','WMZ2020050905430719');
-- 查询专线宽带订单中的报文，用户接入模式（user_access_mode）值为路由模式和交换模式

select t.CRM_ORDER_NUMBER,t.work_order_request from pai_workorder_request t  where t.crm_order_number in('WMZ2020052105492801','WMZ2020052105497728','WMZ2020052305520425','WMZ2020052305520424','WMZ2020052305520423','WMZ2020052305520426','WMZ2020052505536997','WMZ2020052505536827') and t.platform='P002c';
-- 查询专线宽带订单中的报文，验证参数名：user_access_mode （用户接入模式）, co_ip_info（局端IP信息）

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in ('(2020)/404841383');
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in ('(2020)/404841397');
--查看普通直线零星割接且新老项onu逻辑编号发生变化,需要派发：数字家庭移入局 修改单、数字家庭归属局拆单、Vims移入局装单、ims-hss/tel归属局拆单
--若家庭网关类型=SDN，
--派发：SDN移入局修改单，SDN归属局拆机单、外线移入局装单、外线归属局拆机单、ONU归属局拆单，ONU移入局装单、Enum施工确认 割接、Enum移入局修改单、SHLR施工确认 割接、SHLR移入局修改单

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number in ('WMX2020050905428062');
--查看普通直线零星割接且新老项onu逻辑编号无变化,需要派发：Vims移入局装单、Ims-hss/tel归属局拆单、SHLR移入局修改单、Enum移入局修改单、数字家庭移入局修改单
--若家庭网关类型=SDN，
--派发：SDN移入局修改单

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020061905549863','WMX2020062005549866','WMX2020062005549868');
-- 验证预付费鹏博士宽带产品(补充需求)是否派发了ONU工单

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in('WMX2020061905549744','WMX2020061905549864','WMX2020062005549865','WMX2020062005549867');
-- 验证后付费鹏博士宽带产品(补充需求)是否派发了ONU工单

select crm_order_number,work_order_request from  ra_workorder_request where crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135') and request_type='createIntResService';
--3.验证IBP发送综资创服务报文set_top_box_4k 为：18，验证方法登陆PAL数据库：

select a.crm_order_number,a.work_order_request from pai_workorder_request a  where crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135') and a.platform='13';
--4.验证IBP发送IPTV工单报文set_top_box_4k 为：18，验证方法登陆PAL数据库：

select crm_order_number,work_order_request from  ra_workorder_request where crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135') and request_type='queryIntResService';
--6.验证综资原资产查询返回时，返回的set_top_box_4k 为：18，验证方法登陆PAL数据库：

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request from asap_workorder_request asap where asap.crm_order_number in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135');
-- 验证后付费宽带产品（带ITV子产品，且“4K机顶盒”属性：“无线播播宝盒”）是否派发了ONU工单

select w.crm_order_number,w.user_id_97 from ra_workorder_request w where w.crm_order_number in ('2-30343454773','2-30343469276','2-30343471776','2-30343474275','2-30343475775');

select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841383%' and aa.REQUEST_TYPE like '%query%';
select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841397%' and aa.REQUEST_TYPE like '%query%';
select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841587%' and aa.REQUEST_TYPE like '%query%';
select aa.ORDER_SEQ_ID,aa.CRM_ORDER_NUMBER,aa.WORK_ORDER_RETURN from RA_WORKORDER_REQUEST aa where aa.CRM_ORDER_NUMBER like '%(2020)/404841586%' and aa.REQUEST_TYPE like '%query%';
-- 查询割接单中的报文，ims_type的值为华为IMS

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841383%';
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841397%';
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841587%';
select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%(2020)/404841586%';
--查看普通直线零星割接且新老项onu逻辑编号发生变化,需要派发：数字家庭移入局 修改单、数字家庭归属局拆单、Vims移入局装单、ims-hss/tel归属局拆单
--若家庭网关类型=SDN，
--派发：SDN移入局修改单，SDN归属局拆机单、外线移入局装单、外线归属局拆机单、ONU归属局拆单，ONU移入局装单、Enum施工确认 割接、Enum移入局修改单、SHLR施工确认 割接、SHLR移入局修改单

select asap.CRM_ORDER_NUMBER,asap.request_type,asap.platform,asap.work_order_request,asap.* from asap_workorder_request asap where asap.crm_order_number like '%%';
--查看普通直线零星割接且新老项onu逻辑编号无变化,需要派发：Vims移入局装单、Ims-hss/tel归属局拆单、SHLR移入局修改单、Enum移入局修改单、数字家庭移入局修改单
--若家庭网关类型=SDN，
--派发：SDN移入局修改单

select * from P6_CRM_NOTIFICATION where CRM_ORDER_NUMBER = 'WMX2020051105433000';
-- P6_CRM_NOTIFICATION是查询IBP返回CRM消息记录的表

--帐号：nonphs_aa    密码nophsq
