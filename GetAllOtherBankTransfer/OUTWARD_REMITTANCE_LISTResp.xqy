xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/obdx/CTFO";
(:: import schema at "CTFO.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/OUTWARD_REMITTANCE_LIST";
(:: import schema at "OUTWARD_REMITTANCE_LIST.xsd" ::)

declare variable $CTFOResp as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($CTFOResp as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
    
    <ns2:result>
        <ns2:status>SUCCESS</ns2:status>
    </ns2:result>
    {
            for $CTFO in $CTFOResp/ns1:operationData/ns1:CTFO_O_0003
            return
        <ns2:outwardremittances>
     
                <ns2:fundReceivedDate>{fn:data($CTFO/ns1:CTFO_O_0003_0011)}</ns2:fundReceivedDate>
                <ns2:fundCreditedDate></ns2:fundCreditedDate>
                <ns2:orderingPartyId></ns2:orderingPartyId>
                <ns2:debitAmount>
                    <ns2:amount>{fn:data($CTFO/ns1:CTFO_O_0003_0003)}</ns2:amount>
                    <ns2:currency></ns2:currency>
                </ns2:debitAmount>
                <ns2:payeeName>{fn:data($CTFO/ns1:CTFO_O_0003_0006)}</ns2:payeeName>
                <ns2:payeeBankName></ns2:payeeBankName>
                <ns2:payeeAddress>
                    <ns2:line1></ns2:line1>
                    <ns2:line2></ns2:line2>
                    <ns2:city></ns2:city>
                    <ns2:state></ns2:state>
                    <ns2:country></ns2:country>
                </ns2:payeeAddress>
                <ns2:payeeBankAddress>
                    <ns2:line1></ns2:line1>
                    <ns2:line2></ns2:line2>
                    <ns2:city></ns2:city>
                    <ns2:state></ns2:state>
                    <ns2:country></ns2:country>
                </ns2:payeeBankAddress>
                <ns2:partyId></ns2:partyId>
                <ns2:paymentDate>{fn:data($CTFO/ns1:CTFO_O_0003_0011)}</ns2:paymentDate>
                <ns2:purposeId>Null</ns2:purposeId>
                <ns2:remarks>{fn:data($CTFO/ns1:CTFO_O_0003_0009)}</ns2:remarks>
                <ns2:bankCharges>
                    <ns2:amount></ns2:amount>
                    <ns2:currency></ns2:currency>
                </ns2:bankCharges>
                <ns2:exchangeRate></ns2:exchangeRate>
                <ns2:transactionAmount>
                    <ns2:amount>{fn:data($CTFO/ns1:CTFO_O_0003_0003)}</ns2:amount>
                    <ns2:currency></ns2:currency>
                </ns2:transactionAmount>
                <ns2:debitAccount>
                    <ns2:accountId>{fn:data($CTFO/ns1:CTFO_O_0003_0002)}</ns2:accountId>
                    <ns2:bankCode>34</ns2:bankCode>
                    <ns2:branchCode>NULL</ns2:branchCode>
                    <ns2:currency>{fn:data($CTFO/ns1:CTFO_O_0003_0004)}</ns2:currency>
                </ns2:debitAccount>
                <ns2:creditAccount>
                    <ns2:accountId>{fn:data($CTFO/ns1:CTFO_O_0003_0005)}</ns2:accountId>
                    <ns2:bankCode></ns2:bankCode>
                    <ns2:branchCode></ns2:branchCode>
                    <ns2:currency>{fn:data($CTFO/ns1:CTFO_O_0003_0004)}</ns2:currency>
                </ns2:creditAccount>
                <ns2:txnReferenceId>{fn:data($CTFO/ns1:CTFO_O_0003_0001)}</ns2:txnReferenceId>
                <ns2:paymentStatus>{fn:data($CTFO/ns1:CTFO_O_0003_0013)}</ns2:paymentStatus>
                <ns2:paymentType>other bank</ns2:paymentType>
     </ns2:outwardremittances>
     }
    </ns2:Response>
};

local:func($CTFOResp)