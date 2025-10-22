xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/SearchParty";
(:: import schema at "SearchParty.xsd" ::)
declare namespace ns1="http://www.mozabank.org/nxsd/REST";
(:: import schema at "SchemaRest.xsd" ::)

declare variable $Response as element() (:: schema-element(ns1:Request) ::) external;
declare variable $partyId as xs:string external;
declare function local:func($Response as element() (:: schema-element(ns1:Request) ::),$partyId as xs:string) as element() (:: schema-element(ns2:Response) ::) {
  <ns2:Response  xmlns:ns2="http://www.mozabank.org/SearchParty">
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
           <ns2:status>{if(fn:data($Response/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
             {if(fn:data($Response/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = '0') then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>)
            
            }
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore>false</ns2:hasMore>
        <ns2:totalRecords>0</ns2:totalRecords>
        <ns2:startSequence>0</ns2:startSequence>
        <ns2:partyDetailsList>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:personalInfo>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:salutation></ns2:salutation>
                <ns2:gender></ns2:gender>
                   <ns2:firstName>{fn:tokenize(fn:data($Response/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:nomEntidade), '\s+')[1]}</ns2:firstName>
                <ns2:middleName></ns2:middleName>
                <ns2:lastName></ns2:lastName>
                <ns2:maritalStatus></ns2:maritalStatus>
                <ns2:birthDate></ns2:birthDate>
                <ns2:email></ns2:email>
                <ns2:fullName></ns2:fullName>
                <ns2:partyType></ns2:partyType>
                <ns2:addressInfo></ns2:addressInfo>
            </ns2:personalInfo>
            <ns2:contactInfo></ns2:contactInfo>
            <ns2:partyId>{$partyId}</ns2:partyId>
        </ns2:partyDetailsList>
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$partyId)