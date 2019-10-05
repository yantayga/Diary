object frmOneExecution: TfrmOneExecution
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 566
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
  object lblParam0: TLabel
    Left = 8
    Top = 410
    Width = 36
    Height = 13
    Caption = 'Param0'
  end
  object lblUnit0: TLabel
    Left = 167
    Top = 410
    Width = 25
    Height = 13
    Caption = 'Unit0'
  end
  object lblParam1: TLabel
    Left = 8
    Top = 442
    Width = 36
    Height = 13
    Caption = 'Param1'
  end
  object lblUnit1: TLabel
    Left = 167
    Top = 442
    Width = 25
    Height = 13
    Caption = 'Unit1'
  end
  object lblDate: TLabel
    Left = 8
    Top = 8
    Width = 30
    Height = 13
    Caption = #1044#1072#1090#1072':'
  end
  object lblParam2: TLabel
    Left = 8
    Top = 474
    Width = 36
    Height = 13
    Caption = 'Param2'
  end
  object lblUnit2: TLabel
    Left = 167
    Top = 474
    Width = 25
    Height = 13
    Caption = 'Unit2'
  end
  object edtParam0: TEdit
    Left = 81
    Top = 407
    Width = 80
    Height = 21
    TabOrder = 2
    OnExit = edtParam0Exit
  end
  object btnOk: TButton
    Left = 97
    Top = 532
    Width = 75
    Height = 25
    Caption = #1054#1050
    Default = True
    TabOrder = 7
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 8
    Top = 532
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object edtParam1: TEdit
    Left = 81
    Top = 439
    Width = 80
    Height = 21
    TabOrder = 3
    OnExit = edtParam1Exit
  end
  object mmoComment: TMemo
    Left = 264
    Top = 407
    Width = 195
    Height = 87
    ReadOnly = True
    TabOrder = 5
  end
  object edtExComment: TEdit
    Left = 8
    Top = 500
    Width = 451
    Height = 21
    TabOrder = 6
    OnKeyPress = edtExCommentKeyPress
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
  object edtParam2: TEdit
    Left = 81
    Top = 471
    Width = 80
    Height = 21
    TabOrder = 4
    OnExit = edtParam2Exit
  end
  object lstExList: TListBox
    Left = 8
    Top = 34
    Width = 451
    Height = 359
    ItemHeight = 13
    TabOrder = 1
    OnClick = lstExListClick
  end
  object chkShowAll: TCheckBox
    Left = 362
    Top = 7
    Width = 97
    Height = 17
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
    TabOrder = 9
    OnClick = chkShowAllClick
  end
end
