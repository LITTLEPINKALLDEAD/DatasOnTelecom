select * from T_PUB_MAINBILL order by CREATE_TIME desc;  --公共接口表
select * from T_SF_BILL order by APPLY_TIME desc;    --政企工单表
select * from T_PUB_TASK order by DISPATCH_TIME desc;    --公共任务表
select * from T_SF_TASK order by TASK_ID desc;      --政企任务表
select count(*) from T_PUB_BILL_ACTION order by OPERATE_END_TIME desc;    --公共动作表

--帐号： KB_TEST   密码：marconi
