select * from received_message where crm_order_number = '(2019)/384611219'; --��SOP�Ƿ��յ�CRM�ύ�Ķ���
select * from p6_order_info where crm_order_number = '(2019)/384611219'; -- ��SOP��P7��״̬
--where crm_order_number = '2-29936865024'
--ORDER BY status_time DESC
--2-29936865024 
--(2019)/19076141_0002C

select r.message_body from received_message r where r.crm_order_number in ('WMX2019121900527359','WMX2019121900527390','WMX2019121900526634','WMX2019121900526637');
-- ��ѯ������Relay Type��ֵΪsip�м�1

select r.message_body from received_message r where r.crm_order_number in ('WMX2019121900527361','WMX2019121900527392','WMX2019121900526630');
-- ��ѯ������Relay Type��ֵΪsip�м�2

--SOP �ʺţ�testorder   ���룺testorder
