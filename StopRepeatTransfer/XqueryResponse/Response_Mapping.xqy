xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CANCEL_INSTRUCTION";
(:: import schema at "../XSD/CANCEL_INSTRUCTION.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/COTF";
(:: import schema at "../XSD/COTF.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $MSB_Response as element() (:: schema-element(ns1:COTF_Response) ::) external;

declare function local:func($MSB_Response as element() (:: schema-element(ns1:COTF_Response) ::)) 
       as element() (:: schema-element(ns2:CANCEL_INSTRUCTION_Response) ::) {

   let $errCode := fn:data($MSB_Response/*:errorCode) 
   return

    <ns2:CANCEL_INSTRUCTION_Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
          <ns2:result>
    <ns2:dictionaryArray></ns2:dictionaryArray>
    {
      if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then
        <ns2:externalReferenceId>{fn:data($MSB_Response/ns1:coreLogKey)}</ns2:externalReferenceId>
      else ()
    }
  <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}    </ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($MSB_Response/ns1:errorCode) = 'C') then 
                 (
          <ns2:errorList>
              <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($MSB_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
              <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($MSB_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
    </ns2:CANCEL_INSTRUCTION_Response>
};

local:func($MSB_Response)