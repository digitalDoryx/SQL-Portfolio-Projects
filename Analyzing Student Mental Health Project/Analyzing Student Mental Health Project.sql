/**									ANALYZING STUDENT MENTAL HEALTH PROJECT
												By Digitaldoryx
dataset: https://mdpi-res.com/d_attachment/data/data-04-00124/article_deploy/data-04-00124-s001.zip?version=1566351002
keywords: AVG, Alias, Cast, Count, Group by, Case, Where, Float, Stdev
*/
--1. Extract all the data on the table
SELECT *
	FROM [Mental Health].[dbo].[students_mental_health];

--2. Count of Gender
SELECT Gender, COUNT(*) Inter_Gend_Count
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'Inter'
	GROUP BY Gender;

--3. Select all the average aculturation according to the duration of their stay
SELECT [stay in japan], AVG([Acculturation Perceived Discrimination]) A_P_D, AVG([Acculturation Homeskickness]) A_H, AVG([Acculturation Perceived Hate]) A_P_H,
AVG([Acculturation Fear]) A_F, AVG([Acculturation Cultural Shock]) A_C_S, AVG([Acculturation Guilt]) A_G
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'Inter'
	GROUP BY [stay in japan];

--4. Likelihood to seek help from various sources
SELECT [stay in japan],
	COUNT(
		CASE 
			WHEN [Will you seek help from your partner] = 'Yes' THEN 1 
		END ) AS Count_partner,
	COUNT(
		CASE 
			WHEN [Will you seek help from your friends] = 'Yes' THEN 1 
		END ) AS Count_friends,
	COUNT(
		CASE 
			WHEN [Will you seek help from your parents] = 'Yes' THEN 1 
		END ) AS Count_parents,
	COUNT(
		CASE 
			WHEN [Will you seek help from your relatives] = 'Yes' THEN 1 
		END ) AS Count_relatives,
	COUNT(
		CASE 
			WHEN [Will you seek help from your mental health professional] = 'Yes' THEN 1 
		END ) AS Count_professional,
	COUNT(
		CASE 
			WHEN [Will you seek help from helpline] = 'Yes' THEN 1 
		END ) AS Count_helpline,
	COUNT(
		CASE 
			WHEN [Will you seek help from doctor] = 'Yes' THEN 1 
		END ) AS Count_doctor,
	COUNT(
		CASE 
			WHEN [Will you seek help from religious priest ] = 'Yes' THEN 1 
		END ) AS Count_priest,
	COUNT(
		CASE 
			WHEN [I will solve it alone] = 'Yes' THEN 1 
		END ) AS Count_alone,
	COUNT(
		CASE 
			WHEN [Will you seek help from internet] = 'Yes' THEN 1 
		END ) AS Count_internet
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter' AND Depressed ='Yes' or Suicide = 'yes'
	GROUP BY [stay in japan];

--5. International students proficiency in Japanese
SELECT [Japanese Proficiency ], COUNT(*) AS Inter_Japan_Profi
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'Inter'
	GROUP BY [Japanese Proficiency ]
	ORDER BY [Japanese Proficiency ] DESC;

--6 Where are this internation students from?
SELECT Region_Country, Count(*) As Count_Inter_Region
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'Inter'
	GROUP BY Region_Country
	ORDER BY Count_Inter_Region DESC;
	
--7. Aggregate Data by Length of Stay
/** aggregate the data based on the length
of stay in Japan to calculate average diagnostic scores for depression and suicidal tendencies:*/
SELECT [stay in japan],
	COUNT(
		CASE 
			WHEN Depressed = 'Yes' THEN 1  
		END ) AS Count_Depressed,
    COUNT (
		CASE 
			WHEN Suicide = 'Yes' THEN 1
		END) AS Count_Suicide
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter'
	GROUP BY [stay in japan];

--8. calculate correlations between social connectedness and depression 
/**indicates a moderate negative correlation between social connectedness and depression
This means there is a tendency that as social connectedness increases, depression tends to decrease, 
and vice versa, but the relationship is not extremely strong.
this suggests that there is some relationship between social connectedness and depression 
*/
SELECT SUM(([SOCIAL CONNECTEDNESS] - Social_Connectedness_Mean) * (Depressed_Flag - Depressed_Flag_Mean)) 
        / (COUNT(*) * STDEV([SOCIAL CONNECTEDNESS]) * STDEV(Depressed_Flag)) AS Correlation_Depression
FROM (
    SELECT [SOCIAL CONNECTEDNESS],
        CASE 
			WHEN Depressed = 'Yes' THEN 1 
			ELSE 0 
		END AS Depressed_Flag,
        AVG([SOCIAL CONNECTEDNESS]) OVER () AS Social_Connectedness_Mean,
        AVG(CASE 
			WHEN Depressed = 'Yes' THEN 1 
			ELSE 0 
		END) OVER () AS Depressed_Flag_Mean
    FROM 
        [Mental Health].[dbo].[students_mental_health]) AS Subquery;
		
-- 9. Depression Rate: The percentage of students who report feeling depressed
-- divided by the total number of students surveyed.
/**The proportion of students experiencing depression is significant, 
representing more than a third of the surveyed population */
SELECT 
    CAST(COUNT(CASE 
		WHEN Depressed = 'Yes' THEN 1 
	END) AS FLOAT) / COUNT(*) * 100 AS Depression_Rate
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter';

--10. **Stress Levels and Mental Health,Thoughts of Depression:**
SELECT AVG([Thoughts of Depression]) AS Average_Diagnostic_Score
FROM [Mental Health].[dbo].[students_mental_health]
WHERE international_or_domestic_student = 'Inter';

--11. **Academic Performance and Mental Health:**
SELECT AVG([Thoughts of Depression]) AS Average_Diagnostic_Score, [Academic_level ]
FROM [Mental Health].[dbo].[students_mental_health]
where international_or_domestic_student = 'inter'
GROUP BY [Academic_level ];

--12. Suicidal Tendencies Rate: The percentage of students who report having suicidal 
--tendencies divided by the total number of students surveyed.
SELECT CAST(COUNT
	(CASE 
		WHEN Suicide = 'Yes' THEN 1 
	END) AS FLOAT) / COUNT(*) * 100 AS Suicidal_Tendencies_Rate
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter';

-- 13. Average Depression Severity Score: The average severity score reported by students experiencing depression. 
/** on average, the severity of depressive symptoms reported by the students is moderate to mild.
A score of 2 could imply that students are experiencing symptoms that are noticeable and interfere with their daily 
functioning but may not be severe enough to significantly impair their ability to function.
*/
SELECT 
    AVG(CASE 
			WHEN Depressed = 'Yes' THEN 
				CASE 
					WHEN [Depression Severity] = 'Min' THEN 1
					WHEN [Depression Severity] = 'Mild' THEN 2
					WHEN [Depression Severity] = 'Mod' THEN 3
					WHEN [Depression Severity] = 'Mod_Sev' THEN 4
					WHEN [Depression Severity] = 'Sev' THEN 5
				END
			ELSE NULL 
		END) AS ASvg_Depression_Severity_Score
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter';

-- 14. Social Connectedness Score
/** This score suggests a moderate to high level of social connectedness among the student population.
A score of 37 implies that, on average, students feel connected to others
and have a sense of belonging within their social environment.
Higher scores in social connectedness indicate stronger relationships,
social support, and a greater sense of community.
*/
SELECT 
    AVG([Social Connectedness]) AS Avg_Social_Connectedness_Score
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter' AND Depressed = 'Yes' OR Suicide = 'Yes';

--15. Acculturation Score
/**
This score indicates a relatively high level of acculturation among the student population.
Acculturation refers to the process of adapting to 
and integrating into a new culture, and a score of 75 suggests
*/
SELECT 
	AVG([Total_Acculturation]) AS Avg_Acculturation_Score
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter';

-- 16. Average Age of Onset of Depressive Symptoms
SELECT 
    AVG(CASE 
			WHEN Depressed = 'Yes' THEN Age 
		END) AS Avg_Age_Onset_Depressive_Symptoms
	FROM [Mental Health].[dbo].[students_mental_health]
	WHERE international_or_domestic_student = 'inter';

--17. **Trend Analysis Over Time:**
SELECT [stay in japan] , AVG([Thoughts of Depression]) AS Average_Diagnostic_Score
FROM [Mental Health].[dbo].[students_mental_health]
where international_or_domestic_student = 'inter'
GROUP BY [stay in japan];

--18. **Prevalence of Depression Types:**
SELECT [Depression Type], COUNT(*) AS Count
FROM [Mental Health].[dbo].[students_mental_health]
where international_or_domestic_student = 'inter'
GROUP BY [Depression Type];

--19. **Average Diagnostic Score:**
SELECT gender, avg([Thoughts of Depression]) as Avg_Diagnostic_Score
FROM [Mental Health].[dbo].[students_mental_health]
group by gender;

--20. **Distribution of Diagnostic Scores:**
SELECT [Depression Type], COUNT(*) AS Depression_count, avg([Thoughts of Depression])
FROM [Mental Health].[dbo].[students_mental_health]
where international_or_domestic_student = 'inter'
GROUP BY [Depression Type];
