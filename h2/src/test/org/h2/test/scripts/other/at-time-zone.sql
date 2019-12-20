-- Copyright 2004-2019 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '10';
>> 2010-01-01 15:00:01.123456789+10

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '10:00:30';
>> 2010-01-01 15:00:31.123456789+10:00:30

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '10:00:30.1';
> exception INVALID_VALUE_2

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE INTERVAL '10:00' HOUR TO MINUTE;
>> 2010-01-01 15:00:01.123456789+10

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE INTERVAL '10:00:30' HOUR TO SECOND;
>> 2010-01-01 15:00:31.123456789+10:00:30

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE INTERVAL '10:00:30.1' HOUR TO SECOND;
> exception INVALID_VALUE_2

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 20:00:01.123456789+05' AT TIME ZONE '18:00';
>> 2010-01-02 09:00:01.123456789+18

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '-18:00';
>> 2009-12-31 11:00:01.123456789-18

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '-18:01';
> exception INVALID_VALUE_2

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '+18:01';
> exception INVALID_VALUE_2

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:01.123456789+05' AT TIME ZONE '19:00';
> exception INVALID_VALUE_2

CALL RIGHT(CAST(CURRENT_TIMESTAMP AT TIME ZONE '00:00' AS VARCHAR), 3);
>> +00

CALL CAST(CURRENT_TIMESTAMP AS VARCHAR) = CAST(CURRENT_TIMESTAMP AT LOCAL AS VARCHAR);
>> TRUE

CALL CAST(CURRENT_TIMESTAMP AS VARCHAR) = CAST(LOCALTIMESTAMP AT LOCAL AS VARCHAR);
>> TRUE

CALL TIME WITH TIME ZONE '10:00:01.123456789+05' AT TIME ZONE '10';
>> 15:00:01.123456789+10

CALL RIGHT(CAST(CURRENT_TIME AT TIME ZONE '00:00' AS VARCHAR), 3);
>> +00

CALL CAST(CURRENT_TIME AS VARCHAR) = CAST(CURRENT_TIME AT LOCAL AS VARCHAR);
>> TRUE

CALL CAST(CURRENT_TIME AS VARCHAR) = CAST(LOCALTIME AT LOCAL AS VARCHAR);
>> TRUE

CALL CAST(NULL AS TIMESTAMP) AT LOCAL;
>> null

CALL TIMESTAMP WITH TIME ZONE '2010-01-01 10:00:00Z' AT TIME ZONE NULL;
>> null

CALL 1 AT LOCAL;
> exception SYNTAX_ERROR_2

CREATE TABLE TEST(A TIMESTAMP WITH TIME ZONE, B INTERVAL HOUR TO MINUTE) AS
    (VALUES ('2010-01-01 10:00:00Z', '10:00'));
> ok

EXPLAIN SELECT A AT TIME ZONE B, A AT LOCAL FROM TEST;
>> SELECT ("A" AT TIME ZONE "B"), ("A" AT LOCAL) FROM "PUBLIC"."TEST" /* PUBLIC.TEST.tableScan */

DROP TABLE TEST;
> ok

CALL TIMESTAMP WITH TIME ZONE '2000-01-01 01:00:00+02' AT TIME ZONE 'Europe/London';
>> 1999-12-31 23:00:00+00

CALL TIMESTAMP WITH TIME ZONE '2000-07-01 01:00:00+02' AT TIME ZONE 'Europe/London';
>> 2000-07-01 00:00:00+01

CALL TIMESTAMP WITH TIME ZONE '2000-01-01 01:00:00+02' AT TIME ZONE 'Z';
>> 1999-12-31 23:00:00+00

CALL TIMESTAMP WITH TIME ZONE '2000-01-01 01:00:00+02' AT TIME ZONE 'UTC';
>> 1999-12-31 23:00:00+00

CALL TIMESTAMP WITH TIME ZONE '2000-01-01 01:00:00+02' AT TIME ZONE 'GMT';
>> 1999-12-31 23:00:00+00

CALL TIMESTAMP WITH TIME ZONE '2000-01-01 01:00:00+02' AT TIME ZONE '';
> exception INVALID_VALUE_2

CALL TIMESTAMP WITH TIME ZONE '2000-01-01 01:00:00+02' AT TIME ZONE 'GMT0';
> exception INVALID_VALUE_2

CALL TIME WITH TIME ZONE '01:00:00+02' AT TIME ZONE 'Europe/London';
> exception INVALID_VALUE_2

SET TIME ZONE '5';
> ok

SELECT "VALUE" FROM INFORMATION_SCHEMA.SETTINGS WHERE NAME = 'TIME ZONE';
>> GMT+05:00

SET TIME ZONE INTERVAL '4:00' HOUR TO MINUTE;
> ok

SET TIME ZONE NULL;
> exception INVALID_VALUE_2

SELECT "VALUE" FROM INFORMATION_SCHEMA.SETTINGS WHERE NAME = 'TIME ZONE';
>> GMT+04:00

CREATE TABLE TEST(T TIMESTAMP) AS (VALUES '2010-01-01 10:00:00');
> ok

SELECT CAST(T AS TIMESTAMP WITH TIME ZONE) FROM TEST;
>> 2010-01-01 10:00:00+04

SELECT T AT LOCAL FROM TEST;
>> 2010-01-01 10:00:00+04

SELECT T AT TIME ZONE '8:00' FROM TEST;
>> 2010-01-01 14:00:00+08

SET TIME ZONE LOCAL;
> ok

DROP TABLE TEST;
> ok
