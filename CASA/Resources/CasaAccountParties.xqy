xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabanca.org/CDOD";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccdo_casa_account_parties";
(:: import schema at "../XSD/CASA_ACCOUNT_PARTIES.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CDOD as element() (:: schema-element(ns1:Response) ::) external;
declare variable $AccountIDVar as xs:string external;
declare function local:func($CDOD as element() (:: schema-element(ns1:Response) ::),$AccountIDVar) as element() (:: schema-element(ns2:CasaAccountPartiesResponse) ::) {
    let $errCode := fn:data($CDOD/*:errorCode) return
    <ns2:CasaAccountPartiesResponse >
    <ns2:data>
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId> 
              <ns2:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if(fn:data($CDOD/ns1:errorCode) = 'C') then 
                 (
			<ns2:errorList>
				<ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CDOD/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns2:code>
				<ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CDOD/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns2:message>
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
 if(fn:data($CDOD/ns1:errorCode) = '0') then 
       let $cdod := $CDOD/ns1:operationData/ns1:CCDO_O_0003[ns1:CDOD/ns1:CDOD_O_0001 = $AccountIDVar]
        return
        <ns2:accounts>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:partyId>{fn:data($CDOD/ns1:user)}</ns2:partyId>
            <ns2:branchId>{fn:data($cdod/ns1:CDOD/ns1:CDOD_O_0003)}</ns2:branchId>
            <ns2:accountId>{fn:data($cdod/ns1:CDOD/ns1:CDOD_O_0001)}</ns2:accountId>
            <ns2:accountType>CSA</ns2:accountType>
            <ns2:accountDisplayName></ns2:accountDisplayName>
            <ns2:currency></ns2:currency>
            <ns2:status></ns2:status>
            <ns2:balance></ns2:balance>
            <ns2:interestType></ns2:interestType>
            <ns2:interestRate></ns2:interestRate>
            <ns2:openingDate></ns2:openingDate>
            <ns2:relationshipType></ns2:relationshipType>
            <ns2:accountModule>CON</ns2:accountModule>
            <ns2:sortCode></ns2:sortCode>
            <ns2:relation></ns2:relation>
            <ns2:moduleType></ns2:moduleType>
            <ns2:iban></ns2:iban>
        </ns2:accounts> 
else()
        }
        </ns2:data>
    </ns2:CasaAccountPartiesResponse>
};

local:func($CDOD,$AccountIDVar)