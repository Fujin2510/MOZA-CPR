xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/hiop";
(:: import schema at "../XSD/HIOP.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/cz_outward_remittance_list";
(:: import schema at "../XSD/CZ_OUTWARD_REMITTANCE_LIST.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:station></ns2:station>
        <ns2:version>R30</ns2:version>
        <ns2:system></ns2:system>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:application></ns2:application>
        <ns2:encryption></ns2:encryption>
        <ns2:language></ns2:language>
        <ns2:transactionCode>HIOP</ns2:transactionCode>
        <ns2:origin>P</ns2:origin>
        <ns2:channelOperationLogKey></ns2:channelOperationLogKey>
        <ns2:coreLogKey></ns2:coreLogKey>
        <ns2:coreCancelationCode></ns2:coreCancelationCode>
        <ns2:event></ns2:event>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:url></ns2:url>
        <ns2:operationData>
            <ns2:HIOP_I_0008>{' '}</ns2:HIOP_I_0008>
                      <ns2:HIOP_I_0001>{
                let $toDate := fn:normalize-space($Request/ns1:fromDate/ns1:dateString)
                return
                  if ($toDate != '') then
                    substring($toDate, 1, 8)  (: Take only yyyyMMdd :)
                 else
      let $sevenDaysAgo := fn:current-date() - xs:dayTimeDuration("P7D")
      let $currDate := fn:string($sevenDaysAgo)
      return concat(
        substring($currDate, 1, 4),  (: Year :)
        substring($currDate, 6, 2),  (: Month :)
        substring($currDate, 9, 2)   (: Day :)
      )
}</ns2:HIOP_I_0001>
            <ns2:HIOP_I_0002>000000000</ns2:HIOP_I_0002>
            <ns2:HIOP_I_0004>{' '}</ns2:HIOP_I_0004>
            <ns2:HIOP_I_0005>{
              let $pt := $Request/ns1:paymentType
              return
                if ($pt and fn:string($pt) != '') then fn:string($pt)
                else ' '
            }</ns2:HIOP_I_0005>
            <ns2:HIOP_I_00021>{' '}</ns2:HIOP_I_00021>
     <ns2:HIOP_I_0003>{
  let $fromDate := fn:normalize-space($Request/ns1:toDate/ns1:dateString)
  return
    if ($fromDate != '') then
      substring($fromDate, 1, 8)  (: Take only the yyyyMMdd part :)

   else
                    let $currDate := fn:string(fn:current-date())
                    return concat(
                      substring($currDate, 1, 4),  (: Year :)
                      substring($currDate, 6, 2),  (: Month :)
                      substring($currDate, 9, 2)   (: Day :)
                    )
              }


</ns2:HIOP_I_0003>
          <ns2:HIOP_I_0006>     {
          let $acct := fn:data($Request/ns1:accountList)
         return
          if (contains($acct, "@~")) then
           substring-after($acct, "@~")
          else
           $acct
         }</ns2:HIOP_I_0006>
            <ns2:HIOP_I_0007>{' '}</ns2:HIOP_I_0007>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request)