use Monday ;


	SELECT * FROM ustudio;

-- checking duplicates in title 

	SELECT ID FROM ustudio
	GROUP BY ID 
	HAVING COUNT(*) > 1;


-- total budget , box_office , net_profit collection from 2010-19

	SELECT SUM(budget) AS TOTAL_BUDGET FROM ustudio ;

	SELECT SUM(box_office) AS TOTAL_BUDGET FROM ustudio ;

	SELECT SUM(net_profit_loss) AS TOTAL_BUDGET FROM ustudio ;

--calculate percentage change in sum(net_profit_loss) as compared to overall budget

	SELECT (SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM ustudio;

--top budgeted movie and their information 

	SELECT top 3 *
	FROM ustudio
	ORDER BY budget DESC;

--TOP BOX_OFFICE MOVIES AND THEIR INFORMATION

	SELECT top 3 *
	FROM ustudio
	ORDER BY box_office DESC;

--TOP PROFIT MAKING MOVIES 

	SELECT top 3 * 
	from ustudio
	ORDER BY net_profit_loss DESC;

--TOP LOSS MAKING MOVIES 

	SELECT  TOP 3 *
	FROM ustudio
	WHERE net_profit_loss IS NOT NULL
	ORDER BY net_profit_loss ASC;

	SELECT * FROM ustudio;

--timing for movies 

	SELECT running_time , count(*) as count
	FROM ustudio
	GROUP BY Running_time
	ORDER BY count(*) DESC; --COUNT BASED ON EACH RUNNING_TIME


	SELECT running_time , avg(net_profit_loss) as avg_profit_loss
	FROM ustudio
	GROUP BY Running_time
	ORDER BY avg(net_profit_loss) DESC ; --AVG NET_PROFT_LOSS FOR EACH RUNNING_TIME
	
--split names of directors , producer , writter , cinemetography , editor , production_company 

	SELECT ID ,TRIM(VALUE) AS distributor
	INTO distributor
	FROM ustudio
	CROSS APPLY string_split (distributed_by , ',');



	SELECT * FROM director ;

	SELECT * FROM writer ;

	SELECT * FROM producer ;

	SELECT * FROM actor ;

	SELECT * FROM cinematographer ;

	SELECT * FROM editor ;

	SELECT * FROM production_company ;

	SELECT * FROM distributor ;


	SELECT * FROM ustudio;

--DROP column directors , producer , writter , cinemetography , editor , production_company from  THE TABLE USTUDIO

	ALTER TABLE ustudio
	DROP COLUMN directed_by;

-- for each movie calculate percentage change in profit/loss as compared to budget

	SELECT title , d.director , (SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM ustudio as u
	INNER JOIN director as d
	ON u.id = d.id
	GROUP BY title , director
	ORDER BY percentage_change DESC;



--FROM 2010-19 SELECT ALL THE MOVIES WHOSE  BUDGET IS LESS THEN TOTAL AVG BUDGET BUT MORE THEN TOTAL AVG NET_PROFIT/LOSS

	SELECT u.title , d.director
	FROM ustudio as u
	INNER JOIN director as d
	ON u.id = d.id
	WHERE u.budget < (SELECT  AVG(budget) FROM ustudio)
	AND u.box_office > (SELECT AVG(box_office) FROM ustudio)
	GROUP BY title , director;

--a)MOST frequent directors and their movies
--b) and see whether they have worked in the top profit making movies 

--a)
	SELECT d.director , count(*) AS movie_count
	FROM ustudio as u
	INNER JOIN director as d 
	on u.ID = d.ID
	GROUP BY d.director 
	ORDER BY count(*) desc;


	WITH cte1 as (
	SELECT d.director , count(*) as movie_count
	FROM ustudio as u
	INNER JOIN director as d 
	ON u.ID = d.ID
	GROUP BY d.director 
	)

	SELECT d.director , u.title , u.budget, u.box_office ,u.net_profit_loss
	FROM ustudio as u
	INNER JOIN director as d 
	ON u.ID = d.ID
	WHERE d.director IN 
	(
	 SELECT director FROM cte1 as c 
	 WHERE movie_count = (select max(movie_count) FROM cte1 )
	)
	ORDER BY d.director , u.title 

--b) 

	WITH cte1 as (
	SELECT d.director , count(*) as movie_count
	FROM ustudio as u
	INNER JOIN director as d 
	ON u.ID = d.ID
	GROUP BY d.director 
	)

	SELECT d.director , u.title , u.budget, u.box_office ,u.net_profit_loss
	FROM ustudio as u
	INNER JOIN director as d 
	ON u.ID = d.ID
	WHERE d.director IN 
	(
	 SELECT director FROM cte1 as c 
	 WHERE movie_count = (select max(movie_count) FROM cte1 )
	)
	AND u.title IN
	(
	SELECT TOP 3 title
    FROM ustudio
    ORDER BY net_profit_loss DESC
	)
	ORDER BY d.director , u.title 


-- a) most frquent writter and their movies
-- b) and see whether they have worked in the top profit making movies 

--a)
	SELECT w.writer , count(*) AS movie_count
	FROM ustudio as u
	INNER JOIN writer as w
	on u.ID = w.ID
	GROUP BY w.writer 
	ORDER BY count(*) desc;


	WITH cte1 as (
	SELECT w.writer , count(*) as movie_count
	FROM ustudio as u
	INNER JOIN writer as w
	ON u.ID = w.ID
	GROUP BY w.writer 
	)

	SELECT w.writer , u.title , u.budget, u.box_office ,u.net_profit_loss
	FROM ustudio as u
	INNER JOIN writer as w
	ON u.ID = w.ID
	WHERE w.writer IN 
	(
	 SELECT writer FROM cte1 as c 
	 WHERE movie_count = (select max(movie_count) FROM cte1 )
	)
	ORDER BY w.writer , u.title 

--b)

	WITH cte1 as (
	SELECT w.writer , count(*) as movie_count
	FROM ustudio as u
	INNER JOIN writer as w
	ON u.ID = w.ID
	GROUP BY w.writer 
	)

	SELECT w.writer , u.title , u.budget, u.box_office ,u.net_profit_loss
	FROM ustudio as u
	INNER JOIN writer as w
	ON u.ID = w.ID
	WHERE w.writer IN 
	(
	 SELECT writer FROM cte1 as c 
	 WHERE movie_count = (select max(movie_count) FROM cte1 )
	)
	AND u.title IN
	(
	SELECT TOP 3 title
    FROM ustudio
    ORDER BY net_profit_loss DESC
	)
	ORDER BY w.writer , u.title --we have one frequent writer who has worked in top profit making movies


--a) most frequent actor

	SELECT a.actor , count(*) AS movie_count
	FROM ustudio as u
	INNER JOIN actor as a 
	ON u.ID = a.ID
	GROUP BY a.actor
	ORDER BY count(*)  desc

-- For Actors  Average Box budget,average net_profit_loss,average_box_office and percentage change in profit/loss relative to the budget

	SELECT a.actor,  AVG(u.budget) AS average_budget,
	AVG(net_profit_loss) AS average_net_profit_loss , 
	AVG(u.box_office) AS average_box_office,
	(SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM actor as a
	JOIN ustudio u ON a.id = u.id
	GROUP BY  a.actor
	ORDER BY average_budget DESC ;

--most frequent distributor

	SELECT d.distributor , count(*) as movie_count
	FROM distributor as d
	INNER JOIN ustudio as u
	ON d.ID = u.ID
	GROUP BY d.distributor
	ORDER BY movie_count desc ;

--top distributor in terms of total profit

	SELECT d.distributor , sum(net_profit_loss) as net_profit
	FROM distributor as d
	INNER JOIN ustudio as u
	ON d.ID = u.ID
	GROUP BY d.distributor
	ORDER BY  net_profit desc ;

--which distributor has made losses over the years 

	SELECT  top 7 d.distributor , sum(net_profit_loss) as net_loss
	FROM distributor as d
	INNER JOIN ustudio as u
	ON d.ID = u.ID
	GROUP BY d.distributor
	HAVING sum(net_profit_loss) IS NOT NULL
	ORDER BY  net_loss ;

--frequent production_comapnies

	SELECT pd.production_company , count(*) as movie_count
	FROM production_company as pd
	INNER JOIN ustudio as u
	ON pd.ID = u.ID
	GROUP BY pd.production_company
	ORDER BY movie_count desc ;

--top production_company in terms of profits

	SELECT pd.production_company , sum(net_profit_loss) as net_income
	FROM production_company as pd
	INNER JOIN ustudio as u
	ON pd.ID = u.ID
	GROUP BY pd.production_company
	ORDER BY net_income desc ;

--production companies that have incurred losses

	SELECT top 32 pd.production_company , sum(net_profit_loss) as net_loss
	FROM production_company as pd
	INNER JOIN ustudio as u
	ON pd.ID = u.ID
	GROUP BY pd.production_company
	HAVING sum(net_profit_loss) IS NOT NULL
	ORDER BY net_loss ;

---- For each production_companies  Average Box budget,average net_profit_loss,average_box_office and percentage change in profit/loss relative to the budget

	SELECT pd.production_company , avg(budget) as avg_budget,
	AVG(net_profit_loss) AS average_net_profit_loss , 
	AVG(u.box_office) AS average_box_office,
	(SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM production_company as pd
	INNER JOIN ustudio as u
	ON pd.ID = u.ID
	GROUP BY pd.production_company
	ORDER BY avg_budget desc ;

-- count of loss making  movies of  each production company

	SELECT pd.production_company, COUNT (*) AS num_movies
	FROM production_company AS pd
	INNER JOIN ustudio AS u ON pd.ID = u.ID
	GROUP BY pd.production_company 
	HAVING SUM(u.net_profit_loss) < 0
	AND SUM(u.net_profit_loss) IS NOT NULL
	ORDER BY num_movies desc;


--number of movies made by each cinematographer

	SELECT c.cinematographer , count(*) as movie_count
	FROM ustudio AS u
	INNER JOIN cinematographer as c
	ON u.ID = c.ID
	GROUP BY cinematographer
	ORDER BY movie_count desc;

--HIGHEST GROSSING FILM OF EACH CINEMATOGRAPHER 

	WITH MaxBoxOffice AS 
	(
		SELECT c.id AS cinematographer_id, MAX(u.box_office) AS max_box_office
		FROM cinematographer c
		JOIN ustudio u ON c.id = u.id
		GROUP BY c.id
	)
	SELECT c.cinematographer, u.title, u.box_office
	FROM cinematographer c
	JOIN ustudio u ON c.id = u.id
	JOIN MaxBoxOffice as mbo ON c.id = mbo.cinematographer_id AND u.box_office = mbo.max_box_office
	ORDER BY box_office desc ;

--FOR Cinemetographer Average Box budget,average net_profit_loss,average_box_office and percentage change in profit/loss relative to the budget

	SELECT  c.cinematographer,  AVG(u.budget) AS average_budget,
	AVG(net_profit_loss) AS average_net_profit_loss , 
	AVG(u.box_office) AS average_box_office,
	(SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM cinematographer c
	JOIN ustudio u ON c.id = u.id
	GROUP BY c.cinematographer
	ORDER BY average_budget DESC ;


--number of movies made by each editor

	SELECT e.editor , count(*) as movie_count
	FROM ustudio AS u
	INNER JOIN editor as e
	ON u.ID = e.ID
	GROUP BY editor
	ORDER BY movie_count desc;

-- For Editor Average Box budget,average net_profit_loss,average_box_office and percentage change in profit/loss relative to the budget

	SELECT   e.editor,  AVG(u.budget) AS average_budget,
	AVG(net_profit_loss) AS average_net_profit_loss , 
	AVG(u.box_office) AS average_box_office,
	(SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM editor e
	JOIN ustudio u ON e.id = u.id
	GROUP BY  e.editor
	ORDER BY average_budget DESC ;



	SELECT   e.editor,  AVG(u.budget) AS average_budget,
	AVG(net_profit_loss) AS average_net_profit_loss , 
	AVG(u.box_office) AS average_box_office,
	(SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 AS percentage_change
	FROM editor e
	JOIN ustudio u ON e.id = u.id
	GROUP BY  e.editor
	HAVING AVG(u.budget) IS NOT NULL
	and AVG(net_profit_loss) is not null
	and AVG(u.box_office) is not null
	and (SUM(net_profit_loss) - SUM(budget)) / SUM(budget) * 100 is not null
	ORDER BY average_budget DESC ;