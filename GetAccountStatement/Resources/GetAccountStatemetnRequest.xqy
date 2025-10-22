xquery version "1.0" encoding "utf-8";
 
(:: OracleAnnotationVersion "1.0" ::)
 
declare namespace ns2 = "http://www.mozabanca.org/CMOV";

(:: import schema at "CMOV.xsd" ::)

declare namespace ns1 = "http://www.mozabank.org/casa_statement_item_list";

(:: import schema at "CASA_STATEMENT_ITEM_LIST.xsd" ::)
 
declare variable $partyIdVar as xs:string external;

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
 
declare function local:func(

  $Request as element() (:: schema-element(ns1:Request) ::),

  $partyIdVar as xs:string

) as element() (:: schema-element(ns2:Request) ::) {
<ns2:Request>
<ns2:user>{$partyIdVar}</ns2:user>
<ns2:password></ns2:password>
<ns2:origin>P</ns2:origin>
<ns2:channelCode>INT</ns2:channelCode>
<ns2:version>R30</ns2:version>
<ns2:licenceKey>licenseKey</ns2:licenceKey>
<ns2:sessionId>00000000</ns2:sessionId>
<ns2:transactionCode>CMOV</ns2:transactionCode>
<ns2:operationData>
<ns2:CMOV_I_0001>{fn:data($Request/ns1:accountId)}</ns2:CMOV_I_0001>
<ns2:CMOV_I_0002>

      {

        let $fromDateStr := fn:normalize-space($Request/ns1:fromDate)

        let $toDateStr := fn:normalize-space($Request/ns1:toDate)

        return

          if ($fromDateStr = '' and $toDateStr = '') then '5'

          else '20'

      }
</ns2:CMOV_I_0002>
<ns2:CMOV_I_0003>-</ns2:CMOV_I_0003>
<ns2:CMOV_I_0004>{

        let $value := fn:normalize-space($Request/ns1:transactionType)

        return

          if ($value = 'D') then 'DEB'

          else if ($value = 'C') then 'CRE'

          else if ($value != '' or not($value)) then 'ALL'

          else ()

      }</ns2:CMOV_I_0004>
<ns2:CMOV_I_0005>

      {

        let $fromDateStr := fn:normalize-space($Request/ns1:fromDate)

        let $toDateStr := fn:normalize-space($Request/ns1:toDate)

        return

          if ($fromDateStr = '' and $toDateStr = '') then
              '00000000'
          else

            let $dateString := fn:data($Request/ns1:fromDate)

            let $date := xs:date($dateString)

           

            return concat(

              substring(string($date), 1, 4),

              substring(string($date), 6, 2),

              substring(string($date), 9, 2)

            )

      }
</ns2:CMOV_I_0005>
<ns2:CMOV_I_0006></ns2:CMOV_I_0006>
<ns2:CMOV_I_0007>

      {

        let $fromDateStr := fn:normalize-space($Request/ns1:fromDate)

        let $toDateStr := fn:normalize-space($Request/ns1:toDate)

        return

          if ($fromDateStr = '' and $toDateStr = '') then

            let $d := fn:current-date()

            return concat(

              substring(string($d), 1, 4),

              substring(string($d), 6, 2),

              substring(string($d), 9, 2)

            )

          else

            let $dateString := fn:data($Request/ns1:toDate)

            return concat(

              substring($dateString, 1, 4),

              substring($dateString, 6, 2),

              substring($dateString, 9, 2)

            )

      }
</ns2:CMOV_I_0007>
<ns2:CMOV_I_9998></ns2:CMOV_I_9998>
<ns2:CMOV_I_9999></ns2:CMOV_I_9999>
</ns2:operationData>
</ns2:Request>

};
 
local:func($Request, $partyIdVar)