
-- create table events
CREATE TABLE Events (
    Event_Id INT PRIMARY KEY,
    Event_Name VARCHAR(100),
    Event_Date DATE,
    Event_Location VARCHAR(100),
    Event_Description TEXT
);

-- Create Attendees table
CREATE TABLE Attendees (
    Attendee_Id INT PRIMARY KEY,


    Attendee_Name VARCHAR(100),
    Attendee_Phone VARCHAR(20),
    Attendee_Email VARCHAR(100),
    Attendee_City VARCHAR(50)
);

-- Create Registrations table with foreign key constraints
CREATE TABLE Registrations (
    Registration_id INT PRIMARY KEY,
    Event_Id INT,
    Attendee_Id INT,
    Registration_Date DATE,
    Registration_Amount DECIMAL(10,2),
    FOREIGN KEY (Event_Id) REFERENCES Events(Event_Id),
    FOREIGN KEY (Attendee_Id) REFERENCES Attendees(Attendee_Id)
);

-- 2. Data Creation
-- Insert sample data into Events table
INSERT INTO Events VALUES
(1, 'Classical Music Festival', '2025-06-15', 'Habitat Centre, Delhi', 'Traditional Indian classical music concert'),
(2, 'Comedy Night', '2025-07-01', 'The Leela Palace, Bangalore', 'Stand-up comedy show featuring top comedians'),
(3, 'Tech Summit 2025', '2025-08-10', 'Hyderabad Convention Centre', 'Technology and innovation conference'),
(4, 'Food Festival', '2025-09-20', 'Taj Lands End, Mumbai', 'Indian cuisine showcase'),
(5, 'Bollywood Concert', '2025-10-05', 'Salt Lake Stadium, Kolkata', 'Live performance by top playback singers'),
(6, 'Business Conference', '2025-11-15', 'ITC Maurya, Delhi', 'Leadership and entrepreneurship summit'),
(7, 'Cultural Festival', '2025-12-20', 'Umaid Bhawan Palace, Jodhpur', 'Traditional arts and culture showcase'),
(8, 'IPL Final', '2025-08-30', 'Eden Gardens, Kolkata', 'Cricket championship finale'),
(9, 'Art Exhibition', '2025-07-25', 'National Gallery, Mumbai', 'Contemporary Indian art showcase'),
(10, 'Dance Festival', '2025-09-10', 'Music Academy, Chennai', 'Classical dance performances');

-- Insert sample data into Attendess table
INSERT INTO Attendees VALUES
(1, 'Aarav Sharma', '9876543210', 'aarav@email.com', 'Delhi'),
(2, 'Ishita Patel', '9876543211', 'ishita@email.com', 'Mumbai'),
(3, 'Vihaan Gupta', '9876543212', 'vihaan@email.com', 'Ahmedabad'),
(4, 'Nandini Reddy', '9876543213', 'nandini@email.com', 'Hyderabad'),
(5, 'Arjun Singh', '9876543214', 'arjun@email.com', 'Bangalore'),
(6, 'Kavya Iyer', '9876543215', 'kavya@email.com', 'Chennai'),
(7, 'Reyansh Kumar', '9876543216', 'reyansh@email.com', 'Jaipur'),
(8, 'Riya Choudhary', '9876543217', 'riya@email.com', 'Kolkata'),
(9, 'Advait Mehta', '9876543218', 'advait@email.com', 'Pune'),
(10, 'Aisha Shah', '9876543219', 'aisha@email.com', 'Kochi');


-- Insert sample data into Registrations table
INSERT INTO Registrations VALUES
(1, 1, 3, '2025-05-01', 5000.00),
(2, 1, 5, '2025-05-02', 5000.00),
(3, 2, 1, '2025-06-15', 2500.00),
(4, 3, 2, '2025-07-01', 15000.00),
(5, 4, 6, '2025-08-15', 3500.00),
(6, 5, 4, '2025-09-01', 7500.00),
(7, 6, 7, '2025-10-10', 20000.00),
(8, 7, 8, '2025-11-20', 4000.00),
(9, 8, 9, '2025-07-15', 8000.00),
(10, 9, 10, '2025-06-30', 2000.00);

-- 3. Manage Event Details
-- a) Inserting a new event.

INSERT into Events VALUES (11, 'Dance Festival', '2025-09-10', 'Music Academy, Chennai', 'Classical dance performances');

select * from events 
where event_id = 11;

-- b) Updating an event's information. 
update events 
set event_location = 'Nrityakala Academy, Assam'
where event_id = 11;

select * from events 
where event_id = 11;

-- c) Deleting an event. 
delete from events 
where event_id = 11; 

select * from events;

-- 4) Manage Track Attendees & Handle Events
-- a) Inserting a new attendee.

insert into attendees values (12, 'Arjun Mishra', '9876543215', 'arjun@email.com', 'Mumbai');

select * from attendees
	where attendee_id = 12;

-- b)Registering an attendee for an event. 

insert into Registrations values (11, 6, 7, '2025-06-30', 2200.00);

select * from registrations 
where registration_id = 11;

-- 5.Develop queries to retrieve event information, generate attendee lists, and calculate event attendance statistics. 

WITH attendee_counts AS (
    SELECT  
        e.Event_Name,
        e.Event_Date,
        e.Event_Location,
        e.Event_Id,
        COUNT(r.Attendee_Id) as Attendee_Count
    FROM Events e
    LEFT JOIN Registrations r ON e.Event_Id = r.Event_Id
    GROUP BY 
        e.Event_Id,
        e.Event_Name, 
        e.Event_Date, 
        e.Event_Location
),
attendee_details AS (
    SELECT 
        ac.*,
        r.Attendee_Id,
        a.Attendee_Name
    FROM attendee_counts ac
    LEFT JOIN Registrations r ON ac.Event_Id = r.Event_Id
    LEFT JOIN Attendees a ON r.Attendee_Id = a.Attendee_Id
)
SELECT 
    Event_Name,
    Event_Date,
    Event_Location,
    COALESCE(Attendee_Count::text, 'No Attendees') as Attendee_Count,
    COALESCE(Attendee_Name, 'No Attendee') as Attendee_Name
FROM attendee_details 
	order by attendee_count desc;
