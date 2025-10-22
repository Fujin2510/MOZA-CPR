xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CDOD";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccdo_casa_product_details";
(:: import schema at "../XSD/CASA_PRODUCT_DETAILS.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CDOD as element() (:: schema-element(ns1:Response) ::) external;
declare variable $codeVar as xs:string external; 
declare variable $prodName as xs:string external; 
declare function local:func($CDOD as element() (:: schema-element(ns1:Response) ::),$codeVar as xs:string,$prodName as xs:string) as element() (:: schema-element(ns2:ProductInquiryResponse) ::) {
   <ns2:ProductInquiryResponse>
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId> 
            <ns2:status>{if(fn:data($codeVar) != '') then 'SUCCESS' else 'FAILURE'}</ns2:status>
             {if(fn:data($codeVar) != '') then () else(
            <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>)  }
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        <ns2:products>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:accountType>CSA</ns2:accountType>
            <ns2:productId>{$codeVar}</ns2:productId>
            <ns2:productName>{$prodName}</ns2:productName>
            <ns2:productType>C</ns2:productType>
            <ns2:module></ns2:module>
            <ns2:amount>
                <ns2:currency></ns2:currency>
                <ns2:amount>0</ns2:amount>
            </ns2:amount>
            <ns2:hasChequeBookFacility></ns2:hasChequeBookFacility>
            <ns2:hasATMFacility></ns2:hasATMFacility>
            <ns2:hasOverdraftFacility></ns2:hasOverdraftFacility>
            <ns2:hasPassBookFacility></ns2:hasPassBookFacility>
        </ns2:products>
        </ns2:data>
    </ns2:ProductInquiryResponse>
};

local:func($CDOD,$codeVar,$prodName)