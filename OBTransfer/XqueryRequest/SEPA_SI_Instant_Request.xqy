xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/instantTransfer";
(:: import schema at "../Schema/InstantTransfer.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/SepaSI";
(:: import schema at "../Schema/SEPA_SI.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{ $userIdVar }</ns2:user>
        <ns2:password>{' '}</ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>PTFZ</ns2:transactionCode>
        <ns2:operationData>
           <ns2:PTFZ_I_0001>{
    let $acct := fn:data($Request/ns1:drAcNo)
    return
      if (contains($acct, "@~")) then
        substring-after($acct, "@~")
      else
        $acct
  }</ns2:PTFZ_I_0001>
            <ns2:PTFZ_I_0002>{xs:integer(xs:decimal(fn:data($Request/ns1:transferAmt)) * 100)}</ns2:PTFZ_I_0002>
            <ns2:PTFZ_I_0003>{fn:data($Request/ns1:transferCcy)}</ns2:PTFZ_I_0003>
            <ns2:PTFZ_I_0004>{fn:data($Request/ns1:crAcNo)}</ns2:PTFZ_I_0004>
            <ns2:PTFZ_I_0005>{fn:data($Request/ns1:crName)}</ns2:PTFZ_I_0005>
            <ns2:PTFZ_I_0006>{fn:data($Request/ns1:remarks)}</ns2:PTFZ_I_0006>
            <ns2:PTFZ_I_0007>P</ns2:PTFZ_I_0007>
            <ns2:PTFZ_I_0008>{
            let $sd := substring(fn:data($Request/ns1:instructiondetails/ns1:startDate/ns1:dateString),1,8)
            return
              if (normalize-space($sd) != '') 
              then $sd
              else ' '
          }</ns2:PTFZ_I_0008>          
          <ns2:PTFZ_I_0009>{
            let $ed := substring(fn:data($Request/ns1:instructiondetails/ns1:endDate/ns1:dateString),1,8)
            return
              if (normalize-space($ed) != '') 
              then replace($ed, "-", "") 
              else ' '
          }</ns2:PTFZ_I_0009>
              <ns2:PTFZ_I_0010>{
            let $code := $Request/ns1:instructiondetails/ns1:frequencyCode
            let $no := xs:integer($Request/ns1:instructiondetails/ns1:frequencyNo)
            return
             if ($code = 'D' and $no = 1) then 'D'
              else if ($code = 'W' and $no = 1) then 'W'
              else if ($code = 'W' and $no = 2) then 'Q'
              else if ($code = 'M' and $no = 1) then 'M'
              else if ($code = 'M' and $no = 2) then 'I'
              else if ($code = 'M' and $no = 3) then 'T'
              else if ($code = 'M' and $no = 6) then 'S'
              else if ($code = 'M' and $no = 12) then 'Y'
              else ''
          }</ns2:PTFZ_I_0010>
<ns2:PTFZ_I_0011>{
  let $email := fn:data(
                  $Request/ns1:dictionaryArray/ns1:nameValuePairArray
                  [ns1:genericName = 'com.finonyx.digx.cz.domain.payment.entity.network.CZNetworkPayment.PayeeEmailId' 
                   or ns1:genericName = 'com.finonyx.digx.cz.domain.payment.entity.network.CZNetworkPaymentInstruction.PayeeEmailId']
                  /ns1:value
                )
  return
    if (normalize-space($email) != '') 
    then $email 
    else ' '
}</ns2:PTFZ_I_0011>
<ns2:PTFZ_I_0012>{' '}
</ns2:PTFZ_I_0012>
            <ns2:PTFZ_I_0013>{' '}</ns2:PTFZ_I_0013>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request, $userIdVar)