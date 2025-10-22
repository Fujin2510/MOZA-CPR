xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/nxsd/REST";
(:: import schema at "SchemaRest.xsd" ::)
declare namespace ns2="http://www.mozabank.org/PartyContactList";
(:: import schema at "PartyContactList.xsd" ::)

declare variable $EntityDataResponse as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($EntityDataResponse as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            
        <ns2:dictionaryArray></ns2:dictionaryArray>
        <ns2:referenceNo></ns2:referenceNo>
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{if(fn:data($EntityDataResponse/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = 0) then 'SUCCESS' else 'FAILURE'}</ns2:status>
             {if(fn:data($EntityDataResponse/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = '0') then () else(
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
         
        <ns2:contactInfo> 
                    <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:isEmailCommunicationAllowed></ns2:isEmailCommunicationAllowed>
            <ns2:preferredModeOfCommunication></ns2:preferredModeOfCommunication>
<ns2:phone/>
<ns2:fax/>
            <ns2:contactType>WEM</ns2:contactType> 
           {
                if ($EntityDataResponse/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:email1)
                then <ns2:email>{fn:data($EntityDataResponse/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:email1)}</ns2:email>
                else ()
            }
        </ns2:contactInfo>
         <ns2:contactInfo>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:isEmailCommunicationAllowed></ns2:isEmailCommunicationAllowed>
            <ns2:preferredModeOfCommunication></ns2:preferredModeOfCommunication>
            <ns2:contactType>WMO</ns2:contactType>
            <ns2:phone>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:areaCode></ns2:areaCode>
                <ns2:number>{fn:data($EntityDataResponse/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:telefone1)}</ns2:number>
                <ns2:extension></ns2:extension>
            </ns2:phone>
            <ns2:fax>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:areaCode></ns2:areaCode>
                <ns2:number></ns2:number>
            </ns2:fax>
          <ns2:email/>
        </ns2:contactInfo>
          </ns2:data>
    </ns2:Response>
};

local:func($EntityDataResponse)