xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CCARDebitCard";
(:: import schema at "../Schema/CCAR.xsd" ::)
declare namespace ns1="http://www.mozabank.org/DebitCardList";
(:: import schema at "../Schema/DEBIT_CARD_LIST.xsd" ::)

declare variable $DebitCardList_Rquest as element() (:: schema-element(ns1:DebitCardListRequest) ::) external;

declare function local:func($DebitCardList_Rquest as element() (:: schema-element(ns1:DebitCardListRequest) ::)) as element() (:: schema-element(ns2:Request) ::) {
    <ns2:Request>
        <ns2:user>{fn:data($DebitCardList_Rquest/ns1:entity)}</ns2:user>
        <ns2:password></ns2:password>
        <ns2:origin>P</ns2:origin>
        <ns2:channelCode>INT</ns2:channelCode>
        <ns2:version>R30</ns2:version>
        <ns2:licenceKey>licenseKey</ns2:licenceKey>
        <ns2:sessionId>00000000</ns2:sessionId>
        <ns2:transactionCode>CCAR</ns2:transactionCode>
        <ns2:operationData>
            <ns2:CCAR_I_0001>20</ns2:CCAR_I_0001>
            <ns2:CCAR_I_0003>S</ns2:CCAR_I_0003>
            <ns2:CCAR_I_0004>N</ns2:CCAR_I_0004>
            <ns2:CCAR_I_0007>{fn:data($DebitCardList_Rquest/ns1:accountId)}</ns2:CCAR_I_0007>
        </ns2:operationData>
    </ns2:Request>
};

local:func($DebitCardList_Rquest)