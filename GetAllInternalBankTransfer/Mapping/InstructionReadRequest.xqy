xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/instruction_read";
(:: import schema at "../XSD/INSTRUCTION_READ.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accountId as xs:string external;
declare variable $endDate as xs:string external;
declare variable $startDate as xs:string external;
declare variable $status as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accountId,$startDate,$endDate,$status) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CTFI</ns2:transactionCode>
        <ns2:operationData>
<ns2:CTFI_I_0001>
  {substring-after($accountId, "@~")}
</ns2:CTFI_I_0001>
            <ns2:CTFI_I_0002>40</ns2:CTFI_I_0002>
            <ns2:CTFI_I_0004>P</ns2:CTFI_I_0004>
            <ns2:CTFI_I_0005>{' '}</ns2:CTFI_I_0005>
<ns2:CTFI_I_0006>{
 let $startDate := normalize-space($startDate)
  return
    if ($startDate != "") then
      $startDate
   else
  let $to := current-date()
  let $year := string(year-from-date($to))
  let $month := month-from-date($to)
  let $day := day-from-date($to)
  let $monthStr := if ($month lt 10) then concat('0', $month) else string($month)
  let $dayStr := if ($day lt 10) then concat('0', $day) else string($day)
  return concat($year, $monthStr, $dayStr)
}</ns2:CTFI_I_0006>
<ns2:CTFI_I_0007>{
 let $endDate := normalize-space($endDate)
  return
    if ($endDate != "") then
      $endDate
     else
  let $from := current-date() + xs:yearMonthDuration("P6M")
  let $year := string(year-from-date($from))
  let $month := month-from-date($from)
  let $day := day-from-date($from)
  let $monthStr := if ($month lt 10) then concat('0', $month) else string($month)
  let $dayStr := if ($day lt 10) then concat('0', $day) else string($day)
  return concat($year, $monthStr, $dayStr)

}</ns2:CTFI_I_0007>
</ns2:operationData>
    </ns2:Request>
};

local:func($Request,$accountId,$startDate,$endDate,$status)