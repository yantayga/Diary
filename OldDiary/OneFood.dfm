object frmOneFood: TfrmOneFood
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1076#1091#1082#1090
  ClientHeight = 490
  ClientWidth = 346
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 8
    Top = 9
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lblUnit: TLabel
    Left = 8
    Top = 34
    Width = 64
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
  end
  object edtName: TEdit
    Left = 91
    Top = 6
    Width = 246
    Height = 21
    TabOrder = 0
  end
  object chkActive: TCheckBox
    Left = 264
    Top = 32
    Width = 74
    Height = 19
    Caption = #1040#1082#1090#1080#1074#1085#1099#1081
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 91
    Top = 457
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 10
    Top = 457
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object mmoComments: TMemo
    Left = 8
    Top = 415
    Width = 330
    Height = 33
    TabOrder = 4
  end
  object sgParameters: TStringGrid
    Left = 8
    Top = 60
    Width = 330
    Height = 349
    ColCount = 2
    DefaultRowHeight = 18
    FixedColor = clWindow
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goThumbTracking]
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object edtDefaultAmount: TEdit
    Left = 91
    Top = 31
    Width = 75
    Height = 21
    TabOrder = 6
    OnExit = edtDefaultAmountExit
  end
  object cbbUnit: TComboBox
    Left = 172
    Top = 31
    Width = 86
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
  end
end
