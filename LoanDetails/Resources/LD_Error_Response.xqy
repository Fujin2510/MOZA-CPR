xquery version "1.0" encoding "utf-8";
  
  (:: OracleAnnotationVersion "1.0" ::)
  
  declare namespace ns2="http://www.mozabanca.org/cpfc";
  (:: import schema at "LoanFetch/Schema/CPFC.xsd" ::)
  declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
  (:: import schema at "LoanFetch/Schema/CCCR-CCRD.xsd" ::)
  declare namespace ns3="http://www.mozabank.org/LoanDetails";
  (:: import schema at "LOAN_DETAILS.xsd" ::)
declare namespace dvm="http://www.oracle.com/osb/xpath-functions/dvm";
  declare variable $ResponseCccr as element() (:: schema-element(ns1:CCCRResponse) ::) external;
  declare variable $ResponseCpfc as element() (:: schema-element(ns2:CPFCResponse) ::) external;
  
  declare function local:func($ResponseCccr as element() (:: schema-element(ns1:CCCRResponse) ::), 
                              $ResponseCpfc as element() (:: schema-element(ns2:CPFCResponse) ::)) 
                              as element() (:: schema-element(ns3:LoanDetailsResponse) ::) { 
      let $cccr := $ResponseCccr/ns1:operationData/ns1:CCCR_O_0003
    let $errCode := fn:data($ResponseCccr/ns1:errorCode)
      return
      <ns3:LoanDetailsResponse>
          <ns3:data>
              <ns3:dictionaryArray></ns3:dictionaryArray>
              <ns3:referenceNo></ns3:referenceNo>
              <ns3:result>
                  <ns3:dictionaryArray></ns3:dictionaryArray> 
                  <ns3:externalReferenceId></ns3:externalReferenceId>
	  <ns3:status>
            { if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }
          </ns3:status>
          {
            if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
            else if ($errCode = 'C') then 
              <ns2:errorList>
                <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
                <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
              </ns2:errorList>
            else if ($errCode = '906' or $errCode = 'A') then 
              <ns2:errorList>
                <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode',"ERR001") }</ns2:code>
                <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($ResponseCccr/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
              </ns2:errorList>
            else
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
              </ns2:errorList>
          }

                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence> 
        </ns3:data>
    </ns3:LoanDetailsResponse>
};

local:func($ResponseCccr, $ResponseCpfc)