SELECT * FROM (
SELECT x.Dated ,y.TotalLead,x.assigned As Assigned,Round((x.assigned*100/TotalLead)) As '% Assigned',x.scheduled As 'Scheduled',Round((x.scheduled*100)/x.assigned) As '% Scheduled',x.Attended,Round((x.Attended*100)/scheduled) As '% Attended' FROM 
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
)	 as x, (select * from(
select
	date_format(created_at, '%Y-%m-01') As Dated,
	count(*) As TotalLead from
    (
	select * from leads
	where created_at>='2021-01-01'
	)
As a group by 1 )As ToalLeadPer
where Dated is not null and Dated !='0000-00-1') as y where x.Dated=y.Dated
) as firstData, (select * from( 
select date_format(registration_date, '%Y-%m-01') As Dated,
count(*) As Student from(
select * from students 
)As a group by 1 )As b where Dated>='2021-01-01') as secondData where firstData.Dated=secondData.Dated;

