select c.STATUS,c.* from wp_srq c where p6_order_id in ('37186') and TASK_ID like '%kb%'; --��������״̬���Խӿͱ��ܿ����͹����ɹ���ʧ��
--- wp_srq�е�
--- Status��101δ���ͣ�102���ɷ���104�Ѵ�ӡ��
--- 105�ѿ�����255�ѳ�����250��������254�����С�253�˵��С�251���޸�
--- TASK_IDΪddxx:1��WOP����������WOP�����ϲ�ѯ��2M��WOP���������Ի�����û��


-- order by receive_dts desc 
-- select ww.PROCESS_STATUS,ww.* from wp_p6_req ww where p6_order_id in('36234'); --�˹���������
--- wp_p6_req�е�
--- PROCESS_STATUS��101δ���ͣ�102���ɷ���104�Ѵ�ӡ��105�ѿ�����
--- 255�ѳ�����250��������254�����С�253�˵��С�251���޸�
--- wp_srq��process_flag��02�ɹ���0P��0Eʧ��
--- ��Ҫ�ڿͱ������жԹ������лص���״̬�Żᷢ���仯



-- order by CREATE_DTS desc 

--(2019)/19076225_0001PZ��P6��Ϊ15094
--(2019)/19076222_0001PZ,P6��Ϊ15091

select a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMZ2020010900535453') and a.plane_type='111'
--��֤�ֶΣ���device_serial_num������device_model������sla_servcie������safety_audit������intrusion_detection_defense������four_layer_firewall������web_apply_protect��

select a.crm_order_id,a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMX2020070205552043','WMX2020070205552056','WMX2020070205552102','WMX2020070205552100','WMX2020070105552001','WMX2020070205552126','WMX2020070205552136','WMX2020070205552135');
--5.��֤IBP���Ϳͱ����߹�����������set_top_box_4k Ϊ��18����֤������½WOP���ݿ�

select a.crm_order_id,a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMX2020061905549744','WMX2020061905549864','WMX2020062005549865','WMX2020062005549867','WMX2020061905549863','WMX2020062005549866','WMX2020062005549868');
--����ʿ��Ҫ���ͱ����ߵĶ���

--WOP �ʺţ�wopdb     ���룺nophsq
