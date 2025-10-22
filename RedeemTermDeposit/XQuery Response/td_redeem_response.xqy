xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabanca.org/MAPP";
(:: import schema at "../Schemas/MAPP.xsd" ::)
declare namespace ns2 = "http://www.mozabank.org/td_redeem";
(:: import schema at "../Schemas/TD_REDEEM.xsd" ::)

declare namespace dvm = "http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
  
  let $errCode := fn:data($Response/*:errorCode)
  
  return
    <ns2:Response>
      <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
          <ns2:dictionaryArray></ns2:dictionaryArray>
          <ns2:externalReferenceId></ns2:externalReferenceId>
          <ns2:status>{
            if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE'
          }</ns2:status>
          
          {
            if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
            else if ($errCode = 'C') then
              <ns2:errorList>
                <ns2:code>{
                  dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', 
                    substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])), '-'),
                    'ErrorCode', substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])), '-'))
                }</ns2:code>
                <ns2:message>{
                  dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',
                    substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])), '-'),
                    'ErrorMessageEN', substring-after(xs:string(fn:data($Response/*:errorMessage/*:messages[1])), '-'))
                }</ns2:message>
              </ns2:errorList>
            else if ($errCode = '906' or $errCode = 'A') then
              <ns2:errorList>
                <ns2:code>{
                  dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', 'ERR001')
                }</ns2:code>
                <ns2:message>{
                  dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', 'Invalid backend response')
                }</ns2:message>
              </ns2:errorList>
            else
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
              </ns2:errorList>
          }
          
          <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:hasMore></ns2:hasMore>
        <ns2:totalRecords></ns2:totalRecords>
        <ns2:startSequence></ns2:startSequence>
        {  if ($errCode = '0') then 
        <ns2:redemptionAmount>
          <ns2:currency>MZN</ns2:currency>
          <ns2:amount>{xs:decimal(concat(substring(fn:data($Response/ns1:operationData/ns1:MAPP_O_0001),1,13),'.',substring(fn:data($Response/ns1:operationData/ns1:MAPP_O_0001),14,2)))}</ns2:amount>
        </ns2:redemptionAmount>
        else()
        }
      </ns2:data>
    </ns2:Response>
};

local:func($Response)