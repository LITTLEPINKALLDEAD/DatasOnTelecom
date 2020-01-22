update siebel.s_order_item set status_cd='97完成',processed_flg='N',EAI_EXPRT_STAT_CD='待完工处理' 
where row_id in
(select row_id from siebel.S_ORDER_ITEM 
where ORDER_ID in
(select row_id from siebel.S_ORDER where ORDER_NUM in 
('2-30286194921')) and 
PAR_ORDER_ITEM_ID is null and
(PROCESSED_FLG <> 'Y' or STATUS_CD='97完成') and
ACTION_CD<>'现有的')

commit;
--1.所有行项目刷成97完成

select row_id,PROCESSED_FLG,STATUS_CD,service_num from siebel.S_ORDER_ITEM 
where ORDER_ID in
(select row_id from siebel.S_ORDER where ORDER_NUM in 
('2-30286194921')) and 
PAR_ORDER_ITEM_ID is null and
(PROCESSED_FLG <> 'Y' or STATUS_CD='97完成') and
ACTION_CD<>'现有的'

--2.查询所有行项目ID
--先将行项目刷成97完成状态，再查询所有行项目的ID，在模拟器中运行
--CRM模拟器在首页放大镜中寻找，随后加载文件1和文件2,在文件2的窗口下属性值中输入ROW_ID
--（格式|2-DS9XRG0|2-DS9XRH7|），再进行执行
--2-30007915046成功完工，其关联子订单：2-30017522181，2-30017529510也完工了


select * from siebel.S_ORDER where ORDER_NUM='2-30287514725'
update siebel.S_ORDER set STATUS_CD='通过合法性校验' where row_id='2-DWWEJXH';
commit;
--改CRM状态为通过合法性校验

select * from siebel.S_ORDER where ORDER_NUM='2-30078809860';
update siebel.S_ORDER set STATUS_CD='通过合法性校验' where row_id='2-DTG5A84';
commit;
--2-22494391826（LHH）,2-22414821620(ZQY),All updated successfully!

select STATUS_CD from siebel.S_ORDER where ORDER_NUM in ('2-30007915046','2-30017522181','2-30017529510');
select STATUS_CD from siebel.S_ORDER where ORDER_NUM = '2-30023855818';
--查询订单的状态

select * from siebel.S_ORDER where STATUS_CD='通过合法性校验'

select userenv('language') from dual;

select ORDER_NUM from siebel.S_ORDER where CREATED between to_date('2020-01-17','yyyy-mm-dd') and to_date('2020-01-18','yyyy-mm-dd');
-- 根据指定时间内，查询CRM系统受理的订单号

select * from siebel.S_ORDER order by CREATED;
--,2-30261123955

-- 20200119: 
-- 2-30286194921 (FTTO接入的普通电话，做直改中)，2-30287503814（FTTO接入的直改中订单,P7和IBP报文都有IMS类型和IMS_Type字段）
--2-30287548338(配的是光)，2-30287565771(系统优先接入的普通电话，做直改中，没IMS类型)，2-30287552777（系统优先接入的直改中订单）
-- 2-30287426773 (普通接入的普通电话，没IMS类型）
-- WMX2020011905148545(配的是光)（系统优先接入的固定电话产品，没IMS类型）

