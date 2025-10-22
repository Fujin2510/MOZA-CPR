xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CC_CASH_ADVANCE";
(:: import schema at "../XSDs/CC_CASH_ADVANCE.xsd" ::)
declare namespace ns1="http://www.mozabanca.org/CHAD";
(:: import schema at "../XSDs/CHAD.xsd" ::)

declare variable $MSB_Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $OBDX_Request as element() (:: schema-element(ns2:Request) ::) external;
declare variable $RefNo as xs:string external;

declare function local:func(
  $MSB_Response as element() (:: schema-element(ns1:Response) ::), 
  $partyIdVar as xs:string
) as element() (:: schema-element(ns2:Response) ::) {

    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo> </ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
              <ns2:status>{
                  let $code := fn:data($MSB_Response/ns1:errorCode)
                  return
                    if ($code = '0') then 'SUCCESS'
                    else if ($code = '-1') then 'PENDING'
                    else 'FAILURE'
                }</ns2:status>

              {let $code := fn:data($MSB_Response/ns1:errorCode)
              return
              if ($code = '0') then ()
              else if($code= '-1')then () 
              else(
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
               </ns2:errorList>)}
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:referenceNo>{$RefNo}</ns2:referenceNo>
             <ns2:currencytype>{fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0003)}</ns2:currencytype>
     <ns2:processedAmount>
{
  let $amountRaw := fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0002)
  return
    if (normalize-space($amountRaw) != '') then
      let $amount := xs:decimal($amountRaw) div 100
      return fn-bea:format-number($amount, '#.00')
    else ()
}
</ns2:processedAmount>

            <ns2:transactionID>{fn:data($MSB_Response/ns1:operationData/ns1:CHAD_O_0001)}</ns2:transactionID>
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Response ,$RefNo)