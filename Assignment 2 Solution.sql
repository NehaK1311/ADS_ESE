
-- I. MySQL / PSM Review :

-- a) Create a table called test_table with 2 columns RecordNumber 
-- (type : Number(3)) and CurrentDate (type : Date)). Write PL/SQL 
-- block which will insert 50 records into test_table. Insert the current 
-- date value into the table.

create table test_table(
   RecordNumber INT,
   CurrentDate DATE
);

-- Change the delimiter
delimiter //

-- Create the stored procedure
create procedure InsertTestData()
begin
    declare counter int default 1;

    while counter <= 50 do
       insert into test_table (RecordNumber, CurrentDate) values (counter, curdate());
       set counter = counter + 1;
    end while;
end //

-- Change the delimiter back to semicolon
delimiter ;

call InsertTestData();     

select * from test_table;  


-----------------------------------------------XXXXXXX------------------------------------------
--b) Create a products table products(ProductID number(4),category 
--char(3),detail varchar2(30),price number(10,2),stock number(5)).
--Insert the sample data.
--Write PSM procedure with two arguments X & Y which will increase 
--price by X% for all products in category Y. X and Y will be given by 
--user.

-- Create the products table  
create table products(
   productID int(4),
   category char(3),
   detail varchar(30),
   price decimal(10, 2),
   stock int(5)
   
);

ALTER TABLE products
MODIFY COLUMN category VARCHAR(255);

-- Insert sample data 
insert into products(productID, category, detail, price, stock)
values (1, 'Cat1', 'Product1', 100.00, 50);
insert into products(productID, category, detail, price, stock)
values (2, 'Cat2', 'Product2', 200.05, 55);
insert into products(productID, category, detail, price, stock)
values (3, 'Cat3', 'Product3', 145.36, 840);


-- Create the procedure to update prices
DELIMITER //

CREATE PROCEDURE UpdatePrices (X  DECIMAL(5,2), Y VARCHAR(255))
BEGIN
   UPDATE products
   SET price = price * (1 + X / 100)
   WHERE category = Y;

   COMMIT;
END //

DELIMITER ;

-- Disable safe update mode
-- Unless we do like this we cant make any updations in the table 
SET SQL_SAFE_UPDATES = 0;

-- Call the procedure
CALL UpdatePrices(10.00, 'Cat1');

-- Re-enable safe update mode (optional, but recommended for safety)
SET SQL_SAFE_UPDATES = 1;

select * from products;

---------------------------------------------XXXXXXXX-------------------------------------------


--a) Create Object Table containing field “name” of size 50 
--characters and member function “countNoOfWords” which 
--returns the no. of words in “name” field.
--Demonstrate the working by entering different data.

-- Create an Object Type
CREATE TYPE NameObjectType as OBJECT (
    name varchar(50),
    member function countNoOfWords RETURN NUMBER
);

-- Create a Table Type based on the Object Type
create type NameTableType as table of NameObjectType;


-- It appears that the error is due to the incorrect usage of the NESTED TABLE clause. In Oracle Database, when you want to store nested tables in a separate storage table, you should use the NESTED TABLE clause in the column definition, not in the CREATE TABLE statement itself.

-- Create the main Table with the nested table column
CREATE TABLE ObjectTable (
    id INT PRIMARY KEY,
    name_objects NameTableType
) NESTED TABLE name_objects STORE AS NameObjectTable;



--The REGEXP_COUNT function in Oracle Database is used to count the number of occurrences of a specified pattern in a string. In this case, the pattern is \S+, which is a regular expression that matches one or more non-whitespace characters. Let's break down the regular expression:
--
--\S: Represents any non-whitespace character.
--+: Represents one or more occurrences of the preceding element (\S in this case).
--So, \S+ matches one or more consecutive non-whitespace characters. When applied in the context of counting words, this regular expression counts sequences of non-whitespace characters, which essentially corresponds to counting words separated by spaces.
--
--Here's how the REGEXP_COUNT function is being used in the context of your PL/SQL member function:
--
--sql
--Copy code
--RETURN REGEXP_COUNT(self.name, '\S+', 1, 'i');
--self.name: Refers to the name attribute of the current instance of the object type (NameObjectType).
--'\S+': Specifies the regular expression pattern to match one or more non-whitespace characters.
--1: Specifies the starting position in the string (in this case, the entire string).
--'i': Specifies the match parameter to perform a case-insensitive match.
--Therefore, the function counts the number of words in the name attribute of the object by looking for sequences of non-whitespace characters. Each such sequence is considered a word, and the total count is returned by the REGEXP_COUNT function.
--
--For example, if self.name is 'John Doe', the regular expression \S+ matches 'John' and 'Doe', and the count returned is 2, indicating that there are two words in the name.
--
--
--
--
--User
--'\S+': Specifies the regular expression pattern to match one or more non-whitespace characters.  what does this does
--
--ChatGPT
--The regular expression pattern '\S+' is used to match one or more consecutive non-whitespace characters in a string. Let's break down the components of this regular expression:
--
--\S: Represents any non-whitespace character.
--+: Represents one or more occurrences of the preceding element (\S in this case).
--So, '\S+' effectively matches sequences of non-whitespace characters. Here's what each part does:
--
--\S: Matches any character that is not a whitespace character. This includes letters, digits, punctuation, symbols, etc.
--+: Requires that the previous element (\S) appears one or more times consecutively. This means it matches one or more non-whitespace characters in sequence.
--As a result, the overall regular expression '\S+' will match any sequence of one or more non-whitespace characters in a string. In the context of counting words, this regular expression is used to identify and count consecutive groups of characters that are not separated by whitespace. Each such group is considered a word.
--
--
--
--
--User
--'i': Specifies the match parameter to perform a case-insensitive match.  what does it does
--
--ChatGPT
--The 'i' in the REGEXP_COUNT function's match parameter specifies that the regular expression pattern should be applied in a case-insensitive manner. Let's break down how this works:
--
--Without the 'i': If you do not specify 'i' (case-insensitive), the regular expression pattern will be case-sensitive. For example, if your pattern is \S+, it will match sequences of non-whitespace characters in the exact case specified in the pattern. So, 'Hello' and 'hello' would be treated as different patterns, and the match would be case-sensitive.
--
--With the 'i': When you include 'i' as the match parameter, it indicates a case-insensitive match. In this case, the regular expression pattern \S+ will match sequences of non-whitespace characters regardless of their case. So, 'Hello', 'hello', 'HELLO', etc., would all be considered matches.
--
--In the context of the provided PL/SQL member function:
--
--sql
--Copy code
--RETURN REGEXP_COUNT(self.name, '\S+', 1, 'i');
--The 'i' ensures that the regular expression pattern \S+ counts sequences of non-whitespace characters in a case-insensitive manner. It's useful when you want to count words without being concerned about the case of the letters within those words.

-- Implement the member function
-- Implement the member function without the 'i' flag
CREATE OR REPLACE TYPE BODY NameObjectType AS
    MEMBER FUNCTION countNoOfWords RETURN NUMBER IS
        l_name VARCHAR2(50);
    BEGIN
        -- Convert the name to uppercase before counting words
        l_name := UPPER(self.name);
        
        -- Count the number of words using regular expression
        RETURN REGEXP_COUNT(l_name, '\S+', 1);
    END countNoOfWords;
END;
/

-- Demonstrate the working by entering different data
declare
   names NameTableType;
begin
   --Instantiate the objects
   names:= NameTableType(NameObjectType('Neha Pintu Sangeeta Kharat'), NameObjectType('Tejas Pintu Kharat'));
   
   --Insert data into the table
   INSERT INTO ObjectTable(id, name_objects) values (5, names);
   
   --Call the member function for the first object and print the result
   DBMS_OUTPUT.PUT_LINE('Number of words: ' || names(2).countNoOfWords);
END;
/

select * from objecttable;

-- ----------------------------------------------------XXXXXXXX----------------------------------------------------------------

--b) Create an address type with the following attributes : address, 
--city, state & pincode. Include the following methods
--i. to extract the addresses based on given keyword.
--j. to return the no. of words in each given field (method 
--should accept the name of attribute/field)


--Create an Address type
create type AddressType as object
(
   address varchar2(100),
   city varchar2(50),
   state varchar2(50),
   pincode varchar2(10),
   
   --Method to extract addresses based on a given keyword
   member function extractAddresses(keyword varchar2) return varchar2,
   
   --Method to return the number of words in a given field
   member function countWords(feildName varchar2) return number
);


-- Create the type body
CREATE OR REPLACE TYPE BODY AddressType AS
    -- Method implementation to extract addresses based on a given keyword
    MEMBER FUNCTION extractAddresses(keyword VARCHAR2) RETURN VARCHAR2 IS
        extractedAddresses VARCHAR2(4000);
    BEGIN
        -- Concatenate address fields if the keyword is found in any of them
        IF INSTR(self.address, keyword) > 0 THEN
            extractedAddresses := self.address || ' ';
        END IF;

        IF INSTR(self.city, keyword) > 0 THEN
            extractedAddresses := extractedAddresses || self.city || ' ';
        END IF;

        IF INSTR(self.state, keyword) > 0 THEN
            extractedAddresses := extractedAddresses || self.state || ' ';
        END IF;

        IF INSTR(self.pincode, keyword) > 0 THEN
            extractedAddresses := extractedAddresses || self.pincode;
        END IF;

        RETURN extractedAddresses;
    END extractAddresses;

    -- Method implementation to return the number of words in a given field
    MEMBER FUNCTION countWords(feildName VARCHAR2) RETURN NUMBER IS
        wordsCount NUMBER;
    BEGIN
        -- Use REGEXP_COUNT to count words based on space delimiter
        CASE feildName
            WHEN 'address' THEN
                wordsCount := REGEXP_COUNT(self.address, '\S+', 1);
            WHEN 'city' THEN
                wordsCount := REGEXP_COUNT(self.city, '\S+', 1);
            WHEN 'state' THEN
                wordsCount := REGEXP_COUNT(self.state, '\S+', 1);
            WHEN 'pincode' THEN
                wordsCount := REGEXP_COUNT(self.pincode, '\S+', 1);
            ELSE
                wordsCount := 0; -- Return 0 for unknown field
        END CASE;

        RETURN wordsCount;
    END countWords;
END;
/

create table AddressTable (
   id int primary key,
   address_info AddressType
);

--Insert sample data
insert into addressTable values (
   1, 
   AddressType('123 Main St', 'Miraj', 'Maharashtra', '416410')
);
insert into addressTable values (
   2, 
   AddressType('45 Submain St', 'sangli', 'Gujarat', '410410')
);

select * from addressTable;


declare 
   -- Declare variables to store the values from the AddressType table
   v_id number;
   v_address AddressType;
begin   
   -- Cursor to fetch data from AddressType table
   for rec in (select id, address_info from addresstable) loop
      --Assign values to variables
      v_id := rec.id;
      v_address := rec.address_info;
      
      dbms_output.put_line('ID: ' || v_id);
      DBMS_OUTPUT.PUT_LINE('Address: ' || v_address.address);
        DBMS_OUTPUT.PUT_LINE('City: ' || v_address.city);
        DBMS_OUTPUT.PUT_LINE('State: ' || v_address.state);
        DBMS_OUTPUT.PUT_LINE('Pincode: ' || v_address.pincode);
        DBMS_OUTPUT.PUT_LINE('------------------------');
    END LOOP;
END;
/

----------------------------------XXXXXX---------------------------------------

--c) Create a user defined data type course_Type with 2 attributes 
--course_id, description :
--i. Create an object table based on the type created.
--j. Insert rows into the table
-- Demonstrate the working with different data sets

-- Here no need of creating a seperate attribute of the primary key in the table bcz course_id in the object itself is the primary key
-- Hence the table will contain only 1 attribute or column i.e. of type course_type object

-- Create a user-defined data type course_Type
create type course_type as object
(
   course_id number,
   description varchar2(100)
);

-- Create an object table based on the course_Type
create table coursetable of course_type;

-- Insert rows into the table
insert into coursetable values(12345, 'Mathematics');
INSERT INTO CourseTable VALUES (2, 'Computer Science');
INSERT INTO CourseTable VALUES (3, 'History');

-- Query the data from the table
SELECT * FROM CourseTable;
