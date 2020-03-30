select a.mkt_res_inst_nbr from mkt_res_card_inst a join mkt_res_card_inst_ext b on a.mkt_res_inst_id = b.mkt_res_card_inst_id 
join mkt_res_card_act c on a.mkt_res_inst_id = c.mkt_res_card_inst_id
where b.card_type is not null  and a.status_cd = '1000' and c.network = 'CGL' limit 50 -- 查可用UIm卡号

select * from mkt_res_card_inst where mkt_res_inst_nbr = '卡号' -- 查询卡信息

select b.obj_id from mkt_res_num_inst a, mkt_res_store_obj_rel b where a.mkt_res_inst_nbr = '13310131646'
and b.mkt_res_store_id = a.mkt_res_store_id and b.obj_type= '1100';
select * from mkt_res_lifecycle
 select mkt_res_inst_id from mkt_res_num_inst where status_cd='1002' AND mkt_res_inst_id LIKE '13%' LIMIT 100; -- 做预开通的号码

select * from mkt_res_num_inst where `STATUS_CD`='1002' and `MKT_RES_STORE_ID`=100000080 limit 10;