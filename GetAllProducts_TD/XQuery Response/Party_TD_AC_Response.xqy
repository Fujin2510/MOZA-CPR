xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPDAccountListResponse.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_party_td_accounts_list";
(:: import schema at "../Schema/PARTY_TD_ACCOUNTS_LIST.xsd" ::)
declare namespace dvm ="http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CAPD_Response as element() (:: schema-element(ns1:CAPDAccountObjectResponse) ::) external;
declare variable $CCAP_Response as element() (:: schema-element(ns2:Response) ::) external;

declare function local:func($CAPD_Response as element() (:: schema-element(ns1:CAPDAccountObjectResponse) ::) (:: schema-element(ns2:Response) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
  let $errCode := fn:data($CCAP_Response/ns2:errorCode)

  return
    <ns3:Response>
        <ns3:data>
            <ns3:dictionaryArray></ns3:dictionaryArray>
            <ns3:referenceNo></ns3:referenceNo>
            <ns3:result>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:externalReferenceId></ns3:externalReferenceId>
        <ns3:status>{ if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then 'SUCCESS' else 'FAILURE' }</ns3:status>
        {
          if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then ()
          else if ($errCode = 'C') then
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAP_Response/ns2:errorMessage/ns2:messages[1])), '-'), 'ErrorCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCAP_Response/ns2:errorMessage/ns2:messages[1])), '-'), 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAP_Response/ns2:errorMessage/ns2:messages[1])), '-')) }</ns3:message>
            </ns3:errorList>
          else if ($errCode = '906' or $errCode = 'A') then
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', substring-after(xs:string(fn:data($CCAP_Response/ns2:errorMessage/ns2:messages[1])), '-')) }</ns3:message>
            </ns3:errorList>
          else
            <ns3:errorList>
              <ns3:code>ERR001</ns3:code>
              <ns3:message>Invalid backend response</ns3:message>
            </ns3:errorList>
        }
                <ns3:warningList></ns3:warningList>
            </ns3:result>
            <ns3:hasMore></ns3:hasMore>
            <ns3:totalRecords></ns3:totalRecords>
            <ns3:startSequence></ns3:startSequence>
            {
        if ($errCode = '0' or $errCode = 'P' or $errCode = 'B') then
            for $capd in $CAPD_Response/ns1:operationData
            return
            
            <ns3:accounts>
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCAP_Response/ns2:user)}</ns3:partyId>
                <ns3:branchId>{substring(xs:string(fn:data($capd/ns1:CAPD_O_0001)),1,3)}</ns3:branchId><!-- to be taken from request branch code-->
                <ns3:accountId>{fn:data($capd/ns1:CAPD_O_0001)}</ns3:accountId>
                <ns3:accountType>TRD</ns3:accountType>
                <ns3:accountDisplayName>{fn:data($capd/ns1:CAPD_O_0002)}</ns3:accountDisplayName>
                <ns3:currency>{fn:data($capd/ns1:CAPD_O_0009)}</ns3:currency>
                <ns3:status>ACTIVE</ns3:status>
                <ns3:balance>
                    <ns3:currency>{if(fn:data($capd/ns1:CAPD_O_0013) != 0) then fn:data($capd/ns1:CAPD_O_0009) else()}</ns3:currency>
                    <ns3:amount>{if(fn:data($capd/ns1:CAPD_O_0013) != 0) then fn-bea:format-number(fn:data($capd/ns1:CAPD_O_0013), '0.00') else()}</ns3:amount>
                </ns3:balance>
                <ns3:interestType></ns3:interestType>
                <ns3:interestRate></ns3:interestRate>
                <ns3:openingDate>{let $date := fn:data($capd/ns1:CAPD_O_0005) return 
                if(fn:data($capd/ns1:CAPD_O_0005) != '') then 
                concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00') else()}</ns3:openingDate>
                <ns3:relationshipType></ns3:relationshipType>
                <ns3:accountModule></ns3:accountModule>
                <ns3:sortCode></ns3:sortCode><!-- to be taken from request branch code-->
                <ns3:relation></ns3:relation>
                <ns3:moduleType>CON</ns3:moduleType>
                <ns3:iban></ns3:iban>
            </ns3:accounts>
        else ()
      }
    </ns3:data>
  </ns3:Response>
};

local:func($CAPD_Response)