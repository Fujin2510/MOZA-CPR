xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPDAccountListResponse.xsd" ::)
declare namespace ns1="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_tdaccount_partylist_summary";
(:: import schema at "../Schema/TDACCOUNT_PARTYLIST_SUMMARY.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPDResponse as element() (:: schema-element(ns2:CAPDAccountObjectResponse) ::) external;
declare variable $CCAPResponse as element() (:: schema-element(ns1:Response) ::) external;

declare function local:func($CAPDResponse as element() (:: schema-element(ns2:CAPDAccountObjectResponse) ::), 
                            $CCAPResponse as element() (:: schema-element(ns1:Response) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
    let $errCode := fn:data($CCAPResponse/ns1:errorCode)

    return
 <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
                <ns3:status>
                {
                    if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE'
                }
                </ns3:status>
                {
                    if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
                    else if (fn:data($CCAPResponse/ns1:errorCode) = 'C') then 
                    (
                        <ns2:errorList>
                            <ns2:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAPResponse/ns1:errorMessage/ns1:messages[1])), '-'), 'ErrorCode', "ERR001") }</ns2:code>
                            <ns2:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAPResponse/ns1:errorMessage/ns1:messages[1])), '-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAPResponse/ns1:errorMessage/ns1:messages[1])), '-')) }</ns2:message>
                        </ns2:errorList>
                    )
                    else if ($errCode = '906' or $errCode = 'A') then 
                    (
                        <ns2:errorList>
                            <ns2:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns2:code>
                            <ns2:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAPResponse/ns1:errorMessage/ns1:messages[1])), '-')) }</ns2:message>
                        </ns2:errorList>
                    )
                    else 
                    (
                        <ns2:errorList>
                            <ns2:code>ERR001</ns2:code>
                            <ns2:message>Invalid backend response</ns2:message>
                        </ns2:errorList>
                    )
                }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            {
            if ($errCode = '0') then
            for $ccap in $CCAPResponse/ns1:operationData/ns1:CCAP_O_0003
            return
            <ns3:accounts>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCAPResponse/ns1:user)}</ns3:partyId>
                <ns3:branchId>{substring(fn:data($ccap/ns1:CCAP_O_0003_0001),1,3)}</ns3:branchId>
                <ns3:accountId>{fn:data($ccap/ns1:CCAP_O_0003_0001)}</ns3:accountId>
                <ns3:accountType>TRD</ns3:accountType>
                <ns3:accountDisplayName>{fn:data($ccap/ns1:CCAP_O_0003_0002)}</ns3:accountDisplayName>
                <ns3:currency>{fn:data($ccap/ns1:CCAP_O_0003_0006)}</ns3:currency>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:balance>
                    <ns3:currency>{fn:data($ccap/ns1:CCAP_O_0003_0006)}</ns3:currency>
                    <ns3:amount>{if($ccap/ns1:CCAP_O_0003_0006) then fn-bea:format-number(fn:data($ccap/ns1:CCAP_O_0003_0005), '0.00') else()}</ns3:amount>
                </ns3:balance>
                <ns3:interestType></ns3:interestType>
                <ns3:interestRate></ns3:interestRate>
                <ns3:openingDate>
                {let $date := fn:data($CAPDResponse/ns2:operationData[ns2:CAPD_O_0001 = xs:long($ccap/ns1:CCAP_O_0003_0001)]/ns2:CAPD_O_0005) return 
                if(fn:data($CAPDResponse/ns2:operationData/ns2:CAPD_O_0005) != '') then
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00') else()}
                </ns3:openingDate>
                <ns3:relationshipType></ns3:relationshipType>
                <ns3:accountModule>CON</ns3:accountModule>
                <ns3:sortCode>{substring(fn:data($ccap/ns1:CCAP_O_0003_0001),1,3)}</ns3:sortCode> <!-- branch code to be fetched from request-->
                <ns3:relation></ns3:relation>
                <ns3:moduleType></ns3:moduleType>
                <ns3:iban></ns3:iban>
            </ns3:accounts>
            else ()
            }
             {
            if ($errCode = '0') then
            <ns3:count>{count($CCAPResponse/ns1:operationData/ns1:CCAP_O_0003)}</ns3:count>
            else() }
        </ns3:data>
    </ns3:Response>
};

local:func($CAPDResponse, $CCAPResponse)