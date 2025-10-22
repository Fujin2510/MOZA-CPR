xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/SELF_FX_CCY_TRANSFER";
(:: import schema at "../Schema/SELF_FX_CCY_TRANSFER.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/tfcd";
(:: import schema at "../Schema/TFCD.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $Request as element() (:: schema-element(ns1:Request) ::) external;
declare variable $RefNo as xs:string external;
declare variable $confirmationStatus as xs:string external;
declare variable $currency as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:SELF_FX_CCY_TRANSFER_Response) ::) {
  let $errCode := fn:data($Response/ns1:errorCode)
  return
    <ns2:SELF_FX_CCY_TRANSFER_Response>
    <ns2:data>
          <ns2:result>
          <ns2:status>
            {
              if (fn:data($Response/ns1:errorCode) = '0')
              then 'SUCCESS'
              else 'FAILURE'
            }
          </ns2:status> 
           {
              if($errCode = 'C') then
                <ns2:errorList>
                  <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode', "ERR001") }</ns2:code>
                  <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($Response/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($Response/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
                </ns2:errorList>
              else if($errCode = '906' or $errCode = 'A') then
                <ns2:errorList>
                  <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns2:code>
                  <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($Response/ns1:errorMessage/ns1:messages[1])),'-')) }</ns2:message>
                </ns2:errorList>
              else
                <ns2:errorList>
                  <ns2:code>ERR001</ns2:code>
                  <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>
            }

          </ns2:result> 
            <ns2:referenceNo>{$RefNo}</ns2:referenceNo> 
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
        </ns2:data> 
    </ns2:SELF_FX_CCY_TRANSFER_Response>
};

local:func($Response)