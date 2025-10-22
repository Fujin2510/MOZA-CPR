xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CDOD";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccdo_party_casa_accounts_list";
(:: import schema at "../XSD/PARTY_CASA_ACCOUNTS_LIST.xsd" ::)

declare variable $PartyCasaAccountList as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($PartyCasaAccountList as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:CasaPartyAccountListResponse) ::) {
    <ns2:CasaPartyAccountListResponse>
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
             <ns2:status>{if(fn:data($PartyCasaAccountList/*:errorCode) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
             {if(fn:data($PartyCasaAccountList/*:errorCode) = 0) then () else(
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                
                <ns2:message>Invalid backend response</ns2:message>
               </ns2:errorList>)}  
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        {
        for $CCDO in $PartyCasaAccountList/*:operationData/*:CCDO_O_0003
        return  
        <ns2:accounts>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:partyId>{fn:data($PartyCasaAccountList/*:user)}</ns2:partyId>
            <ns2:branchId>{fn:data($CCDO/*:CDOD/*:CDOD_O_0003)}</ns2:branchId>
            <ns2:accountId>{fn:data($CCDO/*:CDOD/*:CDOD_O_0001)}</ns2:accountId>
            <ns2:accountType>CSA</ns2:accountType>
            <ns2:accountDisplayName>{fn:data($CCDO/*:CDOD/*:CDOD_O_0002)}</ns2:accountDisplayName>
            <ns2:currency>{fn:data($CCDO/*:CDOD/*:CDOD_O_0015)}</ns2:currency>
            <ns2:status>ACTIVE</ns2:status>
            <ns2:balance>
                <ns2:currency>{fn:data($CCDO/*:CDOD/*:CDOD_O_0015)}</ns2:currency>
              <ns2:amount>{fn-bea:format-number(fn:data($CCDO/*:CDOD/*:CDOD_O_0007), '0.00')}</ns2:amount>
            </ns2:balance>
            <ns2:interestType></ns2:interestType>
            <ns2:interestRate></ns2:interestRate>
            <ns2:openingDate></ns2:openingDate>
            <ns2:relationshipType></ns2:relationshipType>
            <ns2:accountModule></ns2:accountModule>
            <ns2:sortCode>{fn:data($CCDO/*:CDOD/*:CDOD_O_0003)}</ns2:sortCode>
            <ns2:relation></ns2:relation>
            <ns2:moduleType>CON</ns2:moduleType>
            <ns2:iban></ns2:iban>
        </ns2:accounts>
        }
        </ns2:data>
    </ns2:CasaPartyAccountListResponse>
};

local:func($PartyCasaAccountList)