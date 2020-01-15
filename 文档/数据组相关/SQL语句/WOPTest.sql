select * from wp_srq where p6_order_id in('36219'); --工单处理状态，对接客保能看发送工单成功，失败
--- wp_srq中的
--- Status：101未发送，102已派发、104已打印、
--- 105已竣工、255已撤销、250待撤销、254重派中、253退单中、251待修改
--- process_flag：02成功，0P，0E失败

-- order by receive_dts desc 
select * from wp_p6_req where p6_order_id in('36219'); --人工工单内容
--- wp_p6_req中的
--- PROCESS_STATUS：101未发送，102已派发、104已打印、105已竣工、
--- 255已撤销、250待撤销、254重派中、253退单中、251待修改



-- order by CREATE_DTS desc 

--(2019)/19076225_0001PZ的P6号为15094
--(2019)/19076222_0001PZ,P6号为15091

select a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMZ2020010900535453') and a.plane_type='111'
--验证字段：“device_serial_num”、“device_model”、“sla_servcie”、“safety_audit”、“intrusion_detection_defense”、“four_layer_firewall”、“web_apply_protect”



--WOP 帐号：wopdb     密码：nophsq
