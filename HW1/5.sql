SELECT ans.Team, ans.The_month, DATE_FORMAT(MIN(ans.time_interval), '%H:%i') AS time_interval

FROM

(SELECT Time.Team AS Team,

DATE_FORMAT(Time.D, '%Y-%m') AS The_month,

TIMEDIFF(Time.D, LAG(Time.D, 1) OVER (PARTITION BY Time.Team ORDER BY Time.D)) AS time_interval

FROM

(SELECT G.away AS Team, G.Date AS D

FROM games G

WHERE DATE_FORMAT(Date, '%Y-%m') = (SELECT T.date FROM (SELECT DATE_FORMAT(Date, '%Y-%m') AS date, COUNT(Game) AS num FROM games GROUP BY DATE_FORMAT(Date, '%Y-%m')) AS T WHERE T.num = (SELECT MAX(T.num) FROM (SELECT DATE_FORMAT(Date, '%Y-%m') AS date, COUNT(Game) AS num FROM games GROUP BY DATE_FORMAT(Date, '%Y-%m')) AS T))

UNION ALL

SELECT G.home AS Team, G.Date AS D

FROM games G

WHERE DATE_FORMAT(Date, '%Y-%m') = (SELECT T.date FROM (SELECT DATE_FORMAT(Date, '%Y-%m') AS date, COUNT(Game) AS num FROM games GROUP BY DATE_FORMAT(Date, '%Y-%m')) AS T WHERE T.num = (SELECT MAX(T.num) FROM (SELECT DATE_FORMAT(Date, '%Y-%m') AS date, COUNT(Game) AS num FROM games GROUP BY DATE_FORMAT(Date, '%Y-%m')) AS T))

ORDER BY Team ASC, D ASC) AS Time) AS ans

GROUP BY ans.Team, ans.The_month;