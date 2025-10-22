xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/genericPaymentDate";
(:: import schema at "GENERIC_PAYMENT_DATE.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ptfi";
(:: import schema at "PTFI.xsd" ::)

declare variable $req as element() (:: schema-element(ns1:Request) ::) external;

declare function local:func($req as element() (:: schema-element(ns1:Request) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:transactionCode></ns2:transactionCode>
        <ns2:operationData>
            <ns2:PTFI_O_0001></ns2:PTFI_O_0001>
            <ns2:PTFI_O_0002></ns2:PTFI_O_0002>
            <ns2:PTFI_O_0003></ns2:PTFI_O_0003>
            <ns2:PTFI_O_0004></ns2:PTFI_O_0004>
        </ns2:operationData>
    </ns2:Response>
};

local:func($req)