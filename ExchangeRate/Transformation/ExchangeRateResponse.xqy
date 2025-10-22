xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/exchange_rate_msb";
(:: import schema at "../Schemas/MSB.xsd" ::)
declare namespace ns2="http://www.mozabanca.org/obdx/exchange_rate_obdx";
(:: import schema at "../Schemas/OBDX.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Req as element() (:: schema-element(ns1:ExchangeRateResponse) ::) external;
declare variable $ObfxReq as element() (:: schema-element(ns2:Request) ::) external;

declare function local:func($Req as element() (:: schema-element(ns1:ExchangeRateResponse) ::), 
                            $ObfxReq as element() (:: schema-element(ns2:Request) ::)) 
                            as element() (:: schema-element(ns2:Response) ::) {

   let $errCode := fn:data($Req/*:errorCode) return
<ns2:Response> 
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
                  <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray> 
                 <!--<ns2:status>{if(fn:data($Req/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {if(fn:data($Req/ns1:errorCode) = '0') then () else(
                <ns2:errorList>
                   <ns2:code>ERR001</ns2:code>
                  <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList>)   } -->
            
            <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($Req/ns1:errorCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Req/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($Req/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
            {
                for $CCMB_O_0003 in $Req/ns1:operationData/ns1:CCMB_O_0003[ns1:CCMB_O_0003_0003 = $ObfxReq/ns2:currency1]
                return 
                <ns2:exchangeRates>
                    <ns2:currency2>{fn:data($ObfxReq/ns2:currency2)}</ns2:currency2>
                    <ns2:currency1>{fn:data($ObfxReq/ns2:currency1)}</ns2:currency1>
                    <ns2:branchId>{fn:data($ObfxReq/ns2:branchId)}</ns2:branchId>
                <ns2:rateType>STANDARD</ns2:rateType>
                <ns2:midRate>{
                  let $buy := fn-bea:format-number(xs:decimal(fn:data($CCMB_O_0003/ns1:CCMB_O_0003_0005)) div 1000000000, '0.000000000')
                  let $sell := fn-bea:format-number(xs:decimal(fn:data($CCMB_O_0003/ns1:CCMB_O_0003_0005)) div 1000000000, '0.000000000')
                  return   fn-bea:format-number((xs:decimal($buy) + xs:decimal($sell)) div 2, '0.000000000')
                }</ns2:midRate>
                <ns2:buyRate>{fn-bea:format-number(xs:decimal(fn:data($CCMB_O_0003/ns1:CCMB_O_0003_0005)) div 1000000000, '0.000000000')}
</ns2:buyRate>
                <ns2:sellRate>{fn-bea:format-number(xs:decimal(fn:data($CCMB_O_0003/ns1:CCMB_O_0003_0006)) div 1000000000, '0.000000000')}
</ns2:sellRate>
            </ns2:exchangeRates>
            }
           
      </ns2:data> 
    </ns2:Response>
};

local:func($Req, $ObfxReq)