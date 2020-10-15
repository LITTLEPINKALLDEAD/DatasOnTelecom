update siebel.s_order_item set status_cd='97完成',processed_flg='N',EAI_EXPRT_STAT_CD='待完工处理' 
where row_id in
(select row_id from siebel.S_ORDER_ITEM 
where ORDER_ID in
(select row_id from siebel.S_ORDER where ORDER_NUM in 
('2-30309707282')) and 
PAR_ORDER_ITEM_ID is null and
(PROCESSED_FLG <> 'Y' or STATUS_CD='97完成') and
ACTION_CD<>'现有的')

commit;
--1.所有行项目刷成97完成

select row_id,PROCESSED_FLG,STATUS_CD,service_num from siebel.S_ORDER_ITEM 
where ORDER_ID in
(select row_id from siebel.S_ORDER where ORDER_NUM in 
('2-30309707282')) and 
PAR_ORDER_ITEM_ID is null and
(PROCESSED_FLG <> 'Y' or STATUS_CD='97完成') and
ACTION_CD<>'现有的'

--2.查询所有行项目ID
--先将行项目刷成97完成状态，再查询所有行项目的ID，在模拟器中运行
--CRM模拟器在首页放大镜中寻找，随后加载文件1和文件2,在文件2的窗口下属性值中输入ROW_ID
--（格式|2-DS9XRG0|2-DS9XRH7|），再进行执行
--2-30007915046成功完工，其关联子订单：2-30017522181，2-30017529510也完工了


select * from siebel.S_ORDER where ORDER_NUM='2-30335573161';
update siebel.S_ORDER set STATUS_CD='通过合法性校验' where row_id='2-DXP0M21';
commit;
--改CRM状态为通过合法性校验

select * from siebel.S_ORDER where ORDER_NUM='2-30335573161';
update siebel.S_ORDER set STATUS_CD='通过合法性校验' where row_id='2-DTG5A84';
commit;
--2-22494391826（LHH）,2-22414821620(ZQY),All updated successfully!

select STATUS_CD from siebel.S_ORDER where ORDER_NUM in ('2-30007915046','2-30017522181','2-30017529510');
select STATUS_CD from siebel.S_ORDER where ORDER_NUM = '2-30023855818';
--查询订单的状态

select * from siebel.S_ORDER where STATUS_CD='通过合法性校验'

select SS.STATUS_CD from siebel.S_ORDER SS where SS.ORDER_NUM='2-30285926616';
--siebel.S_ORDER中的STATUS_CD为老CRM发送订单的状态

select userenv('language') from dual;
