xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabank.org/CAPD";
(:: import schema at "../../GetAllProducts_TD/Schema/CAPD.xsd" ::)
declare namespace ns2 = "http://www.mozabank.org/td-fetch-penality";
(:: import schema at "../Schemas/TD_FETCH_PENALTY.xsd" ::)
declare namespace dvm = "http://www.oracle.com/osb/xpath-functions/dvm";
declare variable $CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::) external;
declare variable $FetchPenaltyRequest as element() (:: schema-element(ns2:Request) ::) external;
declare variable $MaturityAmountVal external;
declare variable $RedeemFlag as xs:string external;
declare function local:func($CAPDResponse as element() (:: schema-element(ns1:CAPDResponse) ::), 
                            $FetchPenaltyRequest as element() (:: schema-element(ns2:Request) ::),$MaturityAmountVal,$RedeemFlag) 
                            as element() (:: schema-element(ns2:Response) ::) {
  let $errCode := fn:data($CAPDResponse/*:errorCode)
  let $redmMode := fn:data($FetchPenaltyRequest/ns2:redeemMode)

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
                  else if (fn:data($CAPDResponse/ns1:errorCode) = 'C') then 
                  (
                    <ns2:errorList>
                      <ns2:code>{
                        dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',
                          substring-before(xs:string(fn:data($CAPDResponse/*:errorMessage/*:messages[1])), '-'),
                          'ErrorCode',substring-before(xs:string(fn:data($CAPDResponse/*:errorMessage/*:messages[1])), '-'))
                      }</ns2:code>
                      <ns2:message>{
                        dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',
                          substring-before(xs:string(fn:data($CAPDResponse/*:errorMessage/*:messages[1])), '-'),
                          'ErrorMessageEN', substring-after(xs:string(fn:data($CAPDResponse/*:errorMessage/*:messages[1])), '-'))
                      }</ns2:message>
                    </ns2:errorList>
                  )
                  else if ($errCode = '906' or $errCode = 'A') then 
                  (
                    <ns2:errorList>
                      <ns2:code>{
                        dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', 'ERR001')
                      }</ns2:code>
                      <ns2:message>{
                        dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', 'Invalid backend response')
                      }</ns2:message>
                    </ns2:errorList>
                  )
                  else (
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
    </ns2:Response>
};

local:func($CAPDResponse, $FetchPenaltyRequest,$MaturityAmountVal,$RedeemFlag)