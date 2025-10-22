xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/CDOD";
(:: import schema at "../XSD/CDOD.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccdo_branch_list";
(:: import schema at "../XSD/BRANCH_LIST.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CDOD as element() (:: schema-element(ns2:Response) ::) external;

declare function local:func($CDOD as element() (:: schema-element(ns2:Response) ::)) as element() (:: schema-element(ns1:Response) ::) {
let $errCode := fn:data($CDOD/*:errorCode) return
    <ns1:Response>
    <ns1:data>
        <ns1:dictionaryArray></ns1:dictionaryArray>
        <ns1:referenceNo></ns1:referenceNo>
        <ns1:result>
            <ns1:dictionaryArray></ns1:dictionaryArray>
            <ns1:externalReferenceId></ns1:externalReferenceId>
            <ns1:status>{  if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then 'SUCCESS' else 'FAILURE'}</ns1:status>
                {
                 if( $errCode = '0' or $errCode = 'P' or $errCode ='B') then ()
                 else if($errCode = 'C') then 
                 (
			<ns1:errorList>
				<ns1:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CDOD/*:errorMessage/*:messages[1])),'-'), 'ErrorCode',"ERR001") }</ns1:code>
				<ns1:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode',substring-before(xs:string(fn:data($CDOD/*:errorMessage/*:messages[1])),'-'), 'ErrorMessageEN',"Invalid backend response") }</ns1:message>
			</ns1:errorList>)
                 else if($errCode = '906' or $errCode = 'A') then 
                (
			<ns1:errorList>
				<ns1:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'OBDXCode',"ERR001") }</ns1:code>
				<ns1:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode',$errCode, 'ErrorMessageEN',"Invalid backend response") }</ns1:message>
			</ns1:errorList>)
                 else(
			<ns1:errorList>
				<ns1:code>ERR001</ns1:code>
				<ns1:message>Invalid backend response</ns1:message>
			</ns1:errorList>)
			}
            <ns1:warningList></ns1:warningList>
        </ns1:result>
        <ns1:hasMore></ns1:hasMore>
        <ns1:totalRecords></ns1:totalRecords>
        <ns1:startSequence></ns1:startSequence>
        <ns1:branchList>
            <ns1:dictionaryArray></ns1:dictionaryArray>
            <ns1:branchId>{fn:data($CDOD/ns2:operationData/ns2:CCDO_O_0003[1]/ns2:CDOD/ns2:CDOD_O_0003)}</ns1:branchId>
            <ns1:branchName>{fn:data($CDOD/ns2:operationData/ns2:CCDO_O_0003[1]/ns2:CDOD/ns2:CDOD_O_0004)}</ns1:branchName>
            <ns1:bankId></ns1:bankId>
            <ns1:localCurrency></ns1:localCurrency>
            <ns1:address>
                <ns1:line1>{fn:data($CDOD/ns2:operationData/ns2:CCDO_O_0003[1]/ns2:CDOD/ns2:CDOD_O_0004)}</ns1:line1>
                <ns1:line2></ns1:line2>
                <ns1:line3></ns1:line3>
                <ns1:line4></ns1:line4>
                <ns1:line5></ns1:line5>
                <ns1:line6></ns1:line6>
                <ns1:line7></ns1:line7>
                <ns1:line8></ns1:line8>
                <ns1:line9></ns1:line9>
                <ns1:line10></ns1:line10>
                <ns1:line11></ns1:line11>
                <ns1:line12></ns1:line12>
                <ns1:city>MZN</ns1:city>
                <ns1:addressTypeDescription></ns1:addressTypeDescription>
                <ns1:state></ns1:state>
                <ns1:country>MZN</ns1:country>
                <ns1:zipCode></ns1:zipCode>
            </ns1:address>
        </ns1:branchList>
        </ns1:data>
    </ns1:Response>
};

local:func($CDOD)