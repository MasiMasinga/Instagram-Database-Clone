-- GENERAL QUERIES

-- 1. Finding 5 Users
SELECT * 
FROM USERS
ORDER BY created_at
LIMIT 5;

-- 2. Most Popular Registration Date
SELECT 
    DAYNAME(created_at) AS day,
    COUNT(*) AS total
FROM USERS
GROUP BY day
ORDER BY total DESC
LIMIT 2;

-- 3. Identify Inactive Users (Users with No Photos)
SELECT username
FROM USERS
LEFT JOIN PHOTOS
    ON USERS.id = PHOTOS.user_id
WHERE PHOTOS.id IS NULL;

-- 4. Identify Most Popular Photo (and user who created it)
SELECT 
    username,
    PHOTOS.id,
    PHOTOS.image_url, 
    COUNT(*) AS total
FROM PHOTOS
INNER JOIN LIKES
    ON LIKES.photo_id = PHOTOS.id
INNER JOIN USERS
    ON PHOTOS.user_id = USERS.id
GROUP BY PHOTOS.id
ORDER BY total DESC
LIMIT 1;

-- STORED PROCEDURES

-- 1. Calculate average number of photos per user
DELIMITER $$
CREATE PROCEDURE GetAverageUser()
BEGIN
	SELECT (SELECT Count(*) FROM  photos) / (SELECT Count(*) 
	FROM USERS) AS avg; 
END$$
DELIMITER ;

-- 2. Five Most Popular Hashtags
DELIMITER $$
CREATE PROCEDURE PopularHashtags()
BEGIN
	SELECT 
		TAGS.tag_name,
        COUNT(*) AS total
	FROM PHOTO_TAGS
    JOIN TAGS
		ON PHOTO_TAGS.tag_id = tags_id
	GROUP BY TAGS.id
    ORDER BY total DESC
    LIMIT 5;
END$$
DELIMITER ;

-- 3. Find User who Like every single photo on the site
DELIMITER $$
CREATE PROCEDURE EveryPhotoLike()
BEGIN
	SELECT
		username,
        COUNT(*) AS num_likes
	FROM USERS
    INNER JOIN LIKES
		ON USERS.id = LIKES.user_id
	GROUP BY LIKES.user_id
	HAVING num_liks = (SELECT COUNT(*) FROM PHOTOS);
END$$
DELIMITER ;


-- VIEWS
-- 1. Find 5 Oldest Users
CREATE VIEW OLDEST_USERS AS
SELECT * 
FROM USERS
ORDER BY created_at
LIMIT 5;

SELECT * FROM OLDEST_USERS;

-- 2. Find Username & User IDS
CREATE VIEW USERPROFILE_AND_IDS AS 
SELECT id, username
FROM USERS;

SELECT * FROM USERPROFILE_AND_IDS LIKES;

-- 3. Find Top 10 Most Liked Photos on Instagram
CREATE VIEW INSTAGRAM_LIKES AS
SELECT username, PHOTOS.id, PHOTOS.image_url, COUNT(*) AS total
FROM PHOTOS
INNER JOIN LIKES
    ON LIKES.photo_id = PHOTOS.id
INNER JOIN USERS
    ON PHOTOS.user_id = USERS.id
GROUP BY PHOTOS.id
ORDER BY total DESC
LIMIT 10;

SELECT * FROM INSTAGRAM LIKES;

-- FUNCTIONS
-- 1. Find Number of Likes for Each User
SELECT
     username,
     COUNT(*) AS num_likes
FROM USERS;

-- 2. Find Total Number of Users on Instagram
SELECT SUM(id)
FROM USERS;

-- 3. Find Number of Created Accounts on Each Day
SELECT created_at AS time,
    COUNT(*) AS 'Number Of Created Accounts'
FROM USERS
GROUP BY time
ORDER BY time DESC;