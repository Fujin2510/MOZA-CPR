xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/cpfc";
(:: import schema at "Schema/CPFC.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns3="http://www.mozabank.org/LoanAccountFetch";
(:: import schema at "Schema/LOAN_ACCOUNTS_FETCH.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CccrResponse as element() (:: schema-element(ns1:CCCRResponse) ::) external;
declare variable $CpfcResponse as element() (:: schema-element(ns2:CPFCResponse) ::) external; 

declare function local:func($CccrResponse as element() (:: schema-element(ns1:CCCRResponse) ::), 
                            $CpfcResponse as element() (:: schema-element(ns2:CPFCResponse) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {

  let $errCode := fn:data($CccrResponse/*:errorCode)
  return
    <ns3:Response>
      <ns3:data>
        <ns3:dictionaryArray></ns3:dictionaryArray>
        <ns3:referenceNo></ns3:referenceNo>
        <ns3:result>
          <ns3:dictionaryArray></ns3:dictionaryArray>
          <ns3:externalReferenceId></ns3:externalReferenceId>
          <ns3:status>{ if($errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE' }</ns3:status>
          {
            if($errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
            else if($errCode = 'C') then
              (
                <ns3:errorList>
                  <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CccrResponse/*:errorMessage/*:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns3:code>
                  <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CccrResponse/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN','Invalid Backend Response') }</ns3:message>
                </ns3:errorList>
              )
            else if($errCode = '906' or $errCode = 'A') then
              (
                <ns3:errorList>
                  <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns3:code>
                  <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', 'Invalid Backend Response') }</ns3:message>
                </ns3:errorList>
              )
            else
              (
                <ns3:errorList>
                  <ns3:code>ERR001</ns3:code>
                  <ns3:message>Invalid backend response</ns3:message>
                </ns3:errorList>
              )
          }
          <ns3:warningList></ns3:warningList>
        </ns3:result>
        <ns3:hasMore></ns3:hasMore>
        <ns3:totalRecords></ns3:totalRecords>
        <ns3:startSequence></ns3:startSequence>
      </ns3:data>
    </ns3:Response>
};

local:func($CccrResponse, $CpfcResponse)