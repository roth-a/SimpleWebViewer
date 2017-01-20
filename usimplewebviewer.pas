unit USimpleWebViewer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls, IpHtml;

type
  TSimpleIpHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;


  { TSimpleWebViewer }

  TSimpleWebViewer = class(TIpHtmlPanel)
  private
    { Private declarations }
    procedure PanelHotClick(Sender: TObject);
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
  protected
    { Protected declarations }
  public
    procedure LoadFromFile(const Filename: string);
    procedure LoadFromString(atext: string);
    procedure LoadFromStringStream(atextstream: TStream);
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Misc', [TSimpleWebViewer]);
end;




procedure TSimpleWebViewer.PanelHotClick(Sender: TObject);
var
  NodeA: TIpHtmlNodeA;
  NewFilename: string;
begin
  if self.HotNode is TIpHtmlNodeA then
    begin
    NodeA := TIpHtmlNodeA(HotNode);
    NewFilename := NodeA.HRef;
    LoadFromFile(NewFilename);
    end;
end;

procedure TSimpleWebViewer.HTMLGetImageX(Sender: TIpHtmlNode; const URL: string; var Picture: TPicture);
var
  PicCreated: boolean;
begin
    try
    if FileExists(URL) then
      begin
      PicCreated := False;
      if Picture = nil then
        begin
        Picture    := TPicture.Create;
        PicCreated := True;
        end;
      Picture.LoadFromFile(URL);
      end;
    except
    if PicCreated then
      Picture.Free;
    Picture := nil;
    end;
end;

procedure TSimpleWebViewer.LoadFromFile(const Filename: string);
var
  fs:      TFileStream;
  NewHTML: TSimpleIpHtml;
begin
    try
    fs := TFileStream.Create(Filename, fmOpenRead);
      try
      NewHTML := TSimpleIpHtml.Create; // Beware: Will be freed automatically by Panel
      NewHTML.OnGetImageX := @HTMLGetImageX;
      NewHTML.LoadFromStream(fs);
      finally
      fs.Free;
      end;
    SetHtml(NewHTML);
    except
    on E: Exception do
      begin
      MessageDlg('Unable to open HTML file',
        'HTML File: ' + Filename + #13 + 'Error: ' + E.Message, mtError, [mbCancel], 0);
      end;
    end;
end;


procedure TSimpleWebViewer.LoadFromString(atext: string);
var
  ss:      TStringStream;
  NewHTML: TSimpleIpHtml;
begin
    try
    ss := TStringStream.Create(atext);
      try
      NewHTML := TSimpleIpHtml.Create; // Beware: Will be freed automatically by Panel
      NewHTML.OnGetImageX := @HTMLGetImageX;
      NewHTML.LoadFromStream(ss);
      finally
      ss.Free;
      end;
    SetHtml(NewHTML);
    except
    on E: Exception do
      begin
      MessageDlg('Unable to open HTML file', #13 + 'Error: ' + E.Message, mtError, [mbCancel], 0);
      end;
    end;
end;


procedure TSimpleWebViewer.LoadFromStringStream(atextstream: TStream);
var
  NewHTML: TSimpleIpHtml;
begin
    try
    NewHTML := TSimpleIpHtml.Create; // Beware: Will be freed automatically by Panel
    NewHTML.OnGetImageX := @HTMLGetImageX;
    NewHTML.LoadFromStream(atextstream);
    SetHtml(NewHTML);
    except
    on E: Exception do
      begin
      MessageDlg('Unable to open HTML file', #13 + 'Error: ' + E.Message, mtError, [mbCancel], 0);
      end;
    end;
end;

end.
