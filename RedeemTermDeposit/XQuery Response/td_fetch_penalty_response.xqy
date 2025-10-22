xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/MAPP";
(:: import schema at "../Schemas/MAPP.xsd" ::)
declare namespace ns2="http://www.mozabank.org/td-fetch-penality";
(:: import schema at "../Schemas/TD_FETCH_PENALTY.xsd" ::)

declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $Response as element() (:: schema-element(ns1:Response) ::) external;
declare variable $InterestRateVar as xs:string external;

declare function local:func($Response as element() (:: schema-element(ns1:Response) ::),$InterestRateVar) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId> 
               <ns2:status>{if(fn:data($Response/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status>
				 {if(fn:data($Response/ns1:errorCode) = '0') then () else(
		 <ns2:errorList>
	              <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',fn:data($Response/ns1:errorCode), 'ErrorCode',"ERR001") }</ns2:code>
	              <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',fn:data($Response/ns1:errorCode), 'ErrorMessage',"Invalid backend response") }</ns2:message>
                </ns2:errorList>)  }
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:maturityAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:maturityAmount>
            <ns2:redemptionAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:redemptionAmount>
            <ns2:netCreditAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:netCreditAmount>
            <ns2:charges>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:charges>
            <ns2:revisedMaturityAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:revisedMaturityAmount>
            <ns2:revisedPrincipalAmount>
                <ns2:currency></ns2:currency>
                <ns2:amount></ns2:amount>
            </ns2:revisedPrincipalAmount>
            <ns2:interestRate>{$InterestRateVar}</ns2:interestRate>
        </ns2:data>
    </ns2:Response>
};

local:func($Response,$InterestRateVar)