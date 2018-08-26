SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance <100
THEN  'cheap'
ELSE  'expensive'
END AS Class
FROM  `Facilities`
 


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT surname, firstname, joindate
FROM  `Members` 
ORDER BY joindate DESC

Answer: Smith Darren, join date = 2012-09-26 18:08:45


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Facilities.name, CONCAT(Members.surname,  '', Members.firstname) AS Name
FROM Members
INNER JOIN Bookings ON Members.memid = Bookings.memid
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Bookings.facid =0
OR Bookings.facid =1
ORDER BY Name

Answer: Get a table with facility name of Tennis court and the first name and last name of the members. 



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT Members.surname, Facilities.name, 
CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END AS cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
WHERE starttime LIKE  '2012-09-14%'
AND (

CASE WHEN Bookings.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END
) >30
ORDER BY cost DESC 


Answer: Get a table 


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT sub.Facname, sub.Membername, sub.cost
FROM (

SELECT Bookings.starttime, Facilities.name AS Facname, Members.surname AS Membername, (

CASE WHEN Members.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END
) AS cost
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
) AS sub
WHERE starttime LIKE  '2012-09-14%'
AND cost >30
ORDER BY cost DESC



/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

Total cost, and then sum of total cost, and groupby facility id  

SELECT Facilities.name, SUM( 
CASE WHEN Members.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END ) AS revenue
FROM Bookings
INNER JOIN Facilities ON Bookings.facid = Facilities.facid
INNER JOIN Members ON Bookings.memid = Members.memid
GROUP BY Facilities.name
HAVING SUM( 
CASE WHEN Members.memid =0
THEN Facilities.guestcost * Bookings.slots
ELSE Facilities.membercost * Bookings.slots
END ) <1000

Answer: 

name
revenue
Pool Table
270.0
Snooker Table
240.0
Table Tennis
180.0



