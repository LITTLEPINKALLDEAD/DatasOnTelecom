select ap.xml_request from asap_workorder_request ap where ap.crm_order_no in('WMX2019121900527359','WMX2019121900527390','WMX2019121900526634','WMX2019121900526637') and ap.request_type='cdma_work_order';
select ap.xml_request from asap_workorder_request ap where ap.crm_order_no in('WMX2019121900527361','WMX2019121900527392','WMX2019121900526630') and ap.request_type='cdma_work_order';
-- C网P7查询：assp发出的是字典值：1代表sip中继1，2代表sip中继2 (p_yunyin_assistant_attr字段)
