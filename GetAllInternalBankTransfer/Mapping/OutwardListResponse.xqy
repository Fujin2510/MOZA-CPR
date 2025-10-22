xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/outward_remittance_list";
(:: import schema at "../XSD/OUTWARD_REMITTANCE_LIST.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $userIdVariable as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$userIdVariable) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:result>
          <ns2:status>  {
                    if (fn:data($Response/ns1:errorCode) = '0')
                    then 'SUCCESS'
                    else 'FAILURE'
                  }</ns2:status>              
            </ns2:result>
            {
  for $tx in $Response/ns1:operationData/ns1:CTFI_O_0003
  return
            <ns2:outwardremittances>
<ns2:fundReceivedDate>
  {
    let $rawDate := fn:data($tx/ns1:CTFI_O_0003_0009)
    return concat(
      substring($rawDate, 1, 4), "-",  
      substring($rawDate, 5, 2), "-",
      substring($rawDate, 7, 2)
    )
  }
</ns2:fundReceivedDate>
                <ns2:fundCreditedDate>{fn:data($tx/ns1:CTFI_O_0003_0009)}</ns2:fundCreditedDate>
                <ns2:orderingPartyId>{$userIdVariable}</ns2:orderingPartyId>
                <ns2:debitAmount>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:amount>{concat(fn:data($tx/ns1:CTFI_O_0003_0005), '.00')}</ns2:amount>
                </ns2:debitAmount>
                <ns2:payeeName>{fn:data($tx/ns1:CTFI_O_0003_0004)}</ns2:payeeName>
                <ns2:payeeBankName>MOZA BANCO</ns2:payeeBankName>
                <ns2:payeeAddress>
                    <ns2:line1></ns2:line1>
                    <ns2:line2></ns2:line2>
                    <ns2:city></ns2:city>
                    <ns2:state></ns2:state>
                    <ns2:country></ns2:country>
                </ns2:payeeAddress>
                <ns2:partyId>{$userIdVariable}</ns2:partyId>
                <ns2:paymentDate>{fn:data($tx/ns1:CTFI_O_0003_0009)}</ns2:paymentDate>
                <ns2:purposeId>NULL</ns2:purposeId>
                <ns2:remarks>{fn:data($tx/ns1:CTFI_O_0003_0009)}</ns2:remarks>
                 <ns2:transactionAmount>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:amount>{concat(fn:data($tx/ns1:CTFI_O_0003_0005), '.00')}</ns2:amount>
                </ns2:transactionAmount>
                <ns2:debitAccount>
                    <ns2:accountId>{fn:data($tx/ns1:CTFI_O_0003_0002)}</ns2:accountId>
                    <ns2:bankCode>34</ns2:bankCode>
                    <ns2:branchCode>NULL</ns2:branchCode>
                    <ns2:currency>MZ</ns2:currency>
                </ns2:debitAccount>
                <ns2:creditAccount>
                    <ns2:accountId>{fn:data($tx/ns1:CTFI_O_0003_0003)}</ns2:accountId>
                    <ns2:bankCode>34</ns2:bankCode>
                    <ns2:branchCode>NULL</ns2:branchCode>
                    <ns2:currency>MZ</ns2:currency>
                </ns2:creditAccount>
                <ns2:txnReferenceId>{fn:data($tx/ns1:CTFI_O_0003_0001)}</ns2:txnReferenceId>
                <ns2:paymentStatus>{fn:data($tx/ns1:CTFI_O_0003_0012)}</ns2:paymentStatus>
                <ns2:paymentType>Internal</ns2:paymentType>
            </ns2:outwardremittances>
            }
        </ns2:data>
        <ns2:messages>
            <ns2:keyId></ns2:keyId>
            <ns2:status></ns2:status>
            <ns2:codes></ns2:codes>
             <ns2:requestId></ns2:requestId>
            <ns2:httpStatusCode></ns2:httpStatusCode>
            <ns2:overrideAuthLevelsReqd></ns2:overrideAuthLevelsReqd>
        </ns2:messages>
    </ns2:Response>
};

local:func($Response,$userIdVariable)