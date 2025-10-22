xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/MAPP";
(:: import schema at "../Schemas/MAPP.xsd" ::)
declare namespace ns2="http://www.mozabank.org/PARTY_LIST";
(:: import schema at "../Schemas/PARTY_LIST.xsd" ::)

declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";
declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $customerName as xs:string external;
declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$customerName) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
               <ns2:status>SUCCESS</ns2:status>
	 
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:custName>{$customerName}</ns2:custName>
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$customerName)