xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/obdx/CTFO";
(:: import schema at "CTFO.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/INSTRUCTION_LIST";
(:: import schema at "INSTRUCTION_LIST.xsd" ::)
declare variable $UserIdVar as xs:string external;
declare variable $INSTRUCTION_LIST as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($UserIdVar as xs:string , $INSTRUCTION_LIST as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
             <ns2:status>  {
                    if (fn:data($INSTRUCTION_LIST/ns1:errorCode) = '0')
                    then 'SUCCESS'
                    else 'FAILURE'
                  }</ns2:status> 
            <ns2:errorList></ns2:errorList>
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
         {
            for $CTFO in $INSTRUCTION_LIST/ns1:operationData/ns1:CTFO_O_0003
            return
        <ns2:instructions>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:partyId>{$UserIdVar}</ns2:partyId>
            <ns2:externalReferenceNo>{fn:data($CTFO/ns1:CTFO_O_0003_0001)}</ns2:externalReferenceNo>
            <ns2:transactionType>INTERNALFT</ns2:transactionType>
            <ns2:startDate>
                <ns2:dateString>{fn:data($CTFO/ns1:CTFO_O_0003_0010)}</ns2:dateString>
                <ns2:monthDate></ns2:monthDate>
                <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                <ns2:monthDateTime></ns2:monthDateTime>
                <ns2:weekOfYear></ns2:weekOfYear>
                <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                <ns2:sqltimestamp></ns2:sqltimestamp>
                <ns2:month></ns2:month>
                <ns2:dayOfWeek></ns2:dayOfWeek>
                <ns2:millis></ns2:millis>
                <ns2:sqlDate></ns2:sqlDate>
                <ns2:time></ns2:time>
                <ns2:timestamp></ns2:timestamp>
                <ns2:yearMonth></ns2:yearMonth>
                <ns2:year></ns2:year>
                <ns2:dayOfMonth></ns2:dayOfMonth>
                <ns2:yearMonthDate></ns2:yearMonthDate>
                <ns2:infinite></ns2:infinite>
                <ns2:null></ns2:null>
                <ns2:leapYear></ns2:leapYear>
                <ns2:dayOfYear></ns2:dayOfYear>
            </ns2:startDate>
            <ns2:endDate>
                <ns2:dateString>{fn:data($CTFO/ns1:CTFO_O_0003_0011)}</ns2:dateString>
                <ns2:monthDate> </ns2:monthDate>
                <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                <ns2:monthDateTime></ns2:monthDateTime>
                <ns2:weekOfYear></ns2:weekOfYear>
                <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                <ns2:sqltimestamp></ns2:sqltimestamp>
                <ns2:month></ns2:month>
                <ns2:dayOfWeek></ns2:dayOfWeek>
                <ns2:millis></ns2:millis>
                <ns2:sqlDate></ns2:sqlDate>
                <ns2:time></ns2:time>
                <ns2:timestamp></ns2:timestamp>
                <ns2:yearMonth></ns2:yearMonth>
                <ns2:year></ns2:year>
                <ns2:dayOfMonth></ns2:dayOfMonth>
                <ns2:yearMonthDate></ns2:yearMonthDate>
                <ns2:infinite></ns2:infinite>
                <ns2:null></ns2:null>
                <ns2:leapYear></ns2:leapYear>
                <ns2:dayOfYear></ns2:dayOfYear>
            </ns2:endDate>
            <ns2:nextExecutionDate>
                <ns2:dateString></ns2:dateString>
                <ns2:monthDate></ns2:monthDate>
                <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                <ns2:monthDateTime></ns2:monthDateTime>
                <ns2:weekOfYear></ns2:weekOfYear>
                <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                <ns2:sqltimestamp></ns2:sqltimestamp>
                <ns2:month></ns2:month>
                <ns2:dayOfWeek></ns2:dayOfWeek>
                <ns2:millis></ns2:millis>
                <ns2:sqlDate></ns2:sqlDate>
                <ns2:time></ns2:time>
                <ns2:timestamp></ns2:timestamp>
                <ns2:yearMonth></ns2:yearMonth>
                <ns2:year></ns2:year>
                <ns2:dayOfMonth></ns2:dayOfMonth>
                <ns2:yearMonthDate></ns2:yearMonthDate>
                <ns2:infinite></ns2:infinite>
                <ns2:null></ns2:null>
                <ns2:leapYear></ns2:leapYear>
                <ns2:dayOfYear></ns2:dayOfYear>
            </ns2:nextExecutionDate>
            <ns2:instructionAmount>
                <ns2:currency>{fn:data($CTFO/ns1:CTFO_O_0003_0004)}</ns2:currency>
                <ns2:amount>{fn:data($CTFO/ns1:CTFO_O_0003_0003)}</ns2:amount>
            </ns2:instructionAmount>
            <ns2:debitAccountId>{fn:data($CTFO/ns1:CTFO_O_0003_0002)}</ns2:debitAccountId>
            <ns2:branchId>NULL</ns2:branchId>
            <ns2:creditAccountId>{fn:data($CTFO/ns1:CTFO_O_0003_0005)}</ns2:creditAccountId>
            <ns2:creditAccountBranchId>NULL</ns2:creditAccountBranchId>
            <ns2:beneficiaryName>{fn:data($CTFO/ns1:CTFO_O_0003_0006)}</ns2:beneficiaryName>
            <ns2:remarks>{fn:data($CTFO/ns1:CTFO_O_0003_0009)}</ns2:remarks>
            <ns2:status>{fn:data($CTFO/ns1:CTFO_O_0003_0013)}</ns2:status>
            <ns2:purposeId>NULL</ns2:purposeId>
            <ns2:frequency>
                <ns2:days></ns2:days>
                <ns2:months></ns2:months>
                <ns2:years></ns2:years>
            </ns2:frequency>
            <ns2:paymentDetailsList>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:valueDate>
                    <ns2:dateString></ns2:dateString>
                    <ns2:monthDate></ns2:monthDate>
                    <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                    <ns2:monthDateTime></ns2:monthDateTime>
                    <ns2:weekOfYear></ns2:weekOfYear>
                    <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                    <ns2:sqltimestamp></ns2:sqltimestamp>
                    <ns2:month></ns2:month>
                    <ns2:dayOfWeek></ns2:dayOfWeek>
                    <ns2:millis></ns2:millis>
                    <ns2:sqlDate></ns2:sqlDate>
                    <ns2:time></ns2:time>
                    <ns2:timestamp></ns2:timestamp>
                    <ns2:yearMonth></ns2:yearMonth>
                    <ns2:year></ns2:year>
                    <ns2:dayOfMonth></ns2:dayOfMonth>
                    <ns2:yearMonthDate></ns2:yearMonthDate>
                    <ns2:infinite></ns2:infinite>
                    <ns2:null></ns2:null>
                    <ns2:leapYear></ns2:leapYear>
                    <ns2:dayOfYear></ns2:dayOfYear>
                </ns2:valueDate>
                <ns2:status>{fn:data($CTFO/ns1:CTFO_O_0003_0013)}</ns2:status>
                <ns2:failureReason></ns2:failureReason>
            </ns2:paymentDetailsList>
        </ns2:instructions>
        }
        </ns2:data>
    </ns2:Response>
};

local:func($UserIdVar,$INSTRUCTION_LIST)