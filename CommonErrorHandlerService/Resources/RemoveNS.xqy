xquery version "1.0" encoding "utf-8";

declare namespace ns1 = "http://www.example.com/ns"; (: your source namespace :)

declare variable $input as element(ns1:Request) external;

<root>{
  for $child in $input/*
  return element {local-name($child)} {
    $child/text()
  }
}</root>