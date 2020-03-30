select * from product where prod_name  like'%国际及%' limit 50;

select * from offer where offer_name like'%东欧%';

select * FROM  attr_spec  WHERE   attr_nbr ='PRD-0004' -- 根据字段状态编码
select * from  attr_value where attr_id = '10000490' -- 根据属性id查看具体状态类型  

SELECT 
	s.attr_name,
	s.attr_desc,
	v.*
FROM
	attr_spec s,
	attr_value v
WHERE
	s.attr_id = v.attr_id
AND s.attr_name like '%停机%'  -- 查停机类型 

-- 新老产品编码映射
select * from product_mapping where crm_prod_nbr = '121';
select * from product_mapping where crm_prod_nbr = '101';
select * from product_mapping where PROD_ID = '10000315029';
-- 查询产品
select * from offer where offer_type in(11,10) and status_cd = '1000' and offer_id in (
select offer_id from offer_prod_rel where prod_id =10000314717) ;-- 修改此id

select * from offer where offer_type in(11,10) and status_cd = '1000' and offer_id in (
select offer_id from offer_prod_rel where prod_id =1000004955) ;

select * from offer where offer_type in(11,10) and status_cd = '1000' and offer_id in (
select offer_id from offer_prod_rel where prod_id IN (select prod_id from product_mapping where crm_prod_nbr = '101'));

select * from product a,product_mapping b where a.PROD_ID=b.PROD_ID and b.CRM_PROD_NBR in('272','510');

select * from product a,product_mapping b where a.PROD_ID=b.PROD_ID and b.CRM_PROD_NBR = '300';

select * from product a,product_mapping b where a.PROD_ID=b.PROD_ID and b.CRM_PROD_NBR in('482');

select * from offer where offer_type in(11,10) and status_cd = '1000' and offer_id in (
select offer_id from offer_prod_rel where OFFER_NAME like "%出租电路%") ;

select * from offer where offer_type in(11,10) and status_cd = '1000' and OFFER_NAME like "%固定电话%";
select OFFER_ID from offer_prod_rel where prod_id =1000004955;

select * from offer,offer_prod_rel where offer.offer_id = offer_prod_rel.offer_id 
and OFFER_NAME like "%基础销售品-云主机%" and offer.offer_type in(11,10) and offer.STATUS_CD = '1000';

select * from product_mapping where PROD_ID = '10000315353';

select CRM_PROD_NBR from product_mapping where PROD_ID in (select PROD_ID from offer,offer_prod_rel where offer.offer_id = offer_prod_rel.offer_id 
and OFFER_NAME like "%基础销售品-出租电路调单流程%" and offer.offer_type in(11,10) and offer.STATUS_CD = '1000');

select * from product a,product_mapping b where a.PROD_ID=b.PROD_ID and b.CRM_PROD_NBR in('465','466','479');
-- 通过新CRM销售品名称，查询Offer_id，Prod_id，并查询老CRM对应的产品编号

-- 新老产品编码映射
select * from product_mapping where crm_prod_nbr = '524';
update offer set EXP_DATE='2019-09-07 00:00:00' where OFFER_ID='990000145389955';
-- 查询产品
select * from offer where offer_type in(11,10) and status_cd = '1000' and offer_id in (
select offer_id from offer_prod_rel where prod_id =1000001359) ;-- 修改此id

select * from offer where offer_id in (
select offer_id from offer_prod_rel where prod_id in (
select prod_id from product_mapping pm where pm.CRM_PROD_NBR in ('462'))
and status_cd != '1100')

select * from product where prod_id='' limit 50;  -- 产品表
select * from product where prod_name  like'%%' limit 50; -- 产品表
select * from offer where offer_id=''; -- 销售品表
select * from offer where offer_name like'%%'; -- 销售品表
select * from prod_rel where Z_PROD_ID='' limit 50; -- 产品关系表
select * from prod_rel where A_PROD_ID=''; -- 产品关系表
select * from offer_rel where Z_offer_ID=''; -- 销售品关系表
select * from offer_rel where A_offer_ID=''; -- 销售品关系表
select * from product where prod_id in(select A_PROD_ID from prod_rel where Z_PROD_ID='') -- 根据子产品id查询根产品信息
select * from offer where offer_id in(select A_offer_ID from offer_rel where Z_offer_ID='') -- 根据附属商品id查询销售品品信息
SELECT b.OFFER_NAME FROM offer_ext a,offer b WHERE OFFER_SUB_TYPE='014'
AND a.OFFER_ID = b.OFFER_ID -- 查询终补话补等可选包类型,06终，09话
select * from offer_res_rel where offer_id='166259787332' -- 查询终端配机型status=1000