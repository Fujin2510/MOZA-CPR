xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/cdod";
(:: import schema at "../Schema/CDOD.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/AccountDetails";
(:: import schema at "../Schema/ACCOUNT_DETAILS.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($Response/*:errorCode) return
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
             <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}    </ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($Response/ns1:errorCode) = 'C') then 
                 (
          <ns2:errorList>
              <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
              <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
            <ns2:accountNumber>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0001)}</ns2:accountNumber>
            <ns2:branchCode>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0003)}</ns2:branchCode>
            <ns2:currencyCode>{fn:data($Response/ns1:operationData/ns1:CDOD_O_0015)}</ns2:currencyCode>
            <ns2:partyId>{fn:data($Response/ns1:user)}</ns2:partyId>
            <ns2:acctType></ns2:acctType>
        </ns2:data>
    </ns2:Response>
};

local:func($Response)