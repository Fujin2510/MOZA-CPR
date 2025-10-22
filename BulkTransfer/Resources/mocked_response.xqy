xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.mozabanca.org/bulkTranser";
(:: import schema at "Bulk_Transfer.xsd" ::)

declare variable $Request as element() (:: schema-element(ns2:BulkStatusSyncRequest) ::) external;

declare function local:func($Request as element() (:: schema-element(ns2:BulkStatusSyncRequest) ::)) as element() (:: schema-element(ns2:BulkStatusSyncResponse) ::) {
    <ns2:BulkStatusSyncResponse>
        <ns2:data>
            {
                if ($Request/ns2:dictionaryArray)
                then <ns2:dictionaryArray>{fn:data($Request/ns2:dictionaryArray)}</ns2:dictionaryArray>
                else ()
            }
          
            <ns2:referenceNo></ns2:referenceNo>
            <ns2:result>
                <ns2:dictionaryArray></ns2:dictionaryArray>
                <ns2:externalReferenceId></ns2:externalReferenceId>
               <ns2:status>SUCCESS</ns2:status>

             
              <ns2:errorList></ns2:errorList>
                <ns2:warningList></ns2:warningList>
            </ns2:result>
            <ns2:hasMore></ns2:hasMore>
            <ns2:totalRecords></ns2:totalRecords>
            <ns2:startSequence></ns2:startSequence>
<ns2:fileProcessingDate>2025-09-15T00:00:00</ns2:fileProcessingDate>
            <ns2:fileStatus>PR</ns2:fileStatus>
            <ns2:totalAmount>1400.00</ns2:totalAmount>
            <ns2:currency>MZN</ns2:currency>
            <ns2:bankAccountIdentifier>1333821010001</ns2:bankAccountIdentifier>
            <ns2:clientNumber>13377555</ns2:clientNumber>
            <ns2:externalFileRefId>2</ns2:externalFileRefId>
            <ns2:operationNumber>1715711</ns2:operationNumber>
            <ns2:totalFileRecords>4</ns2:totalFileRecords>
        </ns2:data>
    </ns2:BulkStatusSyncResponse>
};

local:func($Request)