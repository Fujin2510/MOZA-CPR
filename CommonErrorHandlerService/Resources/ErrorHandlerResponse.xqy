xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/osb/errorHandlerService";
(:: import schema at "../ErrorHandlerService.xsd" ::)

declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Req as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($Req as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns1:Response) ::) {
    <ns1:Response>
        <ns1:data>
            <ns1:dictionaryArray></ns1:dictionaryArray>
            <ns1:referenceNo></ns1:referenceNo>
            <ns1:result>
                <ns1:dictionaryArray></ns1:dictionaryArray>
                <ns1:externalReferenceId></ns1:externalReferenceId>
                <ns1:status>FAILURE</ns1:status>
                <ns1:errorList>
                    <ns1:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',fn:data($Req/ns1:ErrorCode), 'ErrorCode',"ERR001") }</ns1:code>
                    <ns1:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',fn:data($Req/ns1:ErrorCode), 'ErrorMessage',"Invalid backend response") }</ns1:message>
                </ns1:errorList>
                <ns1:warningList></ns1:warningList>
            </ns1:result>
            <ns1:hasMore></ns1:hasMore>
            <ns1:totalRecords></ns1:totalRecords>
            <ns1:startSequence></ns1:startSequence>
        </ns1:data>
    </ns1:Response>
};

local:func($Req)