SELECT 'Changed' AS Pitcher, cans0.cnt, cans0.`2020_avg_K/9`, cans1.`2021_avg_K/9`, cans0.`2020_PC-ST`, cans1.`2021_PC-ST`

FROM	(SELECT COUNT(x.Pitcher_Id) AS cnt, ROUND(AVG(x.K), 4) AS `2020_avg_K/9`, CONCAT(ROUND(AVG(x.PC), 4), '-', ROUND(AVG(x.ST), 4)) AS `2020_PC-ST`

	FROM	(SELECT PID.Pitcher_Id, AVG(9*PR0.K/PR0.IP) AS K, AVG(PR0.PC) AS PC, AVG(PR0.ST) AS ST

		FROM	(SELECT Pitcher_Id, IP, K, substring(PC_ST, 1, instr(PC_ST, '-')-1) as PC, substring(PC_ST, instr(PC_ST, '-')+1) as ST

			FROM pitchers

			WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)) AS PR0

			JOIN

			(SELECT P.Pitcher_Id

			FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

				GROUP BY Pitcher_Id, Team

				UNION ALL

				SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

				GROUP BY Pitcher_Id, Team) AS P

			WHERE P.Pitcher_Id

			IN	(SELECT a.Pitcher_Id

				FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS a

					JOIN

					(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS b

					ON a.Pitcher_Id = b.Pitcher_Id

				GROUP BY a.Pitcher_Id)

			GROUP BY P.Pitcher_Id

			HAVING SUM(P.IPs) > 50 AND COUNT(DISTINCT P.Team) > 1

			ORDER BY P.Pitcher_Id ASC) AS PID

			ON PID.Pitcher_Id = PR0.Pitcher_Id

		WHERE IP > 0

		GROUP BY PID.Pitcher_Id

		ORDER BY PID.Pitcher_Id ASC) AS x) AS cans0

	JOIN

	(SELECT COUNT(y.Pitcher_Id) AS cnt, ROUND(AVG(y.K), 4) AS `2021_avg_K/9`, CONCAT(ROUND(AVG(y.PC), 4), '-', ROUND(AVG(y.ST), 4)) AS `2021_PC-ST`

	FROM	(SELECT PID.Pitcher_Id, AVG(9*PR0.K/PR0.IP) AS K, AVG(PR0.PC) AS PC, AVG(PR0.ST) AS ST

		FROM	(SELECT Pitcher_Id, IP, K, substring(PC_ST, 1, instr(PC_ST, '-')-1) as PC, substring(PC_ST, instr(PC_ST, '-')+1) as ST

			FROM pitchers

			WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)) AS PR0

			JOIN

			(SELECT P.Pitcher_Id

			FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

				GROUP BY Pitcher_Id, Team

				UNION ALL

				SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

				GROUP BY Pitcher_Id, Team) AS P

			WHERE P.Pitcher_Id

			IN	(SELECT a.Pitcher_Id

				FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS a

					JOIN

					(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS b

					ON a.Pitcher_Id = b.Pitcher_Id

				GROUP BY a.Pitcher_Id)

			GROUP BY P.Pitcher_Id

			HAVING SUM(P.IPs) > 50 AND COUNT(DISTINCT P.Team) > 1

			ORDER BY P.Pitcher_Id ASC) AS PID

			ON PID.Pitcher_Id = PR0.Pitcher_Id

		WHERE IP > 0

		GROUP BY PID.Pitcher_Id

		ORDER BY PID.Pitcher_Id ASC) AS y) AS cans1

	ON cans0.cnt = cans1.cnt



UNION



SELECT 'Unchanged' AS Pitcher, uans0.cnt, uans0.`2020_avg_K/9`, uans1.`2021_avg_K/9`, uans0.`2020_PC-ST`, uans1.`2021_PC-ST`

FROM	(SELECT COUNT(x.Pitcher_Id) AS cnt, ROUND(AVG(x.K), 4) AS `2020_avg_K/9`, CONCAT(ROUND(AVG(x.PC), 4), '-', ROUND(AVG(x.ST), 4)) AS `2020_PC-ST`

	FROM	(SELECT PID.Pitcher_Id, AVG(9*PR0.K/PR0.IP) AS K, AVG(PR0.PC) AS PC, AVG(PR0.ST) AS ST

		FROM	(SELECT Pitcher_Id, IP, K, substring(PC_ST, 1, instr(PC_ST, '-')-1) as PC, substring(PC_ST, instr(PC_ST, '-')+1) as ST

			FROM pitchers

			WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)) AS PR0

			JOIN

			(SELECT P.Pitcher_Id

			FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

				GROUP BY Pitcher_Id, Team

				UNION ALL

				SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

				GROUP BY Pitcher_Id, Team) AS P

			WHERE P.Pitcher_Id

			IN	(SELECT a.Pitcher_Id

				FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS a

					JOIN

					(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS b

					ON a.Pitcher_Id = b.Pitcher_Id

				GROUP BY a.Pitcher_Id)

			GROUP BY P.Pitcher_Id

			HAVING SUM(P.IPs) > 50 AND COUNT(DISTINCT P.Team) = 1

			ORDER BY P.Pitcher_Id ASC) AS PID

			ON PID.Pitcher_Id = PR0.Pitcher_Id

		WHERE IP > 0

		GROUP BY PID.Pitcher_Id

		ORDER BY PID.Pitcher_Id ASC) AS x) AS uans0

	JOIN

	(SELECT COUNT(y.Pitcher_Id) AS cnt, ROUND(AVG(y.K), 4) AS `2021_avg_K/9`, CONCAT(ROUND(AVG(y.PC), 4), '-', ROUND(AVG(y.ST), 4)) AS `2021_PC-ST`

	FROM	(SELECT PID.Pitcher_Id, AVG(9*PR0.K/PR0.IP) AS K, AVG(PR0.PC) AS PC, AVG(PR0.ST) AS ST

		FROM	(SELECT Pitcher_Id, IP, K, substring(PC_ST, 1, instr(PC_ST, '-')-1) as PC, substring(PC_ST, instr(PC_ST, '-')+1) as ST

			FROM pitchers

			WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)) AS PR0

			JOIN

			(SELECT P.Pitcher_Id

			FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

				GROUP BY Pitcher_Id, Team

				UNION ALL

				SELECT Pitcher_Id, SUM(IP) AS IPs, Team

				FROM pitchers

				WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

				GROUP BY Pitcher_Id, Team) AS P

			WHERE P.Pitcher_Id

			IN	(SELECT a.Pitcher_Id

				FROM	(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2020)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS a

					JOIN

					(SELECT Pitcher_Id, SUM(IP) AS IPs, Team

					FROM pitchers

					WHERE Game IN (SELECT Game FROM games WHERE YEAR(Date) = 2021)

					GROUP BY Pitcher_Id, Team

					HAVING IPs > 0) AS b

					ON a.Pitcher_Id = b.Pitcher_Id

				GROUP BY a.Pitcher_Id)

			GROUP BY P.Pitcher_Id

			HAVING SUM(P.IPs) > 50 AND COUNT(DISTINCT P.Team) = 1

			ORDER BY P.Pitcher_Id ASC) AS PID

			ON PID.Pitcher_Id = PR0.Pitcher_Id

		WHERE IP > 0

		GROUP BY PID.Pitcher_Id

		ORDER BY PID.Pitcher_Id ASC) AS y) AS uans1

	ON uans0.cnt = uans1.cnt;