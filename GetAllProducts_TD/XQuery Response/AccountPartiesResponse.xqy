xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/ccap_td_account_parties";
(:: import schema at "../Schema/TD_ACCOUNT_PARTIES.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $userIdVar as xs:string  external;
declare function local:func($Request as element() (:: schema-element(ns1:Request) ::),$userIdVar as xs:string) as element() (:: schema-element(ns1:Response) ::) {
 
    <ns1:Response>
        <ns1:data>
            <ns1:dictionaryArray></ns1:dictionaryArray>
            <ns1:referenceNo></ns1:referenceNo>
            <ns1:result>
                <ns1:dictionaryArray></ns1:dictionaryArray>
                <ns1:externalReferenceId></ns1:externalReferenceId>
            <ns1:status>SUCCESS</ns1:status> 
                <ns1:warningList></ns1:warningList>
            </ns1:result>
            <ns1:hasMore></ns1:hasMore>
            <ns1:totalRecords></ns1:totalRecords>
            <ns1:startSequence></ns1:startSequence>
            <ns1:accounts>
                <ns1:dictionaryArray></ns1:dictionaryArray>
                <ns1:partyId>{$userIdVar}</ns1:partyId>
                <ns1:branchId>{substring(fn:data($Request/ns1:accountId), 1, 3)}</ns1:branchId>
                <ns1:accountId>{fn:data($Request/ns1:accountId)}</ns1:accountId>
                <ns1:accountType>TRD</ns1:accountType>
                <ns1:accountDisplayName></ns1:accountDisplayName>
                <ns1:currency></ns1:currency>
                <ns1:status></ns1:status>
                <ns1:balance></ns1:balance>
                <ns1:interestType></ns1:interestType>
                <ns1:interestRate></ns1:interestRate>
                <ns1:openingDate></ns1:openingDate>
                <ns1:relationshipType></ns1:relationshipType>
                <ns1:accountModule>CON</ns1:accountModule>
                <ns1:sortCode></ns1:sortCode>
                <ns1:relation></ns1:relation>
                <ns1:moduleType></ns1:moduleType>
                <ns1:iban></ns1:iban>
            </ns1:accounts>
        </ns1:data>
    </ns1:Response>
};

local:func($Request,$userIdVar)