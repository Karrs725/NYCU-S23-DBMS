SELECT list.Team, list.Hitter, list.avg_hit_rate, list.tol_hit, list.win_rate

FROM

(SELECT Name AS Hitter, ROUND(AVG(H/AB), 4) AS avg_hit_rate, SUM(AB) AS tol_hit, hitters.Team, win_rate

FROM

((SELECT allgame.Team, wingame.WG/allgame.AG AS win_rate

FROM

(SELECT win.Team, SUM(win.CG) AS WG

FROM

(SELECT COUNT(Game) AS CG, away AS Team

FROM games

WHERE YEAR(Date) = '2021' AND away_score > home_score

GROUP BY away

UNION ALL

SELECT COUNT(Game) AS CG, home AS Team

FROM games

WHERE YEAR(Date) = '2021' AND away_score < home_score

GROUP BY home) AS win

GROUP BY win.Team) AS wingame

JOIN

(SELECT numall.Team,  COUNT(numall.Game) AS AG

FROM

(SELECT Game, away AS Team

FROM games

WHERE YEAR(Date) = '2021'

UNION ALL

SELECT Game, home AS Team

FROM games

WHERE YEAR(Date) = '2021') AS numall

GROUP BY numall.Team) AS allgame

ON wingame.Team = allgame.Team

ORDER BY win_rate DESC

LIMIT 5) AS winteam

JOIN

((SELECT Game

FROM games

WHERE YEAR(Date) = '2021') AS game

JOIN hitters ON hitters.Game = game.Game

JOIN players ON hitters.Hitter_Id = players.Id)

ON winteam.Team = hitters.Team)

WHERE AB > 0

GROUP BY Hitter_Id, hitters.Team

HAVING SUM(AB) > 100

ORDER BY avg_hit_rate DESC) AS list



WHERE list.avg_hit_rate IN

(SELECT MAX(l.avg_hit_rate)

FROM

(SELECT Name AS Hitter, ROUND(AVG(H/AB), 4) AS avg_hit_rate, SUM(AB) AS tol_hit, hitters.Team, win_rate

FROM

((SELECT allgame.Team, wingame.WG/allgame.AG AS win_rate

FROM

(SELECT win.Team, SUM(win.CG) AS WG

FROM

(SELECT COUNT(Game) AS CG, away AS Team

FROM games

WHERE YEAR(Date) = '2021' AND away_score > home_score

GROUP BY away

UNION ALL

SELECT COUNT(Game) AS CG, home AS Team

FROM games

WHERE YEAR(Date) = '2021' AND away_score < home_score

GROUP BY home) AS win

GROUP BY win.Team) AS wingame

JOIN

(SELECT numall.Team,  COUNT(numall.Game) AS AG

FROM

(SELECT Game, away AS Team

FROM games

WHERE YEAR(Date) = '2021'

UNION ALL

SELECT Game, home AS Team

FROM games

WHERE YEAR(Date) = '2021') AS numall

GROUP BY numall.Team) AS allgame

ON wingame.Team = allgame.Team

ORDER BY win_rate DESC

LIMIT 5) AS winteam

JOIN

((SELECT Game

FROM games

WHERE YEAR(Date) = '2021') AS game

JOIN hitters ON hitters.Game = game.Game

JOIN players ON hitters.Hitter_Id = players.Id)

ON winteam.Team = hitters.Team)

WHERE AB > 0

GROUP BY Hitter_Id, hitters.Team

HAVING SUM(AB) > 100

ORDER BY avg_hit_rate DESC) AS l

GROUP BY l.Team

)

ORDER BY list.win_rate DESC;

