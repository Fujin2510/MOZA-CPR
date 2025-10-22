xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabank.org/POP_OBDX";
(:: import schema at "../Schema/POP.xsd" ::)
declare namespace ns1="http://xmlns.oracle.com/oxp/service/v2";
(:: import schema at "../Schema/ReportService.wsdl" ::)

declare variable $Response as element() (:: schema-element(ns1:runReportResponse) ::) external;

declare function local:func($Response as element() (:: schema-element(ns1:runReportResponse) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:data>
            <ns2:dictionaryArray></ns2:dictionaryArray>
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
                 <ns2:status>
        {
          let $base64 := xs:string(fn:data($Response/ns1:runReportReturn/ns1:reportBytes))
          return 
            if ($base64 != '' and string-length($base64) > 10) 
            then 'SUCCESS'
            else 'FAILURE'
        }
      </ns2:status>
                <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
            <ns2:base64>{fn:data($Response/ns1:runReportReturn/ns1:reportBytes)}</ns2:base64>
        </ns2:data>
    </ns2:Response>
};

local:func($Response)