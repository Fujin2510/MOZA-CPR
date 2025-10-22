xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPDAccountListResponse.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_tdlist";
(:: import schema at "../Schema/TD_LIST.xsd" ::)
declare namespace ns4="http://www.mozabank.org/getTDProductDetails";
(:: import schema at "../../TermDeposit/Resources/Schema/GetTDProductDetails.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPD_Response as element() (:: schema-element(ns1:CAPDAccountObjectResponse) ::) external;
declare variable $CCAP_Response as element() (:: schema-element(ns2:Response) ::) external;
declare variable $userIdVar as xs:string external;
declare variable $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::) external;
declare function local:func($CAPD_Response as element() (:: schema-element(ns1:CAPDAccountObjectResponse) ::), 
                            $CCAP_Response as element() (:: schema-element(ns2:Response) ::),$userIdVar as xs:string,
                             $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
  let $errCode := fn:data($CCAP_Response/*:errorCode)

  return
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
        <ns3:referenceNo></ns3:referenceNo>
        <ns3:result>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:externalReferenceId></ns3:externalReferenceId>
      <ns3:status>
        { if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE' }
      </ns3:status>
      {
        if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
        else if($errCode = 'C') then 
        (
          <ns2:errorList>
            <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns2:code>
            <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-')) }</ns2:message>
          </ns2:errorList>
        )
        else if($errCode = '906' or $errCode = 'A') then 
        (
          <ns2:errorList>
            <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns2:code>
            <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAP_Response/*:errorMessage/*:messages[1])),'-')) }</ns2:message>
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
            <ns3:warningList></ns3:warningList>
        </ns3:result>
        <ns3:hasMore></ns3:hasMore>
        <ns3:totalRecords></ns3:totalRecords>
        <ns3:startSequence></ns3:startSequence>
        </ns3:data>
    </ns3:Response>
};

local:func($CAPD_Response, $CCAP_Response,$userIdVar,$TDProductDetails)