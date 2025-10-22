xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/APAG";
(:: import schema at "../Schema/APAG.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccPayChangeOption";
(:: import schema at "../Schema/CC_PAY_CHANGE_OPTION.xsd" ::)

declare variable $MSB_Request as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($MSB_Request as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo>{fn:data($MSB_Request/ns1:coreLogKey)}</ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                 <ns2:status>{
                  let $code := fn:data($MSB_Request/ns1:errorCode)
                  return
                    if ($code = '0') then 'SUCCESS'
                    else if ($code = '-1') then 'PENDING'
                    else 'FAILURE'
                }</ns2:status>

              {let $code := fn:data($MSB_Request/ns1:errorCode)
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
        </ns2:data>
    </ns2:Response>
};

local:func($MSB_Request)