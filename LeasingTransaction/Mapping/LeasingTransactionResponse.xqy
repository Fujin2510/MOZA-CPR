xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/cmov";
(:: import schema at "../XSD/CMOV.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/lease_txn_stmt";
(:: import schema at "../XSD/LEASE_ACCOUNT_TXN_STMT.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::)) as element() (:: schema-element(ns2:Response) ::) {
let $errCode := fn:data($Response/*:errorCode) return
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
               <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}    </ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                else if(fn:data($Response/ns1:errorCode) = 'C') then 
                 (
          <ns2:errorList>
              <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
              <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
          </ns2:errorList>)

else if($errCode = '906' or $errCode = 'A') then
(

   <ns2:errorList>
      <ns2:code>{
          dvm:lookup(
              'CommonErrorHandlerService/SystemCodes.dvm',
              'MSBCode',
              $errCode,
              'OBDXCode',
              "ERR001"
          )
      }</ns2:code>
      <ns2:message>{
          let $msg := xs:string(fn:data($Response/*:errorMessage/*:messages[1]))
          return
             if (matches($msg, '^[A-Za-z0-9 .,:;''"?!()-]+$')) 
             then $msg (: English → return as-is :)
             else dvm:lookup(
                     'CommonErrorHandlerService/SystemCodes.dvm',
                     'MSBCode',
                     $errCode,
                     'ErrorMessageEN',
                     "Invalid backend response"
                  )
      }</ns2:message>
   </ns2:errorList>
)
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
              if ($errCode = '0') then
              for $tx at $i in $Response/ns1:operationData/ns1:CMOV_O_0011
              let $subSeq := concat(substring("000", 1, 3 - string-length(string($i))), string($i))
              return
            <ns2:statementItemList>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId>{fn:data($tx/ns1:CMOV_O_0011_0018)}</ns2:externalReferenceId>
                <ns2:subSequenceNumber>{$subSeq}</ns2:subSequenceNumber>
               <ns2:date>{
                concat(
                  substring($tx/ns1:CMOV_O_0011_0001, 1, 4), "-", 
                  substring($tx/ns1:CMOV_O_0011_0001, 5, 2), "-", 
                  substring($tx/ns1:CMOV_O_0011_0001, 7, 2), 
                  "T00:00:00"
                )
                 }</ns2:date>

                <ns2:valueDate>{
                  concat(
                    substring($tx/ns1:CMOV_O_0011_0014, 1, 4), "-", 
                    substring($tx/ns1:CMOV_O_0011_0014, 5, 2), "-", 
                    substring($tx/ns1:CMOV_O_0011_0014, 7, 2), 
                    "T00:00:00"
                  )
              }</ns2:valueDate>
                <ns2:documentNo>{fn:data($tx/ns1:CMOV_O_0011_0003)}</ns2:documentNo>
                <ns2:desc>{fn:data($tx/ns1:CMOV_O_0011_0005)}</ns2:desc>
                <ns2:amount>
                    <ns2:currency>{fn:data($tx/ns1:CMOV_O_0011_0008)}</ns2:currency>
                    <ns2:amount>{concat(replace(fn:data($tx/ns1:CMOV_O_0011_0006), '^0+', ''), '.00')}</ns2:amount>
                </ns2:amount>
                <ns2:balance>
                    <ns2:currency>{fn:data($tx/ns1:CMOV_O_0011_0008)}</ns2:currency>
                    <ns2:amount>{concat(replace(fn:data($tx/ns1:CMOV_O_0011_0012), '^0+', ''), '.00')}</ns2:amount>
                </ns2:balance>
            </ns2:statementItemList>
           else()
            }
        </ns2:data>
    </ns2:Response>
};

local:func($Response)