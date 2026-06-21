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
