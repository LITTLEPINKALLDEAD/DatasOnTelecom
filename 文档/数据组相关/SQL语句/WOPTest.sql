select * from wp_srq where p6_order_id in('36219'); --��������״̬���Խӿͱ��ܿ����͹����ɹ���ʧ��
--- wp_srq�е�
--- Status��101δ���ͣ�102���ɷ���104�Ѵ�ӡ��
--- 105�ѿ�����255�ѳ�����250��������254�����С�253�˵��С�251���޸�
--- process_flag��02�ɹ���0P��0Eʧ��

-- order by receive_dts desc 
select * from wp_p6_req where p6_order_id in('36219'); --�˹���������
--- wp_p6_req�е�
--- PROCESS_STATUS��101δ���ͣ�102���ɷ���104�Ѵ�ӡ��105�ѿ�����
--- 255�ѳ�����250��������254�����С�253�˵��С�251���޸�



-- order by CREATE_DTS desc 

--(2019)/19076225_0001PZ��P6��Ϊ15094
--(2019)/19076222_0001PZ,P6��Ϊ15091

select a.p6_req_content from wp_p6_req a where a.crm_order_id in ('WMZ2020010900535453') and a.plane_type='111'
--��֤�ֶΣ���device_serial_num������device_model������sla_servcie������safety_audit������intrusion_detection_defense������four_layer_firewall������web_apply_protect��



--WOP �ʺţ�wopdb     ���룺nophsq
