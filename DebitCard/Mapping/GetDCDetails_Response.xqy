xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns3="http://www.mozabanca.org/CDOD-MSB";
(:: import schema at "../Schema/CDOD-MSB.xsd" ::)
declare namespace ns1="http://www.mozabank.org/CCARDebitCard";
(:: import schema at "../Schema/CCAR.xsd" ::)
declare namespace ns2="http://www.mozabank.org/debitCardDetails";
(:: import schema at "../Schema/GetDebitcardDetailsV1.xsd" ::)

declare variable $CcarResponse as element() (:: schema-element(ns1:Response) ::) external;
declare variable $CdodResponse as element() (:: schema-element(ns3:Response) ::) external;
declare variable $idVar as xs:string external;
declare function local:func($CcarResponse as element() (:: schema-element(ns1:Response) ::), 
                            $CdodResponse as element() (:: schema-element(ns3:Response) ::),$idVar) 
                            as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
           <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                <ns2:status>{if($CcarResponse/ns1:errorCode) then 'SUCCESS' else 'FAILURE'}</ns2:status>
                {if(fn:data($CcarResponse/ns1:errorCode) = 0) then () else(
                <ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
                </ns2:errorList>) }
            <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            {
            let $debit := $CcarResponse/ns1:operationData/ns1:CCAR_O_0003[ns1:CCAR_O_0003_0001 = $idVar]
            return
            <ns2:debitCardDetails>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:accountId>{fn:data($debit/ns1:CCAR_O_0003_0006)}</ns2:accountId>
                <ns2:branchId>{fn:data($CdodResponse/ns3:operationData/ns3:CDOD_O_0003)}</ns2:branchId>
                <ns2:partyId></ns2:partyId>
                <ns2:branchName>{fn:data($CdodResponse/ns3:operationData/ns3:CDOD_O_0004)}</ns2:branchName>
                <ns2:id></ns2:id><!-- value to be taken from OBDX request-->
                <ns2:displayValue>{fn:data($debit/ns1:CCAR_O_0003_0004)}</ns2:displayValue>
                <ns2:currencyCode>{fn:data($debit/ns1:CCAR_O_0003_0002)}</ns2:currencyCode>
                <ns2:status>{fn:data($debit/ns1:CCAR_O_0003_00101)}</ns2:status>
                <ns2:issueDate>
                {let $date := fn:data($debit/ns1:CCAR_O_0003_0007) return 
                if (normalize-space($date) != '') then
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns2:issueDate>
                <ns2:expiryDate>
                {let $date := fn:data($debit/ns1:CCAR_O_0003_0008) return 
                if (normalize-space($date) != '') then
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns2:expiryDate>
                <ns2:applicationDate>
                {let $date := fn:data($debit/ns1:CCAR_O_0003_0007) return 
                if (normalize-space($date) != '') then
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns2:applicationDate>
                <ns2:cardRenewalDate>
                {let $date := fn:data($debit/ns1:CCAR_O_0003_0008) return 
                if (normalize-space($date) != '') then
                    concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()}
                </ns2:cardRenewalDate>
                <ns2:cardActivationDate>
                {
                  let $status := fn:data($debit/ns1:CCAR_O_0003_0011)
                  let $date := fn:data($debit/ns1:CCAR_O_0003_0012)
                  return
                    if ($status = 'Normal' and normalize-space($date) != '') then
                      concat(substring($date, 1, 4), '-', substring($date, 5, 2), '-', substring($date, 7, 2), 'T00:00:00')
                    else ()
                }</ns2:cardActivationDate>
                <ns2:dispatchStatus>
                {
                  let $status := fn:data($debit/ns1:CCAR_O_0003_0011)
                  return
                    if ($status = 'Normal') then 'D' else ()
                }
                </ns2:dispatchStatus>
                <ns2:pinMailStatus>
                {
                  let $status := fn:data($debit/ns1:CCAR_O_0003_0011)
                  return
                    if ($status = 'Normal') then 'D' else ()
                }
                </ns2:pinMailStatus>
                <ns2:cardHolderName>{fn:data($debit/ns1:CCAR_O_0003_0004)}</ns2:cardHolderName>
                <ns2:cardType>{fn:data($debit/ns1:CCAR_O_0003_0013)}</ns2:cardType>
                <ns2:isPrimary>true</ns2:isPrimary>
                <ns2:internationalUsage>true</ns2:internationalUsage>
                <ns2:debitCardLimitDetails>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:unit></ns2:unit>
                    <ns2:amount>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:amount>
                    <ns2:count></ns2:count>
                    <ns2:limitType></ns2:limitType>
                    <ns2:maxLimitAmount>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:maxLimitAmount>
                </ns2:debitCardLimitDetails>
                <ns2:debitCardInternationalLimitDetails>
                    <ns2:dictionaryArray></ns2:dictionaryArray>
                    <ns2:unit></ns2:unit>
                    <ns2:amount>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:amount>
                    <ns2:count></ns2:count>
                    <ns2:limitType></ns2:limitType>
                    <ns2:maxLimitAmount>
                        <ns2:currency></ns2:currency>
                        <ns2:amount></ns2:amount>
                    </ns2:maxLimitAmount>
                </ns2:debitCardInternationalLimitDetails>
                <ns2:totalAmountLimit>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:totalAmountLimit>
                <ns2:totalAmountMaxLimit>
                    <ns2:currency></ns2:currency>
                    <ns2:amount></ns2:amount>
                </ns2:totalAmountMaxLimit>
            </ns2:debitCardDetails>
            }
        </ns2:data>
    </ns2:Response>
};

local:func($CcarResponse, $CdodResponse,$idVar)