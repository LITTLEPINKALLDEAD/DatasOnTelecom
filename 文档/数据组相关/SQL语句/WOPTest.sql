select * from wp_srq where p6_order_id = '35096'; --��������״̬
-- order by receive_dts desc 
select * from wp_p6_req where p6_order_id = '35096'; --�˹���������
-- order by CREATE_DTS desc 

--(2019)/19076225_0001PZ��P6��Ϊ15094
--(2019)/19076222_0001PZ,P6��Ϊ15091

select a.p6_req_content from wp_p6_req a where a.crm_order_id in ('2-30261387506','2-30261405580')  and a.plane_type='111'
-- ��֤�ֶΡ�device_serial_num������device_model������sla_servcie������safety_audit������intrusion_detection_defense������four_layer_firewall������web_apply_protect��
--'2-30261387506'

--WOP �ʺţ�wopdb     ���룺nophsq
