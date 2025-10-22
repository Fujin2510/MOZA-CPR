xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "LoanFetch/Schema/CCCR-CCRD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/LoanOutstandingDetails";
(:: import schema at "LOAN_OUTSTANDING_DETAILS.xsd" ::)
declare namespace dvm="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $ResponseLod as element() (:: schema-element(ns1:CCCRResponse) ::) external;

declare function local:func($ResponseLod as element() (:: schema-element(ns1:CCCRResponse) ::)) as element() (:: schema-element(ns2:LOAN_OUTSTANDING_DETAILSResponse) ::) {
  let $errCode := fn:data($ResponseLod/ns1:errorCode)
  return
    <ns2:LOAN_OUTSTANDING_DETAILSResponse>
        <ns2:data>
          <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:externalReferenceId></ns2:externalReferenceId>
          <ns2:status>{ if($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }</ns2:status>
          {
            if($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
            else if($errCode = 'C') then 
              (
                <ns2:errorList>
                  <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($ResponseLod/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns2:code>
                  <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($ResponseLod/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($ResponseLod/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
                </ns2:errorList>
              )
            else if($errCode = '906' or $errCode = 'A') then
              (
                <ns2:errorList>
                  <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns2:code>
                  <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($ResponseLod/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
                </ns2:errorList>
              )
            else
              (
                <ns2:errorList>
                  <ns2:code>ERR001</ns2:code>
                  <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>
              )
          }
                <ns2:warningList></ns2:warningList>
            </ns2:result> 
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
        </ns2:data>
    </ns2:LOAN_OUTSTANDING_DETAILSResponse>
};

local:func($ResponseLod)