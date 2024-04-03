/**				ANALYZING STUDENT SAT SCORE IN VARIOUS SCHOOLS
							By Digitaldoryx
	Keywords Used: Count, Max, Min, Subquery, Union All
*/

SELECT *
	FROM [Schools Score].[dbo].[schools_score];

--1. How many schools fail to report information
SELECT COUNT(*) AS schools_missing_info
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_math IS NULL OR 
	average_reading IS NULL OR 
	average_writing IS NULL OR 
	percent_tested IS NULL;

--2. Which (or how many) schools are best/worst in each of the three components of the SAT—reading, math, and writing
-- a. Best in each component
SELECT school_name, 'Math' AS component, average_math AS Best_Score
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_math = (SELECT MAX(average_math) 
	FROM [Schools Score].[dbo].[schools_score])
	UNION ALL
SELECT school_name, 'Reading' AS component, average_reading AS Best_Score
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_reading = (SELECT MAX(average_reading) 
	FROM [Schools Score].[dbo].[schools_score])
	UNION ALL
SELECT school_name, 'Writing' AS component, average_writing AS Best_Score
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_writing = (SELECT MAX(average_writing) 
	FROM [Schools Score].[dbo].[schools_score]);

-- b. Worst in each component
SELECT school_name, 'Math' AS component, average_math AS Worst_Score
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_math = (SELECT MIN(average_math) 
	FROM [Schools Score].[dbo].[schools_score] 
	WHERE average_math IS NOT NULL)
	UNION ALL
SELECT school_name, 'Reading' AS component, average_reading AS Worst_Score
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_reading = (SELECT MIN(average_reading) 
	FROM [Schools Score].[dbo].[schools_score] 
	WHERE average_reading IS NOT NULL)
	UNION ALL
SELECT school_name, 'Writing' AS component, average_writing AS Worst_Score
	FROM [Schools Score].[dbo].[schools_score]
	WHERE average_writing = (SELECT MIN(average_writing) 
	FROM [Schools Score].[dbo].[schools_score] 
	WHERE average_writing IS NOT NULL);

--3. The best/worst scores for different SAT components:**
SELECT 
    MAX(average_math) AS best_math_score,
    MAX(average_reading) AS best_reading_score,
    MAX(average_writing) AS best_writing_score,
    MIN(average_math) AS worst_math_score,
    MIN(average_reading) AS worst_reading_score,
    MIN(average_writing) AS worst_writing_score
	FROM [Schools Score].[dbo].[schools_score];

--4. The top 10 schools by average total SAT scores
SELECT TOP 10 school_name,
    (average_math + average_reading + average_writing) AS Total_Score
	FROM [Schools Score].[dbo].[schools_score]
	ORDER BY total_score DESC;

--5. How the test performance varies by borough
SELECT borough,
    AVG(average_math) AS avg_math_score,
    AVG(average_reading) AS avg_reading_score,
    AVG(average_writing) AS avg_writing_score
FROM [Schools Score].[dbo].[schools_score]
GROUP BY borough;

--6. The top 5 schools by average SAT scores across all three components 
SELECT TOP 5
    school_name,
    average_math,
    average_reading,
    average_writing,
    (average_math + average_reading + average_writing) AS Total_Score
	FROM [Schools Score].[dbo].[schools_score]
	ORDER BY total_score DESC;