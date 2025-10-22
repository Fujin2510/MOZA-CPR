xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CCARCreditCard";
(:: import schema at "XSD/CCAR.xsd" ::)
declare namespace ns2="http://www.mozabank.org/CCCACreditCard";
(:: import schema at "XSD/CCCA.xsd" ::)
declare namespace ns3="http://www.mozabank.org/PartyCardAccountList";
(:: import schema at "XSD/PARTY_CARD_ACCOUNTS_LIST.xsd" ::)
declare namespace dvm = "http://www.oracle.com/osb/xpath-functions/dvm";

declare variable $CCARResponse as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CCCARResponse as element() (:: schema-element(ns2:CCCAResponse) ::) external;

declare function local:func($CCARResponse as element() (:: schema-element(ns1:Response) ::), 
                            $CCCARResponse as element() (:: schema-element(ns2:CCCAResponse) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {

  let $errCode := fn:data($CCARResponse/*:errorCode) return

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
          else if (fn:data($CCARResponse/*:errorCode) = 'C') then (
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCARResponse/*:errorMessage/*:messages[1])), '-'), 'ErrorCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/ErrorCodes.dvm', 'MSBCode', substring-before(xs:string(fn:data($CCARResponse/*:errorMessage/*:messages[1])), '-'), 'ErrorMessageEN', "Invalid backend response") }</ns3:message>
            </ns3:errorList>
          )
          else if ($errCode = '906' or $errCode = 'A') then (
            <ns3:errorList>
              <ns3:code>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'OBDXCode', "ERR001") }</ns3:code>
              <ns3:message>{ dvm:lookup('CommonErrorHandlerService/SystemCodes.dvm', 'MSBCode', $errCode, 'ErrorMessageEN', "Invalid backend response") }</ns3:message>
            </ns3:errorList>
          )
          else (
            <ns3:errorList>
              <ns3:code>ERR001</ns3:code>
              <ns3:message>Invalid backend response</ns3:message>
            </ns3:errorList>
          )
        }
            <ns3:warningList></ns3:warningList>
        </ns3:result>
        <ns3:hasMore></ns3:hasMore>
        <ns3:totalRecords></ns3:totalRecords>
        <ns3:startSequence></ns3:startSequence>
        {
   
   for $ccar in $CCARResponse/ns1:operationData/ns1:CCAR_O_0003[ns1:CCAR_O_0003_0013 = 'CARC' and (ns1:CCAR_O_0003_0011 = 'Normal' or ns1:CCAR_O_0003_0011 = 'Lista Negra' or ns1:CCAR_O_0003_0011 = 'Lista cinzenta' or ns1:CCAR_O_0003_0011 = 'Capturado a não devolver')]  
        let $ccarObj := $CCCARResponse/ns2:operationData/ns2:CCCA_O_0003[ns2:CCCA_O_0003_0001 = $ccar/ns1:CCAR_O_0003_0017] 
        return
        <ns3:accounts> 
                <ns3:dictionaryArray></ns3:dictionaryArray>
                <ns3:partyId>{fn:data($CCARResponse/ns1:user)}</ns3:partyId>
                <ns3:branchId>{fn:data($ccarObj/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0003)}</ns3:branchId>
                <ns3:accountId>{fn:data($ccar/ns1:CCAR_O_0003_0001)}</ns3:accountId>
                <ns3:accountType>CCA</ns3:accountType>
                <ns3:accountDisplayName>{fn:data($ccarObj/ns2:CCCA_O_0003_0002)}</ns3:accountDisplayName>
                <ns3:currency>{fn:data($ccarObj/ns2:CCCA_O_0003_0008)}</ns3:currency>
                <ns3:status>{let $value1:= fn:data($ccar/ns1:CCAR_O_0003_0011) 
				return 
				if ($value1 = 'Normal') then 'ACT' 
				else if ($value1 = 'Lista Negra') then 'BLK'
				else if ($value1 = 'Lista cinzenta') then 'BLK'
				else if ($value1 = 'Capturado a não devolver') then 'BLK'
				else 'ACT' }</ns3:status>
                <ns3:balance>
                    <ns3:currency>{fn:data($ccarObj/ns2:CCCA_O_0003_0008)}</ns3:currency>
                    <ns3:amount>{fn-bea:format-number(fn:data($ccarObj/ns2:CCCA_O_0003_0004), '0.00')}</ns3:amount>
                </ns3:balance>
                <ns3:interestType></ns3:interestType>
                <ns3:interestRate></ns3:interestRate>
                <ns3:openingDate>{let $date := fn:data($ccar/ns1:CCAR_O_0003_0007) return 
concat(substring($date,1,4),'-',substring($date,5,2),'-',substring($date,7,2),'T00:00:00')}</ns3:openingDate>
                <ns3:relationshipType></ns3:relationshipType>
                <ns3:accountModule>CON</ns3:accountModule>
                <ns3:sortCode>{fn:data($ccarObj/ns2:CCCA_O_0003_0001_DETAILS/ns2:CDCA_O_0003)}</ns3:sortCode>
                <ns3:relation></ns3:relation>
                <ns3:moduleType></ns3:moduleType>
                <ns3:iban></ns3:iban> 
        </ns3:accounts>}
        </ns3:data>
    </ns3:Response>
};

local:func($CCARResponse, $CCCARResponse)