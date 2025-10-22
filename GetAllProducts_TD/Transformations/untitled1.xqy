xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns1="http://www.mozabank.org/CAPD";
(:: import schema at "../Schema/CAPD.xsd" ::)
declare namespace ns2="http://www.mozabank.org/ccap_msb";
(:: import schema at "../Schema/CCAP.xsd" ::)
declare namespace ns4="http://www.mozabank.org/ccap_td_product_details";
(:: import schema at "../Schema/TD_PRODUCT_DETAILS.xsd" ::)
declare namespace ns3="http://www.mozabank.org/ccap_tdlist";
(:: import schema at "../Schema/TD_LIST.xsd" ::)

declare variable $CAPD as element() (:: schema-element(ns1:CAPDResponse) ::) external;
declare variable $CCAp as element() (:: schema-element(ns2:Response) ::) external;
declare variable $TDProductDetails as element() (:: schema-element(ns4:Response) ::) external;

declare function local:func($CAPD as element() (:: schema-element(ns1:CAPDResponse) ::), 
                            $CCAp as element() (:: schema-element(ns2:Response) ::), 
                            $TDProductDetails as element()(:: schema-element(ns4:Response) ::)) 
                            as element() (:: schema-element(ns3:Response) ::) {
    <ns3:Response/>
};

local:func($CAPD, $CCAp, $TDProductDetails)