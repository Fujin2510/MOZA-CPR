xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/internalTransfer";
(:: import schema at "INTERNAL_TRANSFER.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ptfi";
(:: import schema at "SelfTransferService/PTFI.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $IntlResp as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($IntlResp as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($IntlResp/*:errorCode) return

    <ns2:Response>
    <ns2:data>
       <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId>{fn:data($IntlResp/ns1:operationData/ns1:PTFI_O_0001)}</ns2:externalReferenceId>
          <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>

                {

                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()

                 else if(fn:data($IntlResp/ns1:errorCode) = 'C') then 

                 (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($IntlResp/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($IntlResp/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
</ns2:errorList>)

                 else if($errCode = '906' or $errCode = 'A') then 

                (
<ns2:errorList>
<ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns2:code>
<ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
</ns2:errorList>)

                 else(
<ns2:errorList>
<ns2:code>ERR001</ns2:code>
<ns2:message>Invalid backend response</ns2:message>
</ns2:errorList>)

			}
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        </ns2:data>
    </ns2:Response>
};

local:func($IntlResp)