xquery version "1.0" encoding "utf-8";
 
(:: OracleAnnotationVersion "1.0" ::)
 
declare namespace ns2="http://www.mozabanca.org/MAPP";

(:: import schema at "../Schemas/MAPP.xsd" ::)

declare namespace ns1="http://www.mozabank.org/td_redeem";

(:: import schema at "../Schemas/TD_REDEEM.xsd" ::)
 
declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
 
declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
<ns2:Request>
<ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
<ns2:password></ns2:password>
<ns2:origin>P</ns2:origin>
<ns2:channelCode>INT</ns2:channelCode>
<ns2:version>R30</ns2:version>
<ns2:licenceKey>licenseKey</ns2:licenceKey>
<ns2:sessionId>00000000</ns2:sessionId>
<ns2:transactionCode>MAPP</ns2:transactionCode>
<ns2:operationData>
<ns2:MAPP_I_0001>{fn:data($Request/ns1:accountId)}</ns2:MAPP_I_0001>
<ns2:MAPP_I_0002>{fn:data($Request/ns1:tdRedeemPayoutDetails/ns1:offsetAccountId)}</ns2:MAPP_I_0002>
<ns2:MAPP_I_0003>{
  xs:integer(fn:data($Request/ns1:tdRedeemPayoutDetails/ns1:redemptionAmount/ns1:amount) * 100)
}</ns2:MAPP_I_0003>

<ns2:MAPP_I_0004>{fn:data($Request/ns1:tdRedeemPayoutDetails/ns1:redemptionAmount/ns1:currency)}</ns2:MAPP_I_0004>

{
              let $date := current-date()
              
              let $year := string(year-from-date($date))
              let $month := string(month-from-date($date))
              let $day := string(day-from-date($date))
              
              let $paddedMonth := 
                if (string-length($month) = 1) then concat("0", $month) else $month
              
              let $paddedDay := 
                if (string-length($day) = 1) then concat("0", $day) else $day
              
              let $formattedDate := concat($year, $paddedMonth, $paddedDay)
              
              return
                <ns2:MAPP_I_0005>{$formattedDate}</ns2:MAPP_I_0005>
        }
</ns2:operationData>
<ns2:validation>
<ns2:confirmationKey>
<ns2:digitValues></ns2:digitValues>
<ns2:digitPositions></ns2:digitPositions>
</ns2:confirmationKey>
</ns2:validation>
</ns2:Request>

};
 
local:func($Request)