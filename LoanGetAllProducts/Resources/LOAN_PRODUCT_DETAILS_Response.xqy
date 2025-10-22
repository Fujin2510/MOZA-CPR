xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1 = "http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns2 = "http://www.mozabank.org/LOAN_PRODUCT_DETAILS";
(:: import schema at "Schema/LOAN_PRODUCT_DETAILS.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CCRD_response as element() (:: schema-element(ns1:CCCRResponse) ::) external;

declare variable $productId as xs:string external;

declare function local:func($CCRD_response as element() (:: schema-element(ns1:CCCRResponse) ::),$productId) 
  as element() (:: schema-element(ns2:Response) ::) {
 let $errCode := fn:data($CCRD_response/*:errorCode) 

 return
    <ns2:Response>
      <ns2:data>
        <ns2:dictionaryArray/>
        <ns2:referenceNo/>
        <ns2:result>
          <ns2:dictionaryArray/>
          <ns2:externalReferenceId/>
         <!-- <ns2:status>
            {
              if (fn:data($CCRD_response/ns1:errorCode) = '0') 
              then 'SUCCESS' 
              else 'FAILURE'
            }
          </ns2:status>
          {
            if (fn:data($CCRD_response/ns1:errorCode) = '0') then () else (
              <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
              </ns2:errorList>
            )
          }-->
          <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($CCRD_response/ns1:errorCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCRD_response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCRD_response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
          <ns2:warningList/>
        </ns2:result>
        <ns2:hasMore/>
        <ns2:totalRecords/>
        <ns2:startSequence/>
{
    let $firstMatch :=
        for $p at $pos in $CCRD_response/ns1:operationData/ns1:CCCR_O_0003
        where fn:data($p/ns1:CCRD/ns1:CCRD_O_0002) = $productId
        return
            if ($pos = min(
                for $q at $i in $CCRD_response/ns1:operationData/ns1:CCCR_O_0003
                where fn:data($q/ns1:CCRD/ns1:CCRD_O_0002) = $productId
                return $i
            )) then $p else ()

    return
        if ($firstMatch) then (
            <ns2:id>{fn:data($firstMatch/ns1:CCRD/ns1:CCRD_O_0002)}</ns2:id>,
            <ns2:name>{fn:data($firstMatch/ns1:CCCR_O_0003_0002)}</ns2:name>,
            <ns2:description>{fn:data($firstMatch/ns1:CCCR_O_0003_0002)}</ns2:description>,
            <ns2:type>L</ns2:type>
        ) else ()
}

      </ns2:data>
    </ns2:Response>
};

local:func($CCRD_response,$productId)