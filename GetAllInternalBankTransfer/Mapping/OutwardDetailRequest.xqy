xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/outward_remittance_details";
(:: import schema at "../XSD/OUTWARD_REMITTANCE_DETAILS.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;
declare variable $accountId as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string,$accountIdas as xs:string) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{$userIdVar}</ns2:user>
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
            <ns2:CTFI_I_0004>{' '}</ns2:CTFI_I_0004>
            <ns2:CTFI_I_0005>{' '}</ns2:CTFI_I_0005>
<ns2:CTFI_I_0006>{
  let $today := current-date()
  let $year := string(year-from-date($today))
  let $month := month-from-date($today)
  let $monthStr := if ($month lt 10) then concat('0', $month) else string($month)
  return concat($year, $monthStr, '01')
}</ns2:CTFI_I_0006>

<ns2:CTFI_I_0007>{
  let $today := current-date()
  let $year := string(year-from-date($today))
  let $month := month-from-date($today)
  let $day := day-from-date($today)
  let $monthStr := if ($month lt 10) then concat('0', $month) else string($month)
  let $dayStr := if ($day lt 10) then concat('0', $day) else string($day)
  return concat($year, $monthStr, $dayStr)
}</ns2:CTFI_I_0007>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request,$userIdVar,$accountId)