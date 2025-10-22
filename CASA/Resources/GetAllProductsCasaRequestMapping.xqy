xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns7="http://www.mozabanca.org/CDOD";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns6="http://www.mozabank.org/ccdo_branch_list";
(:: import schema at "../XSD/BRANCH_LIST.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccdo_casa_account_parties";
(:: import schema at "../XSD/CASA_ACCOUNT_PARTIES.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccdo_casa_product_details";
(:: import schema at "../XSD/CASA_PRODUCT_DETAILS.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccdo_casaaccount_partylist_summary";
(:: import schema at "../XSD/CASAACCOUNT_PARTYLIST_SUMMARY.xsd" ::)
declare namespace ns4="http://www.mozabank.org/ccdo_casalist";
(:: import schema at "../XSD/CASALIST.xsd" ::)
declare namespace ns5="http://www.mozabank.org/ccdo_party_casa_accounts_list";
(:: import schema at "../XSD/PARTY_CASA_ACCOUNTS_LIST.xsd" ::)

declare variable $CasaAccountParties as element() (:: schema-element(ns1:CasaAccountPartiesRequest) ::) external;
declare variable $CasaProductDetails as element() (:: schema-element(ns2:ProductInquiryRequest) ::) external;
declare variable $CasaAccountPartylistSummary as element() (:: schema-element(ns3:Request) ::) external;
declare variable $Casalist as element() (:: schema-element(ns4:Request) ::) external;
declare variable $PartyCasaAccountList as element() (:: schema-element(ns5:CasaPartyAccountListRequest) ::) external;
declare variable $BranchList as element() (:: schema-element(ns6:Request) ::) external;
declare variable $partyIdVar as xs:string  external;
declare variable $accountIdVar as xs:string  external;
declare function local:func($CasaAccountParties as element() (:: schema-element(ns1:CasaAccountPartiesRequest) ::), 
                            $partyIdVar as xs:string, 
                            $accountIdVar as xs:string) 
                            as element() (:: schema-element(ns7:Request) ::) {
    <ns7:Request>
        <ns7:user>{$partyIdVar}</ns7:user>
        <ns7:password></ns7:password>
        <ns7:origin>P</ns7:origin>
        <ns7:channelCode>INT</ns7:channelCode>
        <ns7:version>R30</ns7:version>
        <ns7:licenceKey>licenceKey</ns7:licenceKey>
        <ns7:sessionId>00000000</ns7:sessionId>
        <ns7:transactionCode>CCDO</ns7:transactionCode>
        <ns7:operationData>
            <ns7:CCDO_I_0001>{if(fn:data($accountIdVar)) then $accountIdVar else ''}</ns7:CCDO_I_0001>
            <ns7:CCDO_I_0004>S</ns7:CCDO_I_0004>
            <ns7:CCDO_I_0005>S</ns7:CCDO_I_0005>
        </ns7:operationData>
    </ns7:Request>
};

local:func($CasaAccountParties,$partyIdVar ,$accountIdVar)