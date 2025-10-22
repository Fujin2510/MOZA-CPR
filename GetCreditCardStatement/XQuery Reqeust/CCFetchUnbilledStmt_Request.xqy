xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CMOV";
(:: import schema at "../Schema/CMOV.xsd" ::)
declare namespace ns1="http://www.mozabank.org/emitir_extractos";
(:: import schema at "../Schema/CC_FETCH_UNBILLED_STMT.xsd" ::)

declare variable $CCFetchUnbilledStmt_Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string  external;
declare variable $accountIdVar as xs:string external;

declare function local:func($CCFetchUnbilledStmt_Request as element() (:: schema-element(ns1:Request) ::),$userIdVar,$accountIdVar) as element() (:: schema-element(ns2:CMOVRequest) ::) {

let $todayDate := current-date()
let $cutoffDate := $todayDate - xs:dayTimeDuration("P90D")
let $monthToday := if (month-from-date($todayDate) lt 10) then concat('0', month-from-date($todayDate)) else string(month-from-date($todayDate))
let $dayToday := if (day-from-date($todayDate) lt 10) then concat('0', day-from-date($todayDate)) else string(day-from-date($todayDate))

let $monthCutoff := if (month-from-date($cutoffDate) lt 10) then concat('0', month-from-date($cutoffDate)) else string(month-from-date($cutoffDate))
let $dayCutoff := if (day-from-date($cutoffDate) lt 10) then concat('0', day-from-date($cutoffDate)) else string(day-from-date($cutoffDate))

let $todayFormatted := concat(year-from-date($todayDate), $monthToday, $dayToday)
let $cutoffFormatted := concat(year-from-date($cutoffDate), $monthCutoff, $dayCutoff)

return
    <ns2:CMOVRequest>
        <ns2:user>{$userIdVar} </ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CMOV</ns2:transactionCode>
        <ns2:operationData>
             <ns2:CMOV_I_0001>{$accountIdVar}</ns2:CMOV_I_0001>
            <ns2:CMOV_I_0002>20</ns2:CMOV_I_0002>
            <ns2:CMOV_I_0003>-</ns2:CMOV_I_0003>
            <ns2:CMOV_I_0004>ALL</ns2:CMOV_I_0004>
            <ns2:CMOV_I_0005>{$todayFormatted}</ns2:CMOV_I_0005>
            <ns2:CMOV_I_0006></ns2:CMOV_I_0006>
            <ns2:CMOV_I_0007>{$cutoffFormatted}</ns2:CMOV_I_0007>
            <ns2:CMOV_I_9998></ns2:CMOV_I_9998>
            <ns2:CMOV_I_9999></ns2:CMOV_I_9999>
        </ns2:operationData>
    </ns2:CMOVRequest>
};

local:func($CCFetchUnbilledStmt_Request,$userIdVar,$accountIdVar)