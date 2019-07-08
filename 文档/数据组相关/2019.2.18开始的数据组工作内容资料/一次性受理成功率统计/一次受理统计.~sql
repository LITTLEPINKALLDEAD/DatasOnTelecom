select 
tt.qj 区局,
tt.zl 总量,
tt.crm crm撤单,
case 
  when tt.crm = 0                                           --若撤单数为0，则直接填‘0.00%’
    then '0.00%'
  else to_char(round(tt.crm/tt.zl*100,2),'fm999990.00')||'%'
end crm撤单率,
tt.kb 客保撤单,
case 
  when tt.kb = 0
    then '0.00%'
  else to_char(round(tt.kb/tt.zl*100,2),'fm999990.00')||'%'
end 客保撤单率,
tt.zz 综资撤单,
case 
  when tt.zz = 0
    then '0.00%'
  else to_char(round(tt.zz/tt.zl*100,2),'fm999990.00')||'%'
end 综资撤单率,
to_char(round((tt.zl-tt.crm-tt.kb-tt.zz)/tt.zl*100,2),'fm999990.00')||'%' 一次受理成功率
from
(select 
decode(tmp.qj,'1','浦东','2','东区','3','西区','4','南区','5','北区','6','中区',
'7','莘闵','8','宝山','9','机场','a','专用','c','金山','d','崇明','e','嘉定','f','青浦','g','奉贤',
'h','南汇','i','松江') qj,
count(1) zl,
sum(tmp.crm) crm,
sum(tmp.kb) kb,
sum(tmp.zz) zz
from
(select 
aa.bureau_code qj,
case 
  when aa.if_kb_tuidan = '否' and aa.if_zz_tuidan = '否' and aa.order_status in ('3','6')       --CRM退单
    then 1
  else 0
end crm,
case
  when aa.if_kb_tuidan = '是'                                                                   --客保退单
    then 1
  else 0
end kb,
case
  when aa.if_zz_tuidan = '是'                                                                   --综资退单
    then 1
  else 0
end zz
from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') >= add_months(trunc(sysdate,'mm'),-1)
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') < trunc(sysdate,'mm')
) tmp
group by decode(tmp.qj,'1','浦东','2','东区','3','西区','4','南区','5','北区','6','中区',
'7','莘闵','8','宝山','9','机场','a','专用','c','金山','d','崇明','e','嘉定','f','青浦','g','奉贤',
'h','南汇','i','松江')
) tt


