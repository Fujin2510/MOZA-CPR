xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/ctfi";
(:: import schema at "../XSD/CTFI.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/outward_remittance_details";
(:: import schema at "../XSD/OUTWARD_REMITTANCE_DETAILS.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $userIdVar as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$userIdVar as xs:string) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
          <ns2:status>  {
                    if (fn:data($Response/ns1:errorCode) = '0')
                    then 'SUCCESS'
                    else 'FAILURE'
                  }</ns2:status>                
            {if(fn:data($Response/ns1:errorCode) = '0') then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>) } 
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            {
            for $tx in $Response/ns1:operationData/ns1:CTFI_O_0003
return
            <ns2:outwardRemittanceDetails>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:partyId>{$userIdVar}</ns2:partyId>
                <ns2:paymentDate>{fn:data($tx/ns1:CTFI_O_0003_0009)}</ns2:paymentDate>
                <ns2:purposeId>NULL</ns2:purposeId>
                <ns2:remarks>{fn:data($tx/ns1:CTFI_O_0003_0007)}</ns2:remarks>
                <ns2:exchangeRate></ns2:exchangeRate>
                <ns2:transactionAmount>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:amount>{concat(fn:data($tx/ns1:CTFI_O_0003_0005), '.00')}</ns2:amount>
                </ns2:transactionAmount>
                <ns2:debitAccount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:accountId>{fn:data($tx/ns1:CTFI_O_0003_0002)}</ns2:accountId>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:bankCode>34</ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:iban></ns2:iban>
                </ns2:debitAccount>
                <ns2:creditAccount>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:accountId>{fn:data($tx/ns1:CTFI_O_0003_0003)}</ns2:accountId>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:bankCode>34</ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:iban></ns2:iban>
                </ns2:creditAccount>
                <ns2:txnReferenceId>{fn:data($tx/ns1:CTFI_O_0003_0001)}</ns2:txnReferenceId>
                <ns2:paymentStatus>{fn:data($tx/ns1:CTFI_O_0003_0012)}</ns2:paymentStatus>
                <ns2:paymentType>Internal</ns2:paymentType>
                <ns2:networkCode></ns2:networkCode>
                <ns2:fundReceivedDate>{fn:data($tx/ns1:CTFI_O_0003_0009)}</ns2:fundReceivedDate>
                <ns2:fundCreditedDate>{fn:data($tx/ns1:CTFI_O_0003_0009)}</ns2:fundCreditedDate>
                <ns2:orderingPartyId>{$userIdVar}</ns2:orderingPartyId>
                <ns2:debitAmount>
                    <ns2:currency>{fn:data($tx/ns1:CTFI_O_0003_0006)}</ns2:currency>
                    <ns2:amount>{concat(fn:data($tx/ns1:CTFI_O_0003_0005), '.00')}</ns2:amount>
                </ns2:debitAmount>
                <ns2:payeeName>{fn:data($tx/ns1:CTFI_O_0003_0004)}</ns2:payeeName>
                <ns2:payeeBankName>MOZA BANCO</ns2:payeeBankName>
                <ns2:payeeAddress>
                    <ns2:line1></ns2:line1>
                    <ns2:line2></ns2:line2>
                    <ns2:line3></ns2:line3>
                    <ns2:line4></ns2:line4>
                    <ns2:line5></ns2:line5>
                    <ns2:line6></ns2:line6>
                    <ns2:line7></ns2:line7>
                    <ns2:line8></ns2:line8>
                    <ns2:line9></ns2:line9>
                    <ns2:line10></ns2:line10>
                    <ns2:line11></ns2:line11>
                    <ns2:line12></ns2:line12>
                    <ns2:city></ns2:city>
                    <ns2:addressTypeDescription></ns2:addressTypeDescription>
                    <ns2:state></ns2:state>
                    <ns2:country></ns2:country>
                    <ns2:zipCode></ns2:zipCode>
                </ns2:payeeAddress>
                 <ns2:messageList>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:referenceNumber></ns2:referenceNumber>
                    <ns2:dcnNo></ns2:dcnNo>
                    <ns2:messageType></ns2:messageType>
                    <ns2:description></ns2:description>
                </ns2:messageList>
                <ns2:adviceList>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:referenceNumber></ns2:referenceNumber>
                    <ns2:dcnNo></ns2:dcnNo>
                    <ns2:messageType></ns2:messageType>
                    <ns2:description></ns2:description>
                </ns2:adviceList>
                <ns2:intermediaryBankCode></ns2:intermediaryBankCode>
                <ns2:intermediaryBankName></ns2:intermediaryBankName>
                <ns2:customerRefNo>{fn:data($tx/ns1:CTFI_O_0003_0001)}</ns2:customerRefNo>
                <ns2:intermediaryBankAddress>
                    <ns2:line1></ns2:line1>
                    <ns2:line2></ns2:line2>
                    <ns2:line3></ns2:line3>
                    <ns2:line4></ns2:line4>
                    <ns2:line5></ns2:line5>
                    <ns2:line6></ns2:line6>
                    <ns2:line7></ns2:line7>
                    <ns2:line8></ns2:line8>
                    <ns2:line9></ns2:line9>
                    <ns2:line10></ns2:line10>
                    <ns2:line11></ns2:line11>
                    <ns2:line12></ns2:line12>
                    <ns2:city></ns2:city>
                    <ns2:addressTypeDescription></ns2:addressTypeDescription>
                    <ns2:state></ns2:state>
                    <ns2:country></ns2:country>
                    <ns2:zipCode></ns2:zipCode>
                </ns2:intermediaryBankAddress>
                <ns2:uniqueEndToEndTxnReference>{fn:data($tx/ns1:CTFI_O_0003_0001)}</ns2:uniqueEndToEndTxnReference>
                <ns2:initiationDate></ns2:initiationDate>
            </ns2:outwardRemittanceDetails>
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$userIdVar)