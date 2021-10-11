inherited frmFiltreGauss: TfrmFiltreGauss
  Caption = 'Flou Gauss d'#39'une Image'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  inherited grbParametres: TGroupBox
    object lblDeviation: TLabel [1]
      Left = 176
      Top = 24
      Width = 51
      Height = 13
      Caption = 'Déviation :'
    end
    object edtDeviation: TEdit
      Left = 176
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '2'
      OnChange = edtDeviationChange
    end
  end
end
