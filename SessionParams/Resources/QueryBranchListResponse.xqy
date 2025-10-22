xquery version "1.0" encoding "utf-8";

(:: OracleAnnotationVersion "1.0" ::)

declare namespace ns2="http://www.example.org";
(:: import schema at "QueryBranchList.xsd" ::)
declare namespace ns1="http://xmlns.oracle.com/pcbpel/adapter/db/top/QueryBranchListBS";
(:: import schema at "QueryBranchListBS_table.xsd" ::)

declare variable $QueryBranchListResponse as element() (:: schema-element(ns1:BranchListCachedResultCollection) ::) external;

declare function local:func($QueryBranchListResponse as element() (:: schema-element(ns1:BranchListCachedResultCollection) ::)) as element() (:: schema-element(ns2:Response) ::) {
    <ns2:Response>
        <ns2:BranchIdResponse>{fn:data($QueryBranchListResponse/ns1:BranchListCachedResult/ns1:branchListResponse)}</ns2:BranchIdResponse>
    </ns2:Response>
};

local:func($QueryBranchListResponse)