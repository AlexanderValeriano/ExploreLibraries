*** Settings ***
Library  DatabaseLibrary
Library  String
Library  DateTime
Library  Dialogs

*** Variables ***
# Haven't figured out how to use variables for MySql connection string yet
${MYSQL_DB_MODULE} =  pymssql
${DB_NAME} =  rftutorial
${DB_USER_NAME} =  rftutorial
${DB_USER_PASSWORD} =  Demoscript1!
${DB_HOST} =  mysql1100.shared-servers.com
${DB_PORT} =  1091
${PREVIOUS_ROW_COUNT}

*** Keywords ***
# replace the server & credentials with your own
Connect
    # Haven't figured out how to use variables for MySql connection string yet
    Connect To Database Using Custom Params  pymysql  database='schemascott', user='root', password='keepapi', host='', port=''

Save Current Row Count
    ${current_row_count} =  Row Count  SELECT * FROM emp;
    Set Suite Variable  ${PREVIOUS_ROW_COUNT}  ${current_row_count}
    Log  ${current_row_count}

Get Input Data
    # from the dialogs library
    ${name} =  Get Value From User  Enter a Last Name
    # save it at the suite scope so subsequent test can use it
    Set Suite Variable  ${LAST_NAME}  ${name}

Insert Record
    # Optional: Use these commented lines to create your table if necessary
    #Delete All Rows From Table  DemoItems
    #Execute SQL String  DROP TABLE DemoItems
    #Execute SQL String  CREATE TABLE DemoItems (ItemId INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY, ItemName VARCHAR(50) NOT NULL, FirstName VARCHAR(50) NOT NULL)

    # I wasn't able to get a DateTime value inside the query like I did on SQL Server
    # so had to do it on a separate line. This is from the DateTime library.
    # For some reason, Pycharm/Intellibot doesn't recognize it and underlines it
    ${current_date} =  Get Current Date

    # notice I've put the variables inside single quotes
    ${insert_command} =  Set Variable  INSERT INTO emp (EMPNO,ENAME) VALUES ('7980','${LAST_NAME}')
    Execute SQL String  ${insert_command}

Verify New Record Added
    ${new_row_count} =  Row Count  SELECT * FROM emp;
    Log  ${new_row_count}
    # notice that I'm using +1 INSIDE the braces, not after the final brace
    Should be Equal as Numbers  ${new_row_count}  ${PREVIOUS_ROW_COUNT + 1 }

Verify Last Record
    # notice here we use LIMIT 1 instead of TOP 1 in SQL Server
    ${queryResults} =  Query  SELECT TOP 1 * FROM emp ORDER BY EMPNO DESC
    # Examine the (0-based) 3rd field of the first record in the results
    Should be Equal as Strings  ${queryResults[0][2]}  ${LAST_NAME}
    Log  ${queryResults[0][2]}

Log All Rows
    ${queryResults} =  Query  SELECT * FROM emp ORDER BY EMPNO
    Log Many  ${queryResults}

Disconnect
    Disconnect from Database