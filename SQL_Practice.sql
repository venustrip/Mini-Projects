/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT  name
FROM  Facilities
WHERE  membercost > 0.0
LIMIT 0 , 30;

/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * ) 
FROM  Facilities
WHERE  membercost = 0.0;

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost > 0
AND membercost < ( 0.20 * monthlymaintenance ) ;

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM  Facilities
WHERE  facid
IN ( 1, 5 );

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance >100
THEN  'Expensive'
ELSE  'Cheap'
END Maintenance
FROM Facilities;

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM  `Members` 
WHERE joindate
IN (
SELECT (
MAX( joindate )
)
FROM  `Members`
);

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT Facilities.name Facility, CONCAT( firstname,  ' ', surname ) Member
FROM Bookings
JOIN Members ON Bookings.memid = Members.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE Facilities.facid
IN ( 0, 1 ) 
ORDER BY Member;

/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT Facilities.name Facility, CONCAT( Firstname,  ' ', Surname ) Member, 
CASE WHEN Bookings.memid =0
THEN SUM( (
slots * guestcost
) ) 
ELSE SUM( (
slots * membercost
) ) 
END Total_Cost
FROM Bookings
JOIN Members ON Bookings.memid = Members.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
WHERE starttime LIKE  '2012-09-14%'
GROUP BY Facility, Member
HAVING Total_Cost >30
ORDER BY Total_Cost DESC ;

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT x.Facility, x.Member, x.Total_Cost 
FROM (SELECT Facilities.name Facility, concat(Firstname, ' ', Surname) Member, 
CASE WHEN Bookings.memid = 0 then
sum((slots * guestcost))
else sum((slots * membercost) )
end Total_Cost
FROM Bookings
JOIN Members on
Bookings.memid = Members.memid
JOIN Facilities on
Bookings.facid = Facilities.facid
WHERE starttime like '2012-09-14%'
GROUP BY Facility, Member
HAVING Total_Cost > 30) x
ORDER BY Total_Cost DESC;

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT Facilities.name Facility, SUM( 
CASE WHEN Bookings.memid =0
THEN (
slots * guestcost
)
ELSE (
slots * membercost
)
END ) Total_Revenue
FROM Bookings
JOIN Members ON Bookings.memid = Members.memid
JOIN Facilities ON Bookings.facid = Facilities.facid
GROUP BY Facilities.name
HAVING Total_Revenue <1000
ORDER BY Total_Revenue;
