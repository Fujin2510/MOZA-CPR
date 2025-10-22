xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns5="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_party_td_accounts_list";
(:: import schema at "../Schema/PARTY_TD_ACCOUNTS_LIST.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_td_product_details";
(:: import schema at "../Schema/TD_PRODUCT_DETAILS.xsd" ::)
declare namespace ns4="http://www.mozabank.org/ccap_tdaccount_partylist_summary";
(:: import schema at "../Schema/TDACCOUNT_PARTYLIST_SUMMARY.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccap_tdlist";
(:: import schema at "../Schema/TD_LIST.xsd" ::)

declare variable $RequestTDList as element() (:: schema-element(ns1:Request) ::) external;
declare variable $RequestPartyTDAccList as element() (:: schema-element(ns2:Request) ::) external;
declare variable $RequestTDProductDetails as element() (:: schema-element(ns3:Request) ::) external;
declare variable $RequestTDAccPartyListSummary as element() (:: schema-element(ns4:Request) ::) external;

declare function local:func($RequestTDList as element() (:: schema-element(ns1:Request) ::), 
                            $RequestPartyTDAccList as element() (:: schema-element(ns2:Request) ::), 
                            $RequestTDProductDetails as element() (:: schema-element(ns3:Request) ::), 
                            $RequestTDAccPartyListSummary as element() (:: schema-element(ns4:Request) ::)) 
                            as element() (:: schema-element(ns5:Request) ::) {
    <ns5:Request>
        <ns5:user>{fn:data($RequestTDList/*:partyId)}</ns5:user>
        <ns5:password></ns5:password>
        <ns5:origin>P</ns5:origin>
        <ns5:channelCode>INT</ns5:channelCode>
        <ns5:version>R30</ns5:version>
        <ns5:licenceKey>licenceKey</ns5:licenceKey>
        <ns5:sessionId>00000000</ns5:sessionId>
        <ns5:transactionCode>CCAP</ns5:transactionCode>
        <ns5:operationData>
            <ns5:CCAP_I_0001>99</ns5:CCAP_I_0001> 
            <ns5:CCAP_I_0004>N</ns5:CCAP_I_0004>
            <ns5:CCAP_I_0005>N</ns5:CCAP_I_0005>
        </ns5:operationData>
    </ns5:Request>
};

local:func($RequestTDList, $RequestPartyTDAccList, $RequestTDProductDetails, $RequestTDAccPartyListSummary)