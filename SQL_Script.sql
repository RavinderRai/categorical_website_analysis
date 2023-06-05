-- this dataset has information about keyword analysis of websites and other related info
-- the goal here is to do some queries to explore the data, and some of the resulting tables will be used in Tableau after
select *
from WebsiteAnalysis..website_data


-- just to see how many categories there are: 408
SELECT COUNT(DISTINCT(category)) AS number_of_categories
from WebsiteAnalysis..website_data

-- counting categories but not including subcategories - there are 15, so we can look at them more closely
SELECT COUNT(DISTINCT LEFT(category, CHARINDEX('/', category + '/') - 1)) AS distinct_categories
FROM WebsiteAnalysis..website_data

-- Listing them here
SELECT DISTINCT LEFT(category, CHARINDEX('/', category + '/') - 1) AS distinct_categories
FROM WebsiteAnalysis..website_data

-- getting some metrics for these, for visualization in Tableau
SELECT DISTINCT LEFT(category, CHARINDEX('/', category + '/') - 1) AS distinct_categories, This_site_rank_in_global_internet_engagement, keyword_opportunities_breakdown_buyer_keywords, keyword_opportunities_breakdown_easy_to_rank_keywords
FROM WebsiteAnalysis..website_data
WHERE This_site_rank_in_global_internet_engagement IS NOT NULL
AND keyword_opportunities_breakdown_buyer_keywords IS NOT NULL
AND keyword_opportunities_breakdown_easy_to_rank_keywords IS NOT NULL



-- Seeing what categories have the most number of keywords with optimizatin opportunities
SELECT TOP 50 category, AVG(keyword_opportunities_breakdown_optimization_opportunities) AS avg_optimization_opporunities
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_optimization_opporunities DESC


-- Seeing what categories have the least number of keywords with optimizatin opportunities
SELECT TOP 50 category, AVG(keyword_opportunities_breakdown_optimization_opportunities) AS avg_optimization_opporunities
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_optimization_opporunities


-- Seeing the max number of keywords of each category that a website is not getting traffic from but competitors are
SELECT TOP 50 category, MAX(keyword_opportunities_breakdown_keyword_gaps) AS max_keyword_gaps
FROM WebsiteAnalysis..website_data
GROUP BY category



-- Seeing the least number of keywords of each category that a website is not getting traffic from but competitors are
SELECT TOP 50 category, MIN(keyword_opportunities_breakdown_keyword_gaps) AS min_keyword_gaps
FROM WebsiteAnalysis..website_data
GROUP BY category


-- seeing the average number of keywords per category that a website in this category could easily rank for, so basically potential oppotunities
SELECT TOP 25 category, AVG(keyword_opportunities_breakdown_easy_to_rank_keywords) AS num_of_potential_opportunities
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY num_of_potential_opportunities DESC


-- seeing the most number of potential oppotunities to have keywords associated with purchases
SELECT TOP 25 category, AVG(keyword_opportunities_breakdown_buyer_keywords) AS num_of_potential_opportunities_for_purchases
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY num_of_potential_opportunities_for_purchases DESC


-- seeing the least number of potential oppotunities to have keywords associated with purchases
SELECT TOP 25 category, AVG(keyword_opportunities_breakdown_buyer_keywords) AS num_of_potential_opportunities_for_purchases
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY num_of_potential_opportunities_for_purchases


-- categories with most popularity via site engagement
SELECT TOP 25 category, AVG(This_site_rank_in_global_internet_engagement) AS avg_site_engagement
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_site_engagement DESC


-- categories with most organic search traffic from search engines
SELECT TOP 25 category, AVG(comparison_metrics_search_traffic_this_site_percentage) AS avg_organic_traffic
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_organic_traffic DESC


-- categories with least organic search traffic from search engines
SELECT TOP 25 category, AVG(comparison_metrics_search_traffic_this_site_percentage) AS avg_organic_traffic
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_organic_traffic 


-- categories with highest single page bounce rate
SELECT TOP 25 category, AVG(comparison_metrics_data_bounce_rate_this_site_percentage) AS avg_bounce_rate
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_bounce_rate DESC


-- categories with least single page bounce rate
SELECT TOP 25 category, AVG(comparison_metrics_data_bounce_rate_this_site_percentage) AS avg_bounce_rate
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_bounce_rate


-- categories with most time spent on site
SELECT TOP 25 category, AVG(Daily_time_on_site) AS avg_time
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_time DESC


-- traffic scores for keywords that competitors are doing well in but not this site
-- since we have 408 categories, we will only consider categories that are more popular, 
-- which we can get by looking at categories with high avg values of This_site_rank_in_global_internet_engagement
SELECT 
		category, 
		all_topics_buyer_keywords_name_parameter_1, all_topics_buyer_keywords_Avg_traffic_parameter_1, all_topics_buyer_keywords_organic_competition_parameter_1,
		all_topics_buyer_keywords_name_parameter_2, all_topics_buyer_keywords_Avg_traffic_parameter_2, all_topics_buyer_keywords_organic_competition_parameter_2,
		all_topics_buyer_keywords_name_parameter_3, all_topics_buyer_keywords_Avg_traffic_parameter_3, all_topics_buyer_keywords_organic_competition_parameter_3,
		all_topics_buyer_keywords_name_parameter_4, all_topics_buyer_keywords_Avg_traffic_parameter_4, all_topics_buyer_keywords_organic_competition_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(This_site_rank_in_global_internet_engagement) AS avg_popularity
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_popularity DESC) AS Most_Popular_Categories)


-- doing the same thing as above but for categories that don't have a lot of competition in terms of buyer keywords
SELECT 
		category, 
		all_topics_buyer_keywords_name_parameter_1, all_topics_buyer_keywords_Avg_traffic_parameter_1, all_topics_buyer_keywords_organic_competition_parameter_1,
		all_topics_buyer_keywords_name_parameter_2, all_topics_buyer_keywords_Avg_traffic_parameter_2, all_topics_buyer_keywords_organic_competition_parameter_2,
		all_topics_buyer_keywords_name_parameter_3, all_topics_buyer_keywords_Avg_traffic_parameter_3, all_topics_buyer_keywords_organic_competition_parameter_3,
		all_topics_buyer_keywords_name_parameter_4, all_topics_buyer_keywords_Avg_traffic_parameter_4, all_topics_buyer_keywords_organic_competition_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(keyword_opportunities_breakdown_buyer_keywords) AS avg_keyword_gaps
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_keyword_gaps) AS Buyer_Comp_Categories)
--if you ordered by DESC here, then you would get websites with a lot of competition


-- one more time, but for categories that are have a lot of easy to rank keyword potential, 
-- which is good so websites in these categories will be easier to increase domain rating
SELECT 
		category, 
		all_topics_buyer_keywords_name_parameter_1, all_topics_buyer_keywords_Avg_traffic_parameter_1, all_topics_buyer_keywords_organic_competition_parameter_1,
		all_topics_buyer_keywords_name_parameter_2, all_topics_buyer_keywords_Avg_traffic_parameter_2, all_topics_buyer_keywords_organic_competition_parameter_2,
		all_topics_buyer_keywords_name_parameter_3, all_topics_buyer_keywords_Avg_traffic_parameter_3, all_topics_buyer_keywords_organic_competition_parameter_3,
		all_topics_buyer_keywords_name_parameter_4, all_topics_buyer_keywords_Avg_traffic_parameter_4, all_topics_buyer_keywords_organic_competition_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(keyword_opportunities_breakdown_easy_to_rank_keywords) AS avg_easy_to_rank
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_easy_to_rank DESC) AS Easy_to_Rank_Categories)


-- let's look at buyer keywords in relation to how much time the pages get 
SELECT 
		category, 
		all_topics_buyer_keywords_name_parameter_1, all_topics_buyer_keywords_Avg_traffic_parameter_1, all_topics_buyer_keywords_organic_competition_parameter_1,
		all_topics_buyer_keywords_name_parameter_2, all_topics_buyer_keywords_Avg_traffic_parameter_2, all_topics_buyer_keywords_organic_competition_parameter_2,
		all_topics_buyer_keywords_name_parameter_3, all_topics_buyer_keywords_Avg_traffic_parameter_3, all_topics_buyer_keywords_organic_competition_parameter_3,
		all_topics_buyer_keywords_name_parameter_4, all_topics_buyer_keywords_Avg_traffic_parameter_4, all_topics_buyer_keywords_organic_competition_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(Daily_time_on_site) AS avg_Daily_time_on_site
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_Daily_time_on_site DESC) AS Top_avg_Daily_time_on_site)


-- let's look at buyer keywords in relation to organic search traffic
SELECT 
		category, 
		all_topics_buyer_keywords_name_parameter_1, all_topics_buyer_keywords_Avg_traffic_parameter_1, all_topics_buyer_keywords_organic_competition_parameter_1,
		all_topics_buyer_keywords_name_parameter_2, all_topics_buyer_keywords_Avg_traffic_parameter_2, all_topics_buyer_keywords_organic_competition_parameter_2,
		all_topics_buyer_keywords_name_parameter_3, all_topics_buyer_keywords_Avg_traffic_parameter_3, all_topics_buyer_keywords_organic_competition_parameter_3,
		all_topics_buyer_keywords_name_parameter_4, all_topics_buyer_keywords_Avg_traffic_parameter_4, all_topics_buyer_keywords_organic_competition_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(comparison_metrics_search_traffic_this_site_percentage) AS avg_comparison_metrics_search_traffic_this_site_percentage
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_comparison_metrics_search_traffic_this_site_percentage DESC) AS Top_avg_comparison_metrics_search_traffic_this_site_percentage)



-- Now let's do somthing similar to the above few queries but for easy to rank keywords
-- the first is a query looking at easy to rank keywords among the top 10 most popular categories
SELECT 
		category, 
		all_topics_easy_to_rank_keywords_name_parameter_1, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_1, all_topics_easy_to_rank_keywords_search_pop_parameter_1,
		all_topics_easy_to_rank_keywords_name_parameter_2, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_2, all_topics_easy_to_rank_keywords_search_pop_parameter_2,
		all_topics_easy_to_rank_keywords_name_parameter_3, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_3, all_topics_easy_to_rank_keywords_search_pop_parameter_3,
		all_topics_easy_to_rank_keywords_name_parameter_4, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_4, all_topics_easy_to_rank_keywords_search_pop_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(This_site_rank_in_global_internet_engagement) AS avg_popularity
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_popularity DESC) AS Most_Popular_Categories)


-- looking at easy to rank keywords among categories that don't have a lot of competition in terms of buyer keywords
-- this is useful so a website in this category could rank a lot for these keywords, and build domain rating, which would help push all pages to rank, 
-- including ones that sell products (i.e. pages with buyer keywords)
SELECT 
		category, 
		all_topics_easy_to_rank_keywords_name_parameter_1, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_1, all_topics_easy_to_rank_keywords_search_pop_parameter_1,
		all_topics_easy_to_rank_keywords_name_parameter_2, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_2, all_topics_easy_to_rank_keywords_search_pop_parameter_2,
		all_topics_easy_to_rank_keywords_name_parameter_3, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_3, all_topics_easy_to_rank_keywords_search_pop_parameter_3,
		all_topics_easy_to_rank_keywords_name_parameter_4, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_4, all_topics_easy_to_rank_keywords_search_pop_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 10 category, AVG(keyword_opportunities_breakdown_buyer_keywords) AS avg_keyword_opportunities_breakdown_buyer_keywords
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_keyword_opportunities_breakdown_buyer_keywords) AS Top_avg_keyword_opportunities_breakdown_buyer_keywords)


-- easy to rank keywords for categories that get the most organnic traffic
SELECT 
		category, 
		all_topics_easy_to_rank_keywords_name_parameter_1, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_1, all_topics_easy_to_rank_keywords_search_pop_parameter_1,
		all_topics_easy_to_rank_keywords_name_parameter_2, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_2, all_topics_easy_to_rank_keywords_search_pop_parameter_2,
		all_topics_easy_to_rank_keywords_name_parameter_3, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_3, all_topics_easy_to_rank_keywords_search_pop_parameter_3,
		all_topics_easy_to_rank_keywords_name_parameter_4, all_topics_easy_to_rank_keywords_relevance_to_site_parameter_4, all_topics_easy_to_rank_keywords_search_pop_parameter_4
FROM WebsiteAnalysis..website_data
WHERE category IN (
SELECT category 
FROM (SELECT TOP 25 category, AVG(comparison_metrics_search_traffic_this_site_percentage) AS avg_comparison_metrics_search_traffic_this_site_percentage
FROM WebsiteAnalysis..website_data
GROUP BY category
ORDER BY avg_comparison_metrics_search_traffic_this_site_percentage DESC) AS Top_avg_comparison_metrics_search_traffic_this_site_percentage)




-- let's look at intersections
-- This gets the most popular categories interesected with categories with most organic traffic
SELECT category, AVG(This_site_rank_in_global_internet_engagement) as popularity, AVG(comparison_metrics_search_traffic_this_site_percentage) as organic_traffic
FROM WebsiteAnalysis..website_data
WHERE category in 
(SELECT category 
FROM (SELECT TOP 50 category, AVG(This_site_rank_in_global_internet_engagement) as popularity
FROM WebsiteAnalysis..website_data
Group By category
ORDER BY popularity DESC) AS popular_cats)
AND category in
(SELECT category
FROM (SELECT TOP 50 category, AVG(comparison_metrics_search_traffic_this_site_percentage) as organic_traffic
FROM WebsiteAnalysis..website_data
Group By category
ORDER BY organic_traffic DESC) AS org_traf_cats)
GROUP BY category



-- This gets the most popular categories interesected with categories with most buyer keywords
SELECT category, AVG(This_site_rank_in_global_internet_engagement) as popularity, AVG(keyword_opportunities_breakdown_buyer_keywords) as purchase_potential
FROM WebsiteAnalysis..website_data
WHERE category in 
(SELECT category 
FROM (SELECT TOP 150 category, AVG(This_site_rank_in_global_internet_engagement) as popularity
FROM WebsiteAnalysis..website_data
Group By category
ORDER BY popularity DESC) AS popular_cats)
AND category in
(SELECT category
FROM (SELECT TOP 150 category, AVG(keyword_opportunities_breakdown_buyer_keywords) as num_of_potential_opportunities_for_purchases
FROM WebsiteAnalysis..website_data
Group By category
ORDER BY num_of_potential_opportunities_for_purchases DESC) AS buyer_cats)
GROUP BY category