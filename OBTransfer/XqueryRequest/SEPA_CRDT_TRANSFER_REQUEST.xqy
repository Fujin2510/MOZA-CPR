xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/instantTransfer";
(:: import schema at "../Schema/InstantTransfer.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/obdx/SepaCreditTransfer";
(:: import schema at "../Schema/SEPA_CREDIT_TRANSFER.xsd" ::)

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare function local:yyyymmdd-from-date($d as xs:date) as xs:string {
  fn:translate(xs:string($d), '-', '')
};
declare function local:func($Request as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($Request/ns1:partyId)}</ns2:user>
        <ns2:password>{' '}</ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>PTFZ</ns2:transactionCode>
        <ns2:operationData>
           <ns2:PTFZ_I_0001>{
    let $acct := fn:data($Request/ns1:debitAccountId)
    return
      if (contains($acct, "@~")) then
        substring-after($acct, "@~")
      else
        $acct
  }</ns2:PTFZ_I_0001>
         <ns2:PTFZ_I_0002>{xs:integer(xs:decimal(fn:data($Request/ns1:amount/ns1:amount)) * 100)}</ns2:PTFZ_I_0002>
            <ns2:PTFZ_I_0003>{fn:data($Request/ns1:amount/ns1:currency)}</ns2:PTFZ_I_0003>
            <ns2:PTFZ_I_0004>{fn:data($Request/ns1:domesticBeneficiary/ns1:accountId)}</ns2:PTFZ_I_0004>
            <ns2:PTFZ_I_0005>{fn:data($Request/ns1:domesticBeneficiary/ns1:accountName)}</ns2:PTFZ_I_0005>
            <ns2:PTFZ_I_0006>{fn:data($Request/ns1:remarks)}</ns2:PTFZ_I_0006>
            <ns2:PTFZ_I_0007>E</ns2:PTFZ_I_0007>
            <ns2:PTFZ_I_0008>{
              let $dateStr := fn:data($Request/ns1:paymentDate/ns1:dateString)
              return
                if (normalize-space($dateStr) != '') 
                then substring($dateStr, 1, 8) 
                else ' '
            }</ns2:PTFZ_I_0008>
            <ns2:PTFZ_I_0009>{' '}</ns2:PTFZ_I_0009>
          <ns2:PTFZ_I_0010>{' '}</ns2:PTFZ_I_0010>
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
         <ns2:PTFZ_I_0012>{' '}</ns2:PTFZ_I_0012>
          <ns2:PTFZ_I_0013>12</ns2:PTFZ_I_0013>
        </ns2:operationData>
    </ns2:Request>
};

local:func($Request)