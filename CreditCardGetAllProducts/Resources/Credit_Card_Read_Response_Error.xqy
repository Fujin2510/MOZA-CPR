xquery version "1.0" encoding "utf-8";
  
  (:: OracleAnnotationVersion "1.0" ::)
  
  declare namespace ns1="http://www.mozabank.org/CCARCreditCard";
  (:: import schema at "XSD/CCAR.xsd" ::)
  declare namespace ns2="http://www.mozabank.org/CCCACreditCard";
  (:: import schema at "XSD/CCCA.xsd" ::)
  declare namespace ns3="http://www.mozabank.org/CREDIT_CARD_READ";
  (:: import schema at "XSD/CREDIT_CARD_READ.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";
  
  declare variable $Response_CCAR as element() (:: schema-element(ns1:Response) ::) external;
  declare variable $Response_CccaCdca as element() (:: schema-element(ns2:CCCAResponse) ::) external;
  declare variable $idVar as xs:string external;
  declare function local:func($Response_CCAR as element() (:: schema-element(ns1:Response) ::), 
                              $Response_CccaCdca as element() (:: schema-element(ns2:CCCAResponse) ::),$idVar) 
                              as element() (:: schema-element(ns3:Response) ::) {
  let $errCode := xs:string(fn:data($Response_CccaCdca/*:errorCode)) return
      <ns3:Response>
          <ns3:data>
              <ns3:dictionaryArray></ns3:dictionaryArray>
              <ns3:referenceNo></ns3:referenceNo>
              <ns3:result>
                  <ns3:dictionaryArray></ns3:dictionaryArray>
                  <ns3:externalReferenceId></ns3:externalReferenceId>
        <ns3:status>{ if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }</ns3:status>
        {
          if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
          else if ($errCode = 'C') then
          (
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response_CccaCdca/*:errorMessage/*:messages[1])), '-'), 'ErrorCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response_CccaCdca/*:errorMessage/*:messages[1])), '-'), 'ErrorMessageEN', "Invalid backend response") }</ns3:message>
            </ns3:errorList>
          )
          else if ($errCode = '906' or $errCode = 'A') then
          (
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', "Invalid backend response") }</ns3:message>
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
  
  local:func($Response_CCAR, $Response_CccaCdca,$idVar)