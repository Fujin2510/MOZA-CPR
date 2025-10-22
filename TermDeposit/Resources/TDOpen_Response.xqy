xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPP";
(:: import schema at "Schema/CAPP.xsd" ::)
declare namespace ns4="http://www.mozabank.org/TDOpen";
(:: import schema at "TD_OPEN.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPP_Response as element() (:: schema-element(ns1:CAPPResponse) ::) external;

declare function local:func($CAPP_Response as element() (:: schema-element(ns1:CAPPResponse) ::)) 
                            as element() (:: schema-element(ns4:Response) ::) {

  let $errCode := fn:data($CAPP_Response/*:errorCode)

  return
    <ns4:Response>
        <ns4:data>
            <ns4:dictionaryArray></ns4:dictionaryArray>
            <ns4:referenceNo></ns4:referenceNo>
            <ns4:result>
                <ns4:dictionaryArray></ns4:dictionaryArray>
                <ns4:externalReferenceId></ns4:externalReferenceId>

                <ns4:status>{
                  if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE'
                }</ns4:status>

                {
                  if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
                  else if ($errCode = 'C') then 
                  (
                    <ns4:errorList>
                      <ns4:code>{
                        dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',
                        substring-before(xs:string(fn:data($CAPP_Response/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorCode', 'ERR001')
                      }</ns4:code>
                      <ns4:message>{
                        dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',
                        substring-before(xs:string(fn:data($CAPP_Response/ns1:errorMessage/ns1:messages[1])),'-'), 'ErrorMessageEN', 'Invalid backend response')
                      }</ns4:message>
                    </ns4:errorList>
                  )
                  else if ($errCode = '906' or $errCode = 'A') then 
                  (
                    <ns4:errorList>
                      <ns4:code>{
                        dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', 'ERR001')
                      }</ns4:code>
                      <ns4:message>{
                        dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', 'Invalid backend response')
                      }</ns4:message>
                    </ns4:errorList>
                  )
                  else (
                    <ns4:errorList>
                      <ns4:code>ERR001</ns4:code>
                      <ns4:message>Invalid backend response</ns4:message>
                    </ns4:errorList>
                  )
                }

            </ns4:result>
            <ns4:hasMore></ns4:hasMore>
            <ns4:totalRecords></ns4:totalRecords>
            <ns4:startSequence></ns4:startSequence>
            {  if ($errCode = '0') then <ns4:accountId>{fn:data($CAPP_Response/ns1:operationData/ns1:CAPP_O_0001)}</ns4:accountId> else() }
            {  if ($errCode = '0') then <ns4:branchId>{substring(fn:data($CAPP_Response/ns1:operationData/ns1:CAPP_O_0001), 1, 3)}</ns4:branchId> else() }
            {  if ($errCode = '0') then <ns4:fcrAccount>Y</ns4:fcrAccount> else() }
        </ns4:data>
    </ns4:Response>
};

local:func($CAPP_Response)