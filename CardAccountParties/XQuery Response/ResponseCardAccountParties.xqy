xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CCCACreditCard";
(:: import schema at "../XSD/CCCA.xsd" ::)
declare namespace ns3="http://www.mozabanca.org/card_account_parties";
(:: import schema at "../XSD/card_account.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCARDebitCard";
(:: import schema at "../XSD/CCAR.xsd" ::)

declare variable $CCAR_Rsponse as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CCCA_CDCA_Response as element() (:: schema-element(ns2:CCCAResponse) ::) external;
declare variable $accountIdVar as xs:string external;
declare function local:func($CCAR_Rsponse as element() (:: schema-element(ns1:Response) ::), 
                            $CCCA_CDCA_Response as element() (:: schema-element(ns2:CCCAResponse) ::),$accountIdVar) 
                            as element() (:: schema-element(ns3:Response) ::) {
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>{if($CCCA_CDCA_Response/ns2:errorCode = 0) then 'SUCCESS' else 'FAILURE'}</ns3:status>
                {if(fn:data($CCCA_CDCA_Response/ns2:errorCode) = 0) then () else(
                <ns3:errorList>
                    <ns3:code>ERR001</ns3:code>
                    <ns3:message>Invalid backend response</ns3:message>
                </ns3:errorList>) }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            <ns3:accounts>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCCA_CDCA_Response/ns2:user)}</ns3:partyId>
                <ns3:branchId>{fn:data($CCCA_CDCA_Response/ns2:operationData/ns2:CCCA_O_0003/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0003)}</ns3:branchId>
                <ns3:accountId>{fn:data($accountIdVar)}</ns3:accountId>
                <ns3:accountType>CCA</ns3:accountType>
                <ns3:accountDisplayName></ns3:accountDisplayName>
                <ns3:currency></ns3:currency>
                <ns3:status></ns3:status>
                <ns3:balance>
                    <ns3:currency></ns3:currency>
                    <ns3:amount></ns3:amount>
                </ns3:balance>
                <ns3:interestType></ns3:interestType>
                <ns3:interestRate></ns3:interestRate>
                <ns3:openingDate></ns3:openingDate>
                <ns3:relationshipType></ns3:relationshipType>
                <ns3:accountModule></ns3:accountModule>
                <ns3:sortCode></ns3:sortCode>
                <ns3:relation></ns3:relation>
                <ns3:moduleType>CON</ns3:moduleType>
                <ns3:iban></ns3:iban>
            </ns3:accounts>
        </ns3:data>
    </ns3:Response>
};

local:func($CCAR_Rsponse, $CCCA_CDCA_Response,$accountIdVar)