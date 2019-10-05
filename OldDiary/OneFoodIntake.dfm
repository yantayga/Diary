object frmOneFoodIntake: TfrmOneFoodIntake
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 658
  ClientWidth = 467
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblAmount: TLabel
    Left = 8
    Top = 541
    Width = 64
    Height = 13
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086':'
  end
  object lblFoodList: TLabel
    Left = 8
    Top = 35
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lblDate: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = #1044#1072#1090#1072':'
  end
  object lblUnit: TLabel
    Left = 187
    Top = 65
    Width = 4
    Height = 13
    Caption = '.'
  end
  object lblUnitName: TLabel
    Left = 186
    Top = 541
    Width = 145
    Height = 13
    AutoSize = False
    Caption = '.'
  end
  object edtAmount: TEdit
    Left = 93
    Top = 538
    Width = 87
    Height = 21
    TabOrder = 2
    OnExit = edtAmountExit
  end
  object btnOk: TButton
    Left = 89
    Top = 627
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 8
    Top = 627
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object mmoComment: TMemo
    Left = 8
    Top = 564
    Width = 451
    Height = 30
    ReadOnly = True
    TabOrder = 5
  end
  object edtExComment: TEdit
    Left = 8
    Top = 600
    Width = 451
    Height = 21
    TabOrder = 6
  end
  object dtpDate: TDateTimePicker
    Left = 93
    Top = 7
    Width = 176
    Height = 21
    Date = 41534.520286354160000000
    Time = 41534.520286354160000000
    TabOrder = 7
  end
  object edtFilterName: TEdit
    Left = 93
    Top = 32
    Width = 254
    Height = 21
    TabOrder = 0
    OnChange = edtFilterNameChange
  end
  object lstFoodList: TListBox
    Left = 8
    Top = 59
    Width = 451
    Height = 473
    ItemHeight = 13
    TabOrder = 1
    OnClick = lstFoodListClick
    OnDblClick = lstFoodListDblClick
  end
  object chkActive: TCheckBox
    Left = 353
    Top = 36
    Width = 106
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1074#1089#1077
    TabOrder = 8
    OnClick = chkActiveClick
  end
end
