select * from T_PUB_MAINBILL order by CREATE_TIME desc;  --公共接口表
select * from T_SF_BILL order by APPLY_TIME desc;    --政企工单表
select * from T_PUB_TASK order by DISPATCH_TIME desc;    --公共任务表
select * from T_SF_TASK order by TASK_ID desc;      --政企任务表
select count(*) from T_PUB_BILL_ACTION order by OPERATE_END_TIME desc;    --公共动作表

select pub_b2c(d.xmlinfo) from t_Sf_Receive_Quene D WHERE D.SPS_APPLY_ID like '%(2019)/19065599%'
--验证客保收到IBP工单报文中是否含有新增字段虚中继信息节点（vtrunkinfo）和分配号码信息节点(alloccodeinfo)


select pub_b2c(d.xmlinfo) from t_sf_receive_quene_his d where d.sps_apply_id='WMZ2020011300536458';
-- bureau_code  区局      customer_address_road  安装地址,STN200014021
--帐号： KB_TEST   密码：marconi
