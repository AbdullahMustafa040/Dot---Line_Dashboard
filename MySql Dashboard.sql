SELECT * FROM 
(
	SELECT x.Dated ,y.TotalLead,x.assigned As Assigned,x.scheduled As 'Scheduled',x.Attended FROM 
	(
		select
			date_format(created_at, '%Y-%m-01') As Dated,
			count(*) As assigned,
			ABS(sum((if(dealstage = 'attended' or dealstage = 'registered' or dealstage = 'scheduled' ,1,0)))) As 'scheduled',
			ABS(sum((if(dealstage = 'attended' or dealstage = 'registered'  ,1,0)))) As 'Attended'
		from
		(
				select * from deals
		)As AllData group by 1
	)	 as x, 
	(
		select * from
		(
			select
				date_format(created_at, '%Y-%m-01') As Dated,
				count(*) As TotalLead from
				(
				select * from leads
				where created_at>='2021-01-01'
				)
			As a group by 1 
		)As ToalLeadPer
		where Dated is not null and Dated !='0000-00-1'
	) as y where x.Dated=y.Dated
) as firstData
, 
(
	select * from
    ( 
		select date_format(registration_date, '%Y-%m-01') As Dated,
		count(*) As TotalStudent from
        (
			select * from students 
		)As a group by 1 
	)As b where Dated>='2021-01-01'
) as secondData 
,
(
	select 
	date_format(created_at, '%Y-%m-01') As Dated,
	count(*) As countes from 
	(
		select * from website_payments where status='paid'
	)As a group by 1 
)As thirdData 
,
(
		select date_format(registration_date, '%Y-%m-01') As Dated,
		count(*) As Student from
        (
			select * from students   where country!='Pakistan'
		)As a group by 1
) As forthData
where firstData.Dated=secondData.Dated and thirdData.Dated='2021-06-01'and secondData.Dated='2021-06-01' and forthData.Dated='2021-06-01';
