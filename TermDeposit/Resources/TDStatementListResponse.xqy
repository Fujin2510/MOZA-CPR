xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/TD_STATEMENT_ITEM_LIST";
(:: import schema at "TDStatementItemList.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CMOV";
(:: import schema at "../../GetCreditCardStatement/Schema/CMOV.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";
declare variable $CMOVResponse as element() (:: schema-element(ns1:CMOVResponse) ::) external;

declare function local:func($CMOVResponse as element() (:: schema-element(ns1:CMOVResponse) ::)) as element() (:: schema-element(ns2:TDStatementItemListResponse) ::) {
let $errCode := xs:string(fn:data($CMOVResponse/*:errorCode)) return
    <ns2:TDStatementItemListResponse>
      
        <ns2:data>
           <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
               <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($errCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CMOVResponse/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CMOVResponse/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
			</ns2:errorList>)
                 else if($errCode = '906' or $errCode = 'A') then 
                (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
			</ns2:errorList>)
                 else(
			<ns2:errorList>
				<ns2:code>ERR001</ns2:code>
				<ns2:message>Invalid backend response</ns2:message>
			</ns2:errorList>)
			}
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        {
                 if( $errCode = '0') then
            for $CMOV_O_0011 at $pos in $CMOVResponse/ns1:operationData/ns1:CMOV_O_0011
            return 
            <ns2:statementItemList>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:accountId>{fn:data($CMOVResponse/ns1:operationData/ns1:CMOV_O_0001)}</ns2:accountId>
                <ns2:externalReferenceId>{fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0018)}</ns2:externalReferenceId>
                <ns2:branchId></ns2:branchId>
                <ns2:transactionType>{if(fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0007) = '+') then 'C' else 'D'}</ns2:transactionType>
                <ns2:amount>
                    <ns2:currency>{fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0008)}</ns2:currency>
                    <ns2:amount>{fn-bea:format-number(fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0006) div 100, '0.00')}</ns2:amount>
                </ns2:amount>
                <ns2:date>
                    <ns2:dateString>{let $dateString := fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0001) return concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2),'T00:00:00')}</ns2:dateString>
                    <ns2:sqlDate></ns2:sqlDate>
                    <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                    <ns2:monthDate></ns2:monthDate>
                    <ns2:monthDateTime></ns2:monthDateTime>
                    <ns2:weekOfYear></ns2:weekOfYear>
                    <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                    <ns2:sqltimestamp></ns2:sqltimestamp>
                    <ns2:year></ns2:year>
                    <ns2:dayOfMonth></ns2:dayOfMonth>
                    <ns2:leapYear></ns2:leapYear>
                    <ns2:dayOfYear></ns2:dayOfYear>
                    <ns2:time></ns2:time>
                    <ns2:timestamp></ns2:timestamp>
                    <ns2:month></ns2:month>
                    <ns2:dayOfWeek></ns2:dayOfWeek>
                    <ns2:millis></ns2:millis>
                    <ns2:yearMonth></ns2:yearMonth>
                    <ns2:yearMonthDate></ns2:yearMonthDate>
                    <ns2:infinite></ns2:infinite>
                    <ns2:null></ns2:null>
                </ns2:date>
                <ns2:description>{fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0005)}</ns2:description>
                <ns2:valueDate>
                    <ns2:dateString>{let $dateString := fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0014) return concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2),'T00:00:00')}</ns2:dateString>
                    <ns2:sqlDate></ns2:sqlDate>
                    <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                    <ns2:monthDate></ns2:monthDate>
                    <ns2:monthDateTime></ns2:monthDateTime>
                    <ns2:weekOfYear></ns2:weekOfYear>
                    <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                    <ns2:sqltimestamp></ns2:sqltimestamp>
                    <ns2:year></ns2:year>
                    <ns2:dayOfMonth></ns2:dayOfMonth>
                    <ns2:leapYear></ns2:leapYear>
                    <ns2:dayOfYear></ns2:dayOfYear>
                    <ns2:time></ns2:time>
                    <ns2:timestamp></ns2:timestamp>
                    <ns2:month></ns2:month>
                    <ns2:dayOfWeek></ns2:dayOfWeek>
                    <ns2:millis></ns2:millis>
                    <ns2:yearMonth></ns2:yearMonth>
                    <ns2:yearMonthDate></ns2:yearMonthDate>
                    <ns2:infinite></ns2:infinite>
                    <ns2:null></ns2:null>
                </ns2:valueDate>
                <ns2:creditAccountId></ns2:creditAccountId>
                <ns2:postingDate>
                    <ns2:dateString>{let $dateString := fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0001) return concat(substring($dateString, 1, 4), '-', substring($dateString, 5, 2), '-', substring($dateString, 7, 2),'T00:00:00')}</ns2:dateString>
                    <ns2:sqlDate></ns2:sqlDate>
                    <ns2:calendarDayOfWeek></ns2:calendarDayOfWeek>
                    <ns2:monthDate></ns2:monthDate>
                    <ns2:monthDateTime></ns2:monthDateTime>
                    <ns2:weekOfYear></ns2:weekOfYear>
                    <ns2:lastDayOfMonth></ns2:lastDayOfMonth>
                    <ns2:sqltimestamp></ns2:sqltimestamp>
                    <ns2:year></ns2:year>
                    <ns2:dayOfMonth></ns2:dayOfMonth>
                    <ns2:leapYear></ns2:leapYear>
                    <ns2:dayOfYear></ns2:dayOfYear>
                    <ns2:time></ns2:time>
                    <ns2:timestamp></ns2:timestamp>
                    <ns2:month></ns2:month>
                    <ns2:dayOfWeek></ns2:dayOfWeek>
                    <ns2:millis></ns2:millis>
                    <ns2:yearMonth></ns2:yearMonth>
                    <ns2:yearMonthDate></ns2:yearMonthDate>
                    <ns2:infinite></ns2:infinite>
                    <ns2:null></ns2:null>
                </ns2:postingDate>
                <ns2:subSequenceNumber>{$pos}</ns2:subSequenceNumber>
                <ns2:creditDebitFlag>{if(fn:data($CMOV_O_0011/ns1:CMOV_O_0011_0007) = '+') then 'C' else 'D'}</ns2:creditDebitFlag>
            </ns2:statementItemList>
            else()
            }
        </ns2:data>
    </ns2:TDStatementItemListResponse>
};

local:func($CMOVResponse)