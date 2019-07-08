
--分母：
select count(*) from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-05-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
;

分子：
select count(*) from ftth_once_success_20170516 gy
where to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-03-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
and (gy.if_kb_tuidan='是' or gy.if_zz_tuidan='是' or gy.order_status in ('3','6'));

FTTH退单、撤单、取消订单清单：
select decode(gy.bureau_code,'1','浦东','2','东区','3','西区','4','南区','5','北区','6','中区',
'7','莘闵','8','宝山','9','机场','a','专用','c','金山','d','崇明','e','嘉定','f','青浦','g','奉贤',
'h','南汇','i','松江'),gy.* 
from ftth_once_success_20170516 gy
where to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2019-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2019-02-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
and (gy.if_kb_tuidan='是' or gy.if_zz_tuidan='是' or gy.order_status in ('3','6'));


select * from ftth_once_success_20170516 gy where action_name = 'Y' and product_code in ('524','566')
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-07-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(gy.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-08-01 00:00:00','yyyy-mm-dd hh24:mi:ss')


区局总量：
select decode(aa.bureau_code,'1','浦东','2','东区','3','西区','4','南区','5','北区','6','中区',
'7','莘闵','8','宝山','9','机场','a','专用','c','金山','d','崇明','e','嘉定','f','青浦','g','奉贤',
'h','南汇','i','松江'),count(*) from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-12-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2019-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss')
group by decode(aa.bureau_code,'1','浦东','2','东区','3','西区','4','南区','5','北区','6','中区',
'7','莘闵','8','宝山','9','机场','a','专用','c','金山','d','崇明','e','嘉定','f','青浦','g','奉贤',
'h','南汇','i','松江');

select aa.* from ftth_once_success_20170516 aa 
where to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss')>=to_date('2018-03-01 00:00:00','yyyy-mm-dd hh24:mi:ss') 
and   to_date(aa.accept_time,'yyyy-mm-dd hh24:mi:ss') <to_date('2018-04-01 00:00:00','yyyy-mm-dd hh24:mi:ss');


