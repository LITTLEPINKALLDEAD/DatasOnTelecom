SELECT * FROM intf_send_data WHERE CHANNEL_NBR = 'special' AND CUST_ORDER_ID = '33060052';

select o.CUST_ORDER_ID,o.CUST_ORDER_NBR,o.STATUS_CD from customer_order o where o.CUST_ORDER_NBR='WMX2019091800434911'-- 受理库用流水单查 CUST_ORDER_ID
SELECT s.status_cd, s.deal_num, s.batch_task_id, s.file_row_id, s.priority, s.create_date, s.batch_task_source_id, s.random_num
	FROM batch_task_source s, batch_task t WHERE s.batch_task_id = t.batch_task_id 
	AND t.batch_task_nbr = 'BATCH2019092351412173' ORDER BY file_row_id;
 -- 查询批量订单的预处理优先级
SELECT * from intf_send_data where CUST_ORDER_ID = '400802047086' and CHANNEL_NBR ='cep';
SELECT * from work_order where CUST_ORDER_NBR ='WMX2019111200503337' limit 10;
SELECT * from work_order where 
SOURCE_CUST_ORDER_ID ='400800828575' limit 100; 
SELECT CUST_ORDER_ID from customer_order where CUST_ORDER_NBR='WMX2019102100491323'; -- 订单
select work_order_id from work_order where cust_order_nbr='WMX2019102100489441'; -- 工单
SELECT * from ord_mkt_res_inst where SOURCE_CUST_ORDER_ID='400800875389' and MKT_RES_INST_ID='13341691970';
SELECT * from ord_prod_res_inst_rel where SOURCE_CUST_ORDER_ID='400800875389';
-- 查看竣工异常
SELECT msg, OBJ_ID, APPLY_OBJ_SPEC FROM job_log, order_item, customer_order 
	WHERE job_log.SHARDING_ID = customer_order.CUST_ORDER_ID AND order_item.SOURCE_CUST_ORDER_ID = customer_order.CUST_ORDER_ID
		AND customer_order.CUST_ORDER_NBR = 'WMX2019080700318284';

-- 出流水失败异常
SELECT attr.order_item_id, attr.ATTR_VALUE 
	FROM order_item_attr attr, order_item item, customer_order orde
	WHERE attr.ORDER_ITEM_ID = item.ORDER_ITEM_ID AND item.SOURCE_CUST_ORDER_ID = orde.SOURCE_CUST_ORDER_ID
		AND orde.CUST_ORDER_NBR = 'WMX2019080700318284';
SELECT * FROM intf_send_data d WHERE 1=1 and d.CHANNEL_NBR='mscReject' and d.CUST_ORDER_ID='400801330705';
SELECT * FROM intf_send_data_his WHERE CUST_ORDER_ID = '400801409169';
SELECT * FROM intf_send_data WHERE CUST_ORDER_ID = '400801409169';
SELECT OFFER_INST_ID,PROD_INST_ID,REL_TYPE,ORD_STATUS_CD,STATUS_CD,OPER_TYPE，role_id
FROM ord_offer_prod_inst_rel WHERE SOURCE_CUST_ORDER_ID=400801410493;  -- 根产品和子产品关系
SELECT * FROM  customer_order WHERE CUST_ORDER_NBR="WMY2019090500428553" -- 查订单状态
select i.ORDER_ITEM_ID,i.status_cd 订单项状态,o.STATUS_CD 订单项状态,i.update_date i_u,o.UPDATE_DATE o_u,o.CUST_ORDER_ID,
i.order_item_cd,i.apply_obj_spec, i.OBJ_ID,o.CREATE_DATE
 from customer_order o,order_item i
where i.CUST_ORDER_ID=o.CUST_ORDER_ID
and o.CUST_ORDER_NBR='WMZ2019082000320993'-- 查订单状态，订单项状态