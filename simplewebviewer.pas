{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit SimpleWebViewer; 

interface

uses
  USimpleWebViewer, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('USimpleWebViewer', @USimpleWebViewer.Register); 
end; 

initialization
  RegisterPackage('SimpleWebViewer', @Register); 
end.
