select STATUS_CD,CUST_ORDER_ID from customer_order WHERE CUST_ORDER_NBR = 'WMZ2020040405291359'; 
#客户订单表
#STATUS_CD  记录工单状态:201700:待发送,201300:开通中,201200:待前序订单项反馈'，201900：待集团下单，300000：竣工，20000为已提交（未发送到IBP）

select * from customer_order where STATUS_CD = '300000';

select STATUS_CD from work_order WHERE cust_order_id = 'WMZ2020040405291359';
#工单表

select STATUS_CD from work_order WHERE CUST_ORDER_NBR = 'WMZ2020011705147885';

select * from work_order where STATUS_CD = '201900';

#STATUS_CD  记录工单状态:201700:待发送,201300:开通中,201200:待前序订单项反馈'，300000：竣工，20000为已提交（未发送到IBP）
