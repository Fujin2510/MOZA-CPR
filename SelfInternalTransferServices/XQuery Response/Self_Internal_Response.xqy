xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/internalTransfer";
(:: import schema at "../Schema/OBDXSchema/INTERNAL_TRANSFER.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ptfi";
(:: import schema at "../Schema/MSBSchema/PTFI.xsd" ::)


declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $PTFI_Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($PTFI_Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId>{fn:data($PTFI_Response/ns1:operationData/ns1:PTFI_O_0001)}</ns2:externalReferenceId>
                <ns2:status>{if(fn:data($PTFI_Response/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status> 
                  {if(fn:data($PTFI_Response/ns1:errorCode) = '0') then () else(
                 <ns2:errorList>
                  <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',fn:data($PTFI_Response/ns1:errorCode), 'ErrorCode',"ERR001") }</ns2:code>
                  <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',fn:data($PTFI_Response/ns1:errorCode), 'ErrorMessage',"Invalid backend response") }</ns2:message>
              </ns2:errorList>)  }
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
        </ns2:data>
    </ns2:Response>
};

local:func($PTFI_Response)