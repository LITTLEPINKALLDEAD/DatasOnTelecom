select * from customer where CUST_NAME like '%测试用户27110143888%'

select IS_REALNAME,cust_number from customer where cust_type = '1100'; -- 查政企客户
update customer set IS_REALNAME='1' where cust_number='202110499539'  
select iccid from prod_inst where acc_num = '18918585073';
update prod_inst set STATUS_CD = '140001' where acc_num = '17321080467'
update prod_inst set STATUS_CD = '140001' where acc_num = '17321082284';
select * from prod_inst where prod_inst_id in(select prod_inst_id from prod_inst_state where stop_type='120000');-- 查停机类型设备号
select * from cust_addr_rel where BUREAU_NAME is not NULL  -- 客户地址
select * from cust_addr_rel where cust_id='400000060234';
update cust_addr_rel set addr_name='上海新村1388弄2号楼6层9室' where CUST_ID='400000060234'; -- 改客户地质
select * from prod_inst where acc_num ='17301846308'
select STOP_TYPE from prod_inst_state where PROD_INST_ID in (select PROD_INST_ID from prod_inst where acc_num='17301846308') limit  40;
select * from prod_inst_rel where rel_type='101300'; -- 根产品关系表

UPDATE customer SET cust_type = '1000' WHERE  cust_id ='48104832' --改政企
select cust_number from customer where cust_id in(202113056827);
SELECT ACC_NUM FROM prod_inst WHERE OWNER_CUST_ID IN (
SELECT OBJ_ID FROM special_list WHERE SUB_SPECIAL_TYPE = 120002 AND PROD_ID = 1000001315) -- 查黑名单根产品类型的设备号

SELECT * FROM prod_inst_state WHERE ACC_NUM='KD2000005047'; -- 查询停机类型
select SUB_SPECIAL_TYPE from special_list where obj_id=202177409292; -- 查询该客户黑名单类型
update special_list set SUB_SPECIAL_TYPE = '120002' where obj_id='400000060234'; -- 改黑名单类型
select * from special_list where  obj_id=4866992; -- 查询该客户是否在黑名单中
delete  from special_list where obj_id='221958243803'  --移除黑名单
update special_list set SPECIAL_TYPE = '1200' where obj_id=202125917528;  -- 改黑名单类型

select * from customer where cust_id = '300004861220' -- 根据客户id查
update customer set IS_REALNAME = '1' WHERE cust_number = '300005098806' -- 根据客户标识改变实名状况
select STATUS_CD from prod_inst where acc_num ='18901603553' -- 查询根产品状态
select * from prod_inst_state where prod_inst_id in(select prod_inst_id from prod_inst where ACC_NUM='18918586722') -- 查该设备号停机类型
select * from prod_inst_state where prod_inst_id='35774478' -- 停机类型表
SELECT * from prod_inst where  prod_inst_id in (
SELECT PROD_INST_ID FROM offer_prod_inst_rel where OFFER_INST_ID in 
(SELECT OFFER_INST_ID from offer_inst where OFFER_id=219904101193));  limit 100-- 查询资产
select act_date,prod_inst_id,prod_id from prod_inst where acc_num='18916378428'
select acc_num from prod_inst where STATUS_CD ='140001'; -- 查预开通设备号
select * from customer where cust_number=202110271272;  -- 查客户id
update prod_inst set STATUS_CD ='140001' where acc_num='13331902667'; -- 改预开通设备号
select * from prod_inst where PROD_INST_ID in
(SELECT A_PROD_INST_ID from prod_inst_rel WHERE REL_TYPE =100602 and STATUS_CD = 1000); 
SELECT * from prod_inst where acc_num='13331890387' -- 根据设备号查询
select * from offer_inst where OWNER_CUST_ID in(select OWNER_CUST_ID from prod_inst where acc_num='13331890387'); -- 该设备号含有的销售品类型
select * from party_cert  where cert_num='CY1997';  -- 证件号查询
select * from offer_inst where OWNER_CUST_ID='400000057203'; -- 销售品实例表
select * from offer_prod_inst_rel -- 销售品产品实例关系表
select * from prod_inst_state  -- 停机类型表
SELECT * FROM party_cert  -- 证件类型表
SELECT cust_number FROM customer WHERE party_id IN (SELECT party_id FROM party_cert WHERE cert_Type='7');     -- 查找客户的证件类型
SELECT acc_num from prod_inst where STATUS_CD !=110000 and prod_inst_id in(
(SELECT prod_inst_id from prod_inst_attr where ATTR_ID=990000160013 and ATTR_ID!=990000190080)); 携出设备号
select table_schema,table_name from information_schema.columns where column_name = 'address_id' -- 根据字段可查询所有库包含该字段的表表
select * from prod_inst_attr
select * from prod_inst_attr where prod_inst_id in(select * from prod_inst where acc_num='KD2000017513');
select a.*,b.* from prod_inst a,prod_inst_attr b where a.prod_inst_id=b.prod_inst_id limit 50; -- 产品实例属性表和产品实例表
select offer_id,OFFER_INST_ID from offer_inst f,prod_inst p where f.OWNER_CUST_ID=p.OWNER_CUST_ID and acc_num='KD0007211707' and  limit 100;

select PROD_ID from prod_inst where ACC_NUM = 17321080467 limit 50;

select b.attr_name ,b.ATTR_VALUE from prod_inst a,prod_inst_attr b where a.prod_inst_id=b.prod_inst_id and ACC_NUM = 13301653262;