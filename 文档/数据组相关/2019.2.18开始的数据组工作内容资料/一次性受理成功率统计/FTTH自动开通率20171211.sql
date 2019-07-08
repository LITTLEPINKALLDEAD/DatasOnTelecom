declare
  cursor c_ooi is 
  select * from iom20.OM_ORDER_INFO ooi
  where ooi.PRODUCT_CODE in ('101','524','566')
  and
  (
    (ooi.finish_time>=to_date('2019-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
     and ooi.finish_time <to_date('2019-02-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
    )
    or
    (to_date(ooi.ACCEPT_TIME,'yyyy-mm-dd hh24:mi:ss')>=to_date('2019-01-08 00:00:00','yyyy-mm-dd hh24:mi:ss') 
     and to_date(ooi.ACCEPT_TIME,'yyyy-mm-dd hh24:mi:ss') <to_date('2019-01-12 00:00:00','yyyy-mm-dd hh24:mi:ss')
    )
  )
  and not exists(select * from ftth_once_success_20170516 aa where aa.order_seq_id=ooi.order_seq_id)
  --and ooi.order_seq_id='70001999'
  --and ooi.order_seq_id='2021625463'
  ;
  

  error   VARCHAR2(255);
  a number;
  n2 number:=0;
  v_product_info          iom20.PRODUCT_INFO%rowtype;
  v_access_info           iom20.ACCESS_INFO%rowtype;
  v_customer_info         iom20.CUSTOMER_INFO%rowtype;
  v_receive_time          iom20.work_order_info.receive_time%type;
  v_work_order_info       iom20.work_order_info%rowtype;
  v_kb_tuidan_time_min    iom20.work_order_info.return_time%type;
  v_zz_tuidan_time_min    iom20.CRM_ORDER_STATUS.status_time%type;
  v_if_kb_tuidan        VARCHAR2(20);
  v_if_zz_tuidan        VARCHAR2(20);
  v_order_status        VARCHAR2(10);
  v_t_open_billinfo         ufms.T_OPEN_BILLINFO%rowtype;
  v_t_open_billinfo_his     ufms.T_OPEN_BILLINFO_HIS%rowtype;
  v_bill_id                  ufms.T_OPEN_BILLINFO.BILL_ID%type;
  v_kb_tuidan_reason        ufms.T_OPEN_BILLINFO.REVERT_CODE%type;
  v_zz_tuidan_reason        iom20.CRM_ORDER_STATUS.status_desc%type;
  v_error_reason            iom20.work_order_info.error_reason%type;

begin   
  
  for cc1 in c_ooi loop
      error:=null;
      n2:=0;
      v_product_info:=null;
      v_access_info:=null;
      v_customer_info:=null;
      v_receive_time:=null;
      v_work_order_info:=null;
      v_kb_tuidan_time_min:=null;
      v_zz_tuidan_time_min:=null;  
      v_if_kb_tuidan:='否';
      v_if_zz_tuidan:='否';  
      v_order_status:=to_char(cc1.status);
      v_t_open_billinfo:=null;
      v_t_open_billinfo_his:=null;
      v_bill_id:=null;
      v_kb_tuidan_reason:=null;
      v_zz_tuidan_reason:=null;
      v_error_reason:=null;
            
      begin   
        --获取操作类型      
        begin        
          select * into v_product_info from iom20.PRODUCT_INFO pi 
          where pi.order_seq_id=cc1.order_seq_id;
        exception
          when others then
               null;
        end;
        
        if v_product_info.ACTIOIN_NAME like 'Z%' or v_product_info.ACTIOIN_NAME like 'Y%'
        or v_product_info.ACTIOIN_NAME like 'X%' then
          --获取接入类型和接入方式 
          begin        
            select * into v_access_info from iom20.ACCESS_INFO ai 
            where ai.order_seq_id=cc1.order_seq_id;
          exception
            when others then
                 null;
          end;
          
          if (cc1.product_code='101' and v_access_info.connect_type_new in ('SIP语音','FTTO语音'))
          or (cc1.product_code in ('524','566') and v_access_info.access_type_new='FTTH') then      
            begin        
              insert into ftth_once_success_20170516 
              (product_code,bureau_code,crm_order_code,order_seq_id,accept_time,
              finish_time,action_name,access_type_new,connect_type_new,device_no)
              values 
              (cc1.product_code,cc1.LOCATION_BUREAU_CODE,cc1.crm_order_code,cc1.order_seq_id,cc1.ACCEPT_TIME,
              cc1.finish_time,substr(v_product_info.ACTIOIN_NAME,1,30),
              substr(v_access_info.access_type_new,1,30),substr(v_access_info.connect_type_new,1,30),
              substr(v_product_info.DEVICE_NO,1,30));
              
              commit;
            exception
              when others then
                null;
            end;
  
            
            --获取客保退单原因
            begin  
                select * into v_t_open_billinfo 
                from ufms.T_OPEN_BILLINFO tob
                where tob.SPS_ORDERID=to_char(cc1.order_seq_id)
                and tob.work_type not in ('18','19','22','23','26','27','32','33','36','37','4','9')  --剔除移拆的工单
                and rownum=1;
            exception
              when others then
                   null;
            end;
            
            if v_t_open_billinfo.bill_id is null then
                begin    
                    select * into v_t_open_billinfo_his 
                    from ufms.T_OPEN_BILLINFO_HIS tob
                    where tob.SPS_ORDERID=to_char(cc1.order_seq_id)
                    and tob.work_type not in ('18','19','22','23','26','27','32','33','36','37','4','9')  --剔除移拆的工单
                    and rownum=1;
                exception
                  when others then
                       null;
                end;
            end if;    
            v_bill_id:=nvl(v_t_open_billinfo.bill_id,v_t_open_billinfo_his.bill_id);
            v_kb_tuidan_reason:=nvl(v_t_open_billinfo.revert_code,v_t_open_billinfo_his.revert_code);
            if v_kb_tuidan_reason is not null then
              v_if_kb_tuidan:='是';      
            end if;
            v_kb_tuidan_reason:=nvl(v_kb_tuidan_reason,'无');
            
            --获取综资退单时间和退单原因（取第一次的）
            begin  
              select min(cos.status_time) into v_zz_tuidan_time_min 
              from  iom20.CRM_ORDER_STATUS cos
              where cos.order_seq_id=cc1.order_seq_id
              and cos.status='97退单'
              and cos.process in ('12078','12079','11921','11922','12257','12258','11599','11600','11686','11687',
                                  '11553','11554','11443','11444','12127','12128','12870','12871','12875','12876',
                                  '13076','12331','12332','12785','12796','12797','13276','13267')
              and cos.status_time is not null
              ;  
              if v_zz_tuidan_time_min is not null then  
                v_if_zz_tuidan:='是';  
                begin    
                  select status_desc into v_zz_tuidan_reason 
                  from  iom20.CRM_ORDER_STATUS cos
                  where cos.order_seq_id=cc1.order_seq_id
                  and cos.status='97退单'
                  and cos.process in ('12078','12079','11921','11922','12257','12258','11599','11600','11686','11687',
                                      '11553','11554','11443','11444','12127','12128','12870','12871','12875','12876',
                                      '13076','12331','12332','12785','12796','12797','13276','13267')
                  and cos.status_time=v_zz_tuidan_time_min
                  ;  
                exception
                  when others then
                       null;
                end;  
              end if;  
            exception
              when others then
                   null;
            end;  
            
            --取ONU激活失败原因
            begin  
              select max(woi.receive_time) into v_receive_time 
              from iom20.work_order_info woi
              where woi.order_seq_id=cc1.order_seq_id
              and woi.exec_system_id='激活'
              and woi.platform_code in ('ALC','HW','ZTE')
              and woi.error_reason is not null;
              
              select * into v_work_order_info 
              from iom20.work_order_info woi
              where woi.order_seq_id=cc1.order_seq_id
              and woi.exec_system_id='激活'
              and woi.platform_code in ('ALC','HW','ZTE')
              and woi.error_reason is not null
              and woi.receive_time=v_receive_time
              and rownum=1;
            exception
              when others then
                   null;
            end;
      
            v_error_reason:=nvl(v_work_order_info.error_reason,'无');
            
            --获取户名地址
            begin        
              select * into v_customer_info from iom20.CUSTOMER_INFO ci 
              where ci.crm_order_code=cc1.crm_order_code;
            exception
              when others then
                   null;
            end;    
                
            begin        
              update ftth_once_success_20170516 set
              customer_name=substr(v_customer_info.customer_name,1,30),
              customer_address=substr(v_customer_info.customer_address,1,60),
              if_kb_tuidan=v_if_kb_tuidan,
              kb_tuidan_time_min=v_kb_tuidan_time_min,
              kb_tuidan_reason=v_kb_tuidan_reason,
              if_zz_tuidan=v_if_zz_tuidan,
              zz_tuidan_time_min=v_zz_tuidan_time_min,
              zz_tuidan_reason=substr(v_zz_tuidan_reason,1,50),
              order_status=v_order_status,
              onu_error_reason=v_error_reason
              where order_seq_id=cc1.order_seq_id;
              
              commit;
            exception
              when others then
                begin   
                  error:=sqlerrm;     
                  update ftth_once_success_20170516 set
                  zz_tuidan_reason=substr(error,1,200)
                  where order_seq_id=cc1.order_seq_id;
                  
                  commit;
                exception
                  when others then
                    null;
                end;
            end;
          end if;
        end if;
                  
      exception
        when others then
             null;
      end;
  end loop;
  commit;

exception
    when others then
      null;
end ;
