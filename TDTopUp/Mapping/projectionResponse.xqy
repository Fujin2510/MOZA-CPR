xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/obdx/td_topup_projection";
(:: import schema at "../XSD/TD_TOPUP_PROJECTION.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/capd";
(:: import schema at "../XSD/CAPD.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::) external;
declare variable $Request as element() (:: schema-element(ns2:Request) ::) external;
declare variable $Maturityamount as xs:string  external;
declare variable $InterestRate as xs:string  external;
declare variable $principalAmount as xs:string  external;
declare variable $current as xs:string  external;
declare variable $currency as xs:string  external;
declare variable $status as xs:string  external;
declare variable $message as xs:string  external;

declare function local:func($CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::), 
                            $Request as element() (:: schema-element(ns2:Request) ::),$Maturityamount,$InterestRate,$principalAmount,$current,$currency,$status,$message) 
                            as element() (:: schema-element(ns2:Response) ::) {
let $errCode := $status return
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                else if($errCode = 'C') then 
(
  <ns2:errorList>
    <ns2:code>{
      dvm:lookup(
        'CommonErrorHandlerService/ErrorCodes.dvm',
        'MSBCode',
        substring-before(xs:string($message), '-'),
        'ErrorCode',
        substring-before(xs:string($message), '-')
      )
    }</ns2:code>
    <ns2:message>{
      dvm:lookup(
        'CommonErrorHandlerService/ErrorCodes.dvm',
        'MSBCode',
        substring-before(xs:string($message), '-'),
        'ErrorMessageEN',
        substring-before(xs:string($message), '-')
      )
    }</ns2:message>
  </ns2:errorList>
)
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
            {
  if($errCode = '0') then 
            <ns2:currentPrincipal>
                <ns2:currency>{$currency}</ns2:currency>
                <ns2:amount>{$current}</ns2:amount>
            </ns2:currentPrincipal>
            else()
            }
            {
  if($errCode = '0') then 
            <ns2:principalAmount>
                <ns2:currency>{$currency}</ns2:currency>
                <ns2:amount>{$principalAmount}</ns2:amount>
            </ns2:principalAmount>
            else()
            }

            {
  if($errCode = '0') then 
            <ns2:maturityAmount>
                <ns2:currency>{$currency}</ns2:currency>
                <ns2:amount>{$Maturityamount}</ns2:amount>
            </ns2:maturityAmount>
            else()
            }
            {
  if($errCode = '0') then 
          <ns2:revisedInterestRate>{$InterestRate}</ns2:revisedInterestRate>
            else()
            }
            {
  if($errCode = '0') then 
          <ns2:sourceAccountId>{fn:data($Request/ns2:accountId)}</ns2:sourceAccountId>
            else()
            }
        </ns2:data>
    </ns2:Response>
};

local:func($CAPDResponse, $Request,$Maturityamount,$InterestRate,$principalAmount,$current,$currency,$status,$message)