object frmTrackEvent: TfrmTrackEvent
  Left = 0
  Top = 0
  BiDiMode = bdLeftToRight
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088
  ClientHeight = 360
  ClientWidth = 274
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  ParentBiDiMode = False
  Position = poMainFormCenter
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblDate: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = #1044#1072#1090#1072':'
  end
  object lblExList: TLabel
    Left = 8
    Top = 35
    Width = 53
    Height = 13
    Caption = #1055#1072#1088#1072#1084#1077#1090#1088':'
  end
  object lblParam0: TLabel
    Left = 8
    Top = 275
    Width = 52
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077':'
  end
  object lblUnit0: TLabel
    Left = 167
    Top = 275
    Width = 25
    Height = 13
    Caption = 'Unit0'
  end
  object dtpDate: TDateTimePicker
    Left = 81
    Top = 7
    Width = 186
    Height = 21
    Date = 41534.520286354160000000
    Time = 41534.520286354160000000
    TabOrder = 0
  end
  object edtParam0: TEdit
    Left = 81
    Top = 272
    Width = 80
    Height = 21
    TabOrder = 3
    OnExit = edtParam0Exit
  end
  object edtExComment: TEdit
    Left = 8
    Top = 300
    Width = 259
    Height = 21
    TabOrder = 4
  end
  object btnOk: TButton
    Left = 89
    Top = 327
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 5
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 8
    Top = 327
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 6
    OnClick = btnCancelClick
  end
  object chkAll: TCheckBox
    Left = 81
    Top = 34
    Width = 185
    Height = 17
    BiDiMode = bdLeftToRight
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077
    ParentBiDiMode = False
    TabOrder = 1
    OnClick = chkAllClick
  end
  object lstParameters: TListBox
    Left = 8
    Top = 56
    Width = 258
    Height = 210
    ItemHeight = 13
    TabOrder = 2
    OnClick = lstParametersClick
  end
end
