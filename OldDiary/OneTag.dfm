object frmOneTag: TfrmOneTag
  Left = 0
  Top = 0
  Caption = #1058#1080#1087' '#1089#1086#1073#1099#1090#1080#1103
  ClientHeight = 295
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblName: TLabel
    Left = 8
    Top = 11
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object btnCancel: TButton
    Left = 8
    Top = 262
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnOk: TButton
    Left = 89
    Top = 262
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 1
    OnClick = btnOkClick
  end
  object edtName: TEdit
    Left = 91
    Top = 8
    Width = 246
    Height = 21
    TabOrder = 2
  end
  object chkAutoReset: TCheckBox
    Left = 8
    Top = 37
    Width = 329
    Height = 17
    Caption = #1054#1076#1085#1086#1076#1085#1077#1074#1085#1086#1077' '#1089#1086#1073#1099#1090#1080#1077
    TabOrder = 3
  end
  object mmoComments: TMemo
    Left = 8
    Top = 60
    Width = 329
    Height = 196
    TabOrder = 4
  end
end
