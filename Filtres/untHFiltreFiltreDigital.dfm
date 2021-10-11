object frmHFiltreFiltreDigital: TfrmHFiltreFiltreDigital
  Left = 324
  Top = 231
  Width = 731
  Height = 316
  Caption = 'Filtre Digital'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bvbImages: TBevel
    Left = 8
    Top = 8
    Width = 569
    Height = 185
    Shape = bsFrame
  end
  object imgPrevisualisation: TImage
    Left = 584
    Top = 88
    Width = 128
    Height = 128
  end
  object lblPrevisualisation: TLabel
    Left = 584
    Top = 72
    Width = 79
    Height = 13
    Caption = 'Prévisualisation :'
  end
  object lblImage: TLabel
    Left = 16
    Top = 16
    Width = 35
    Height = 13
    Caption = 'Image :'
  end
  object btnOK: TButton
    Left = 636
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnAnnuler: TButton
    Left = 636
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Annuler'
    ModalResult = 2
    TabOrder = 1
  end
  object lstImage: TListBox
    Left = 16
    Top = 32
    Width = 553
    Height = 153
    ItemHeight = 45
    Style = lbOwnerDrawFixed
    TabOrder = 2
    OnClick = lstImageClick
    OnDrawItem = lstImageDrawItem
  end
  object grbParametres: TGroupBox
    Left = 8
    Top = 200
    Width = 569
    Height = 73
    Caption = 'Paramètres :'
    TabOrder = 3
    object lblTailleFiltre: TLabel
      Left = 16
      Top = 24
      Width = 71
      Height = 13
      Caption = 'Taille du Filtre :'
    end
    object edtTailleFiltre: TEdit
      Left = 16
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '10'
      OnChange = edtTailleFiltreChange
    end
  end
end
