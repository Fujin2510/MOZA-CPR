xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CCCR_CCRD";
(:: import schema at "Schema/CCCR-CCRD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/LOAN_ACCOUNT_PARTIES";
(:: import schema at "Schema/LOAN_ACCOUNT_PARTIES.xsd" ::)

declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CCRD_Response as element() (:: schema-element(ns1:CCCRResponse) ::) external;

declare function local:func($CCRD_Response as element() (:: schema-element(ns1:CCCRResponse) ::)) as element() (:: schema-element(ns2:LOAN_ACCOUNT_PARTIESResponse) ::) {
       let $errCode := fn:data($CCRD_Response/*:errorCode) return
    <ns2:LOAN_ACCOUNT_PARTIESResponse>
        <ns2:data>
            <ns2:result>
               <!-- <ns2:status>{if(fn:data($CCRD_Response/ns1:errorCode) = '0') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {if(fn:data($CCRD_Response/ns1:errorCode) = '0') then () else(
                <ns2:errorList>
                    <ns2:code>ERR001</ns2:code>
                    <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>) }-->
                 <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($CCRD_Response/ns1:errorCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCRD_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CCRD_Response/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
            for $ccrd in $CCRD_Response/ns1:operationData/ns1:CCCR_O_0003
            return
            <ns2:accounts>
                <ns2:partyId>{fn:data($CCRD_Response/ns1:user)}</ns2:partyId>
                <ns2:branchId>{fn:data($ccrd/ns1:CCRD/ns1:CCRD_O_0003)}</ns2:branchId>
                <ns2:accountId>{fn:data($ccrd/ns1:CCCR_O_0003_0001)}</ns2:accountId>
                <ns2:accountType>LOAN</ns2:accountType>
                <ns2:accountDisplayName></ns2:accountDisplayName>
                <ns2:currency></ns2:currency>
                <ns2:status></ns2:status>
                <ns2:balance></ns2:balance>
                <ns2:interestType></ns2:interestType>
                <ns2:interestRate></ns2:interestRate>
                <ns2:openingDate></ns2:openingDate>
                <ns2:relationshipType>SOW</ns2:relationshipType>
                <ns2:accountModule>LOAN</ns2:accountModule>
                <ns2:sortCode></ns2:sortCode>
                <ns2:relation></ns2:relation>
                <ns2:moduleType>CON</ns2:moduleType>
                <ns2:iban></ns2:iban>
            </ns2:accounts>
            }
        </ns2:data>
    </ns2:LOAN_ACCOUNT_PARTIESResponse>
};

local:func($CCRD_Response)