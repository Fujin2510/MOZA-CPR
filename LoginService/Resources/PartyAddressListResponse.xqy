xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/nxsd/REST";
(:: import schema at "SchemaRest.xsd" ::)
declare namespace ns2="http://www.mozabank.org/PartyAddressList";
(:: import schema at "PartyAddressList.xsd" ::)

declare variable $PartyAddressListResposne as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($PartyAddressListResposne as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
             
        <ns2:result>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:externalReferenceId></ns2:externalReferenceId>
            <ns2:status>{if(fn:data($PartyAddressListResposne/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = 0) then 'SUCCESS' else 'FAILURE'}
          </ns2:status>
          {if(fn:data($PartyAddressListResposne/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:status/ns1:codigo) = 0) then ()
            else(<ns2:errorList>
                <ns2:code>ERR001</ns2:code>
                <ns2:message>Invalid backend response</ns2:message>
            </ns2:errorList> )
            }
            <ns2:warningList></ns2:warningList>
        </ns2:result>
        <ns2:addressInfo>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:address>
                <ns2:line1>{fn:data($PartyAddressListResposne/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:morada)}</ns2:line1>
                <ns2:line2>{fn:data($PartyAddressListResposne/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:morada2)}</ns2:line2>
                <ns2:line3></ns2:line3>
                <ns2:line4></ns2:line4>
                <ns2:line5></ns2:line5>
                <ns2:line6></ns2:line6>
                <ns2:line7></ns2:line7>
                <ns2:line8></ns2:line8>
                <ns2:line9></ns2:line9>
                <ns2:line10></ns2:line10>
                <ns2:line11></ns2:line11>
                <ns2:line12></ns2:line12>
                <ns2:city>{fn:data($PartyAddressListResposne/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:desPostal)}</ns2:city>
                <ns2:addressTypeDescription></ns2:addressTypeDescription>
                <ns2:state></ns2:state>
           
 <ns2:country>MZ</ns2:country>
                <ns2:zipCode>{fn:data($PartyAddressListResposne/ns1:body/ns1:consultarElementosEntidadeResponse/ns1:output/ns1:codPostal)}</ns2:zipCode>
            </ns2:address>
            <ns2:type>RES</ns2:type>
        </ns2:addressInfo>
       </ns2:data>
    </ns2:Response>
};

local:func($PartyAddressListResposne)