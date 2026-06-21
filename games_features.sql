DROP TABLE IF EXISTS games;

CREATE TABLE games (
	-- Identity
	ResponseName varchar(50),
	ReleaseDate date,
	ReleaseYear smallint,
	ReleaseMonth varchar(10),
	ReleaseDay varchar(10),
	ReleaseDecade varchar(10),
	ReleaseQuarter varchar(5),

	-- Genre
	Genre varchar(30),
	GenreIsIndie smallint,
	GenreIsAction smallint,
	GenreIsAdventure smallint,
	GenreIsCasual smallint,
	GenreIsRPG smallint,
	GenreIsFreeToPlay smallint,
	GenreIsSimulation smallint,
	GenreIsEarlyAccess smallint,
	GenreIsMassivelyMultiplayer smallint,
	GenreIsNonGame smallint,
	GenreIsStrategy smallint,
	GenreIsSports smallint,
	GenreIsRacing smallint,

	-- Pricing
	PriceInitial numeric(8,2),
	PriceFinal numeric(8,2),
	DiscountPct numeric(5,2),
	PriceCurrency varchar(5),
	PriceCategory varchar(15),
	IsFree smallint,
	FreeOrPaid varchar(5),

	-- Scores
	Metacritic smallint,
	MetacriticCategory varchar(15),
	ReviewCategory varchar(15),

	-- Age
	RequiredAge smallint,
	AgeRating varchar(15),

	-- Popularity / Owners
	SteamSpyOwners bigint,
	SteamSpyOwnersVariance bigint,
	SteamSpyPlayersEstimate bigint,
	PopularityCategory varchar(15),
	RecommendationCount int,

	-- Platform
	PlatformWindows smallint,
	PlatformLinux smallint,
	PlatformMac smallint,
	PlatformCategory varchar(25),
	PCReqsHaveMin smallint,
	PCReqsHaveRec smallint,
	LinuxReqsHaveMin smallint,
	LinuxReqsHaveRec smallint,
	MacReqsHaveMin smallint,
	MacReqsHaveRec smallint,

	-- Games Categories
	CategorySinglePlayer smallint,
	CategoryMultiplayer smallint,
	CategoryCoop smallint,
	CategoryMMO smallint,
	CategoryInAppPurchase smallint,
	CategoryIncludeLevelEditor smallint,
	CategoryVRSupport smallint,
	CategoryIncludeSrcSDK smallint,

	-- Content Counts
	DLCCount smallint,
	DemoCount smallint,
	MovieCount smallint,
	ScreenshotCount smallint,
	AchievementCount smallint,
	AchievementHighlightedCount smallint,
	PublisherCount smallint,
	DeveloperCount smallint,
	PackageCount smallint,

	-- Misc
	ControllerSupport smallint,
	FreeVerAvail smallint,
	PurchaseAvail smallint,
	SubscriptionAvail smallint,
	LanguageCount smallint
	
);

select * from games;

ALTER TABLE games 
ALTER COLUMN ResponseName TYPE varchar(200);

Select count(*) as total_rows from games;

-- Preview first 5 rows
select ResponseName, Genre, PriceFinal, PriceCategory,
	Metacritic, ReviewCategory, ReleaseYear
from games
limit 5;

-- Check nulls in release columns 
select count(*) as null_release_dates
from games
where releasedate is null;


-- Total games per genre
select Genre, count(*) as total_games
from games
group by Genre
order by total_games desc;

-- Average Metacritic score per genre (only rated games)
select Genre,
  count(*) as total_games,
  	round(avg(Metacritic), 2) as avg_metacritic,
  	max(Metacritic) as best_score,
  	min(case when Metacritic > 0
  		then Metacritic end) as lowest_score
from games
where Metacritic > 0
group by Genre
order by avg_Metacritic desc;

-- Genre popularity: total recommendation

select Genre,
		sum(RecommendationCount) as total_recommendations,
		round(avg(RecommendationCount), 2) as avg_recommendations
from games
group by Genre
order by avg_recommendations desc;

-- Genre Price Category ( How much do different genre cost)
select Genre, PriceCategory, count(*) as count
from games
group by Genre, PriceCategory
order by Genre, count desc;

-- Price Analysis

-- PriceCategory Distribution
select PriceCategory,
	Count(*) AS games,
	round(count(*) * 100.0 / sum(count(*)) over(), 2) as Pct
from games
group by PriceCategory
order by games desc, Pct;

-- Average price per genre (Paid games only)
select Genre,
	Count(*) as paid_games,
	round(avg(PriceFinal), 2) as avg_price,
	round(max(PriceFinal), 2) as max_price,
	round(min(PriceFinal), 2) as min_price
from games
where IsFree = 0
group by Genre
order by avg_price desc;

-- Top 15 most discounted games
select ResponseName, Genre, PriceInitial, PriceFinal,
	round(DiscountPct * 100.0, 0) as discount_percent
from games
where DiscountPct > 0
order by DiscountPct desc
limit 15;

-- DOES HIGHER PRICE = BETTER Metacritic?
select PriceCategory,
	round(avg(Metacritic), 2) as avg_Metacritic,
	count(*) as games
from games
where Metacritic > 0
group by PriceCategory
order by avg_Metacritic desc;

-- Free Paid breakdown
select FreeOrPaid,
	count(*) as games,
	round(avg(Metacritic), 2) as avg_metacritic,
	round(avg(RecommendationCount), 2) as avg_recommendations
from games
group by FreeOrPaid;


/*
    Metacritic Review Analysis
*/
-- Review Categroy distribution

select ReviewCategory,
	count(*) as count,
	round(count(*) * 100.0 / sum(count(*)) over (), 2) as pct
from games
group by ReviewCategory
order by count desc;

-- Metacritic Category Breakdown 
select MetacriticCategory,
	count(*) as count,
	round(count(*) * 100.0 / sum(count(*)) over(), 2) as pct
from games
group by MetacriticCategory
order by count desc;

-- Top 20 highest rated games

select ResponseName, Genre, Metacritic, ReviewCategory,
	RecommendationCount, SteamSpyOwners
From games
where Metacritic > 0
order by Metacritic desc
limit 20;

-- Worsted rated games (poor reviews,  score)

select ResponseName, Genre, Metacritic, ReviewCategory, PriceFinal
from games
where ReviewCategory = 'Poor' and Metacritic > 0
order by Metacritic asc
limit 10;

-- Excellent reviewed games per genre

select Genre,
	Count(*) as excellent_games
from games
where ReviewCategory = 'Excellent'
group by Genre
order by excellent_games desc
limit 10;

-- Games released per year

select ReleaseYear,
	count(*) as games_released
from games
where ReleaseYear is not null
group by ReleaseYear
order by ReleaseYear;

-- Best year by average Metacritic
Select ReleaseYear,
	count(*) as released_games_total,
	round(avg(Metacritic), 2) as avg_metacritic
from games
where ReleaseYear is not null and Metacritic > 0
group by ReleaseYear
order by avg_metacritic desc
limit 10;
	
-- Games per decade
select ReleaseDecade,
	count(*) as total_games
from games
where ReleaseDecade is not null
group by ReleaseDecade
order by ReleaseDecade;

--Quarterly release trend
select ReleaseQuarter,
	count(*) as release
from games
where ReleaseQuarter is not null
group by ReleaseQuarter
order by release desc;

-- Monthly Release trend

select ReleaseMonth,
	count(*) as release
from games
where ReleaseMonth is not null
group by ReleaseMonth
order by release desc;
