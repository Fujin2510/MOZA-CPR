xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CCLE";
(:: import schema at "../Schema/CCLE.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCC_ACCOUNT_TXN_STMT";
(:: import schema at "../Schema/LEASE_ACCOUNT_LIST.xsd" ::)
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
                <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>

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
            <ns2:accounts>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:leasingNumber>{fn:data($Response/ns1:operationData/ns1:CCLE_O_0003/ns1:CCLE_O_0003_0001)}</ns2:leasingNumber>
                    <ns2:dateOfNextInstallment>                        {
                          let $date := fn:data($Response/ns1:operationData/ns1:CCLE_O_0003/ns1:CCLE_O_0003_0004)
                          return concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                        }</ns2:dateOfNextInstallment>
                    <ns2:amtInDebt>
                        <ns2:currency>{fn:data($Response/ns1:operationData/ns1:CCLE_O_0003/ns1:CCLE_O_0003_0006)}</ns2:currency>
                        <ns2:amount>
                          {
                            let $amount := xs:decimal(fn:data($Response/ns1:operationData/ns1:CCLE_O_0003/ns1:CCLE_O_0003_0005)) div 100
                            return
                              if ($amount = xs:integer($amount)) then
                                concat(xs:string($amount), '.00')
                              else
                                let $str := xs:string($amount),
                                    $dec := substring-after($str, '.'),
                                    $pad := substring('00', string-length($dec) + 1)
                                return concat(substring-before($str, '.'), '.', $dec, $pad)
                          }</ns2:amount>
                    </ns2:amtInDebt>
            </ns2:accounts>
else()
}
        </ns2:data>
    </ns2:Response>
};

local:func($Response)