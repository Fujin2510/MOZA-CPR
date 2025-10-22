xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns3="http://www.mozabank.org/TD_DETAILS";
(:: import schema at "../Schema/TD_DETAILS%201.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns4="http://www.mozabank.org/getTDProductDetails";
(:: import schema at "../../TermDeposit/Resources/Schema/GetTDProductDetails.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::) external;
declare variable $CCAPResponse as element() (:: schema-element(ns2:Response) ::) external;
declare variable $accountIdVar as xs:string external;
declare variable $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::) external;
 
declare function local:func($CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::), 
                            $CCAPResponse as element() (:: schema-element(ns2:Response) ::),$accountIdVar,
                             $TDProductDetails as element() (:: schema-element(ns4:ResponseList) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
  let $errCode := fn:data($CCAPResponse/ns2:errorCode)

  return
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns3:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($CCAPResponse/ns2:errorCode) = 'C') then 
                 (
                    <ns3:errorList>
                      <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCAPResponse/ns2:errorMessage/ns2:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns3:code>
                      <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCAPResponse/ns2:errorMessage/ns2:messages[1])),'-'), 'ErrorMessageEN',substring-after(xs:string(fn:data($CCAPResponse/ns2:errorMessage/ns2:messages[1])),'-')) }</ns3:message>
                    </ns3:errorList>)
                 else if($errCode = 'A') then 
                 (
                    <ns3:errorList>
                      <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns3:code>
                      <ns3:message>{fn:data($CCAPResponse/ns2:errorMessage/ns2:messages[1])}</ns3:message>
                    </ns3:errorList>)
                 else (
                    <ns3:errorList>
                      <ns3:code>ERR001</ns3:code>
                      <ns3:message>Invalid backend response</ns3:message>
                    </ns3:errorList>)
                }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence> 
        </ns3:data>
    </ns3:Response>
};

local:func($CAPDResponse, $CCAPResponse,$accountIdVar,$TDProductDetails)