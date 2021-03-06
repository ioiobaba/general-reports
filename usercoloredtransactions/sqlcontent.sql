select t.FOLLOWUPID, t.PAYEENAME, t.TRANSDATE, t.TRANSAMOUNT
    , t.TRANSAMOUNT*c.BASECONVRATE as BaseAmount
    , c.PFX_SYMBOL, c.SFX_SYMBOL
from
    (select p.PAYEENAME as PAYEENAME, c1.TRANSDATE as TRANSDATE, c1.FOLLOWUPID as FOLLOWUPID,
        (case when c1.TRANSCODE = 'Deposit' then c1.TRANSAMOUNT else -c1.TRANSAMOUNT end) as TRANSAMOUNT,
        a1.CURRENCYID as CURRENCYID
    from CHECKINGACCOUNT_V1 as c1
    inner join PAYEE_V1 as p on p.PAYEEID = c1.PAYEEID
    inner join ACCOUNTLIST_V1 as a1 on a1.ACCOUNTID = c1.ACCOUNTID
    union all
    select a2.ACCOUNTNAME, c2.TRANSDATE, c2.FOLLOWUPID, c2.TOTRANSAMOUNT, a2.CURRENCYID
    from CHECKINGACCOUNT_V1 as c2
    inner join ACCOUNTLIST_V1 as a2 on a2.ACCOUNTID = c2.TOACCOUNTID
    where TRANSCODE = 'Transfer') as t
inner join CURRENCYFORMATS_V1 as c on t.CURRENCYID=c.CURRENCYID
where t.FOLLOWUPID > 0 and t.FOLLOWUPID <= 7
order by t.FOLLOWUPID asc, t.PAYEENAME asc, t.TRANSDATE asc;