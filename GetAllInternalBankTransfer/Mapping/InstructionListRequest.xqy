xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/instruction_list";
(:: import schema at "../XSD/INSTRUCTION_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $accountId as xs:string external;
declare variable $externalStatus as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$accountId,$externalStatus) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password>{''}</ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CTFI</ns2:transactionCode>
        <ns2:operationData>
   <ns2:CTFI_I_0001>
{
  let $acct := fn:data($Request/ns1:accountList)
  return
    if (fn:exists($acct) and $acct != "") then
      if (contains($acct, "@~")) then
        substring-after($acct, "@~")
      else
        $acct
    else
      substring-after($accountId, "@~")
}
</ns2:CTFI_I_0001>
            <ns2:CTFI_I_0002>20</ns2:CTFI_I_0002>
            <ns2:CTFI_I_0004>P</ns2:CTFI_I_0004>
<ns2:CTFI_I_0005>{
    if (normalize-space($Request/ns1:accountList) != '') then
        (if ($Request/ns1:status = 'ACTIVE') then 'A'
         else if ($Request/ns1:status = 'CANCELLED') then 'I'
         else ' ')
    else
        (  if (normalize-space($externalStatus) = '') then ' '
    else if ($externalStatus = 'ACTIVE') then 'A'
    else if ($externalStatus = 'CANCELLED') then 'I'
    else ' ')
}</ns2:CTFI_I_0005>         
           <ns2:CTFI_I_0006>{
(:
  let $raw := $Request/ns1:endDate
  let $isNull := not(exists($raw)) 
                 or $raw/@xsi:nil = "true" 
                 or normalize-space(string($raw)) = ''
  return
    if (not($isNull)) then
      substring(string($raw), 1, 8)
    else :)
      let $to := current-date()
      let $year := string(year-from-date($to))
      let $month := month-from-date($to)
      let $day := day-from-date($to)
      let $monthStr := if ($month lt 10) then concat('0', $month) else string($month)
      let $dayStr := if ($day lt 10) then concat('0', $day) else string($day)
      return concat($year, $monthStr, $dayStr)
}</ns2:CTFI_I_0006>

          <ns2:CTFI_I_0007>{
         (: let $raw := $Request/ns1:startDate
          let $isNull := not(exists($raw)) or $raw/@xsi:nil = "true" or normalize-space(string($raw)) = ''
          return
            if (not($isNull)) then
              substring(string($raw), 1, 8)
            else :)
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

local:func($Request,$accountId,$externalStatus)