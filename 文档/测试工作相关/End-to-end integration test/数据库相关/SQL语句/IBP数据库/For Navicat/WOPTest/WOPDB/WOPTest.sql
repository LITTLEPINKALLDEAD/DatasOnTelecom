select c.STATUS,c.* from wp_srq c where p6_order_id in ('37186') and TASK_ID like '%kb%'; --工单处理状态，对接客保能看发送工单成功，失败
--- wp_srq中的
--- Status：101未发送，102已派发、104已打印、
--- 105已竣工、255已撤销、250待撤销、254重派中、253退单中、251待修改
--- TASK_ID为ddxx:1是WOP工单，可在WOP界面上查询，2M的WOP工单，测试环境上没有


-- order by receive_dts desc 
-- select ww.PROCESS_STATUS,ww.* from wp_p6_req ww where p6_order_id in('36234'); --人工工单内容
--- wp_p6_req中的
--- PROCESS_STATUS：101未发送，102已派发、104已打印、105已竣工、
--- 255已撤销、250待撤销、254重派中、253退单中、251待修改
--- wp_srq的process_flag：02成功，0P，0E失败
--- 需要在客保界面中对工单进行回单，状态才会发生变化



-- order by CREATE_DTS desc 

--(2019)/19076225_0001PZ的P6号为15094
--(2019)/19076222_0001PZ,P6号为15091

select a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMZ2020010900535453') and a.plane_type='111'
--验证字段：“device_serial_num”、“device_model”、“sla_servcie”、“safety_audit”、“intrusion_detection_defense”、“four_layer_firewall”、“web_apply_protect”

select a.crm_order_id,a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135');
--5.验证IBP发送客保外线工单工单报文set_top_box_4k 为：18，验证方法登陆WOP数据库

select a.crm_order_id,a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMX2020061905549744','WMX2020061905549864','WMX2020062005549865','WMX2020062005549867','WMX2020061905549863','WMX2020062005549866','WMX2020062005549868');
--鹏博士需要发客保外线的订单

--WOP 帐号：wopdb     密码：nophsq
