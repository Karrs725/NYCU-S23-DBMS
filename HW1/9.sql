SELECT ans.hit_rate_diff, ans.win_rate

FROM	(SELECT (SUM(pos.num) OVER (ORDER BY ab.hit_rate_diff DESC)/SUM(ab.num) OVER (ORDER BY ab.hit_rate_diff DESC)) AS win_rate, ab.hit_rate_diff

	FROM	(SELECT SUM(n.num) AS num, ABS(n.hit_rate_diff) AS hit_rate_diff

		FROM	(SELECT COUNT(hit_rate_diff) AS num, hit_rate_diff

			FROM	(SELECT TRUNCATE(win.hit_rate-lose.hit_rate, 2) AS hit_rate_diff

				FROM	(SELECT G.Game, hitters.Team, AVG(hitters.H/hitters.AB) AS hit_rate

					FROM	(SELECT Game, away AS Team

						FROM games

						WHERE YEAR(Date) = '2021' AND away_score > home_score

						UNION ALL

						SELECT Game, home AS Team

						FROM games

						WHERE YEAR(Date) = '2021' AND away_score < home_score) AS G

						JOIN hitters ON G.Game = hitters.Game

					WHERE G.Team = hitters.Team

					GROUP BY hitters.Game, hitters.Team) AS win

					JOIN

					(SELECT G.Game, hitters.Team, AVG(hitters.H/hitters.AB) AS hit_rate

					FROM	(SELECT Game, away AS Team

						FROM games

						WHERE YEAR(Date) = '2021' AND away_score > home_score

						UNION ALL

						SELECT Game, home AS Team

						FROM games

						WHERE YEAR(Date) = '2021' AND away_score < home_score) AS G

						JOIN hitters ON G.Game = hitters.Game

					WHERE G.Team != hitters.Team

					GROUP BY hitters.Game, hitters.Team) AS lose

					ON win.Game = lose.Game

				ORDER BY hit_rate_diff DESC) AS hrd

			GROUP BY hit_rate_diff

			ORDER BY hit_rate_diff DESC) AS n

		GROUP BY ABS(n.hit_rate_diff)) AS ab

		LEFT JOIN

		(SELECT COUNT(hit_rate_diff) AS num, hit_rate_diff

		FROM	(SELECT TRUNCATE(win.hit_rate-lose.hit_rate, 2) AS hit_rate_diff

			FROM	(SELECT G.Game, hitters.Team, AVG(hitters.H/hitters.AB) AS hit_rate

				FROM	(SELECT Game, away AS Team

					FROM games

					WHERE YEAR(Date) = '2021' AND away_score > home_score

					UNION ALL

					SELECT Game, home AS Team

					FROM games

					WHERE YEAR(Date) = '2021' AND away_score < home_score) AS G

					JOIN hitters ON G.Game = hitters.Game

				WHERE G.Team = hitters.Team

				GROUP BY hitters.Game, hitters.Team) AS win

				JOIN

				(SELECT G.Game, hitters.Team, AVG(hitters.H/hitters.AB) AS hit_rate

				FROM	(SELECT Game, away AS Team

					FROM games

					WHERE YEAR(Date) = '2021' AND away_score > home_score

					UNION ALL

					SELECT Game, home AS Team

					FROM games

					WHERE YEAR(Date) = '2021' AND away_score < home_score) AS G

					JOIN hitters ON G.Game = hitters.Game

				WHERE G.Team != hitters.Team

				GROUP BY hitters.Game, hitters.Team) AS lose

				ON win.Game = lose.Game

			ORDER BY hit_rate_diff DESC) AS hrd

		GROUP BY hit_rate_diff

		ORDER BY hit_rate_diff DESC) AS pos

		ON ab.hit_rate_diff = pos.hit_rate_diff

	ORDER BY hit_rate_diff ASC) AS ans

WHERE ans.win_rate > 0.95

LIMIT 1;