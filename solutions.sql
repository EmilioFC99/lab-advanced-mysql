use publications;

#Challenge 1 - Most Profiting Authors
	#Step 1: Calculate the royalties of each sales for each author
SELECT titleauthor.title_id AS titleID, titleauthor.au_id AS authorID, titles.price * sales.qty * titles.royalty / 100 *  titleauthor.royaltyper / 100 AS sales_royalty
FROM publications.titleauthor titleauthor
RIGHT JOIN publications.titles titles ON titleauthor.title_id = titles.title_id
JOIN publications.sales sales ON titles.title_id = sales.title_id;

	#Step 2: Aggregate the total royalties for each title for each author
CREATE TEMPORARY TABLE agreggated_total_royalties SELECT titleID, authorID, SUM(sales_royalty) AS totalRoyalties
FROM (SELECT titleauthor.title_id AS titleID, titleauthor.au_id AS authorID, titles.price * sales.qty * titles.royalty / 100 *  titleauthor.royaltyper / 100 AS sales_royalty
FROM publications.titleauthor titleauthor
RIGHT JOIN publications.titles titles ON titleauthor.title_id = titles.title_id
JOIN publications.sales sales ON titles.title_id = sales.title_id) royalties_per_sales
GROUP BY royalties_per_sales.authorID, royalties_per_sales.titleID;

	#Step 3: Calculate the total profits of each author
SELECT 
    authorID, 
    titles.advance + totalRoyalties AS Profits
FROM
    agreggated_total_royalties
        JOIN
    publications.titles titles ON agreggated_total_royalties.titleID = titles.title_id
ORDER BY Profits DESC
LIMIT 3;
#Challenge 2


#Challenge 3
CREATE TABLE most_profiting_authors 
SELECT 
    authorID, 
    titles.advance + totalRoyalties AS Profits
FROM(SELECT titleID, authorID, SUM(sales_royalty) AS totalRoyalties
FROM (SELECT titleauthor.title_id AS titleID, titleauthor.au_id AS authorID, titles.price * sales.qty * titles.royalty / 100 *  titleauthor.royaltyper / 100 AS sales_royalty
FROM publications.titleauthor titleauthor
RIGHT JOIN publications.titles titles ON titleauthor.title_id = titles.title_id
JOIN publications.sales sales ON titles.title_id = sales.title_id) royalties_per_sales
GROUP BY royalties_per_sales.authorID, royalties_per_sales.titleID) agreggated_total_royalties
JOIN publications.titles titles ON agreggated_total_royalties.titleID = titles.title_id
ORDER BY Profits DESC;

SELECT * FROM publications.most_profiting_authors;