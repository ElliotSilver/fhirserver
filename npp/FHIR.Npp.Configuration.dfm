inherited SettingForm: TSettingForm
  ActiveControl = edtServerR2
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'FHIR notepad++ Plugin Settings'
  ClientHeight = 414
  ClientWidth = 699
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 705
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  object TButton
    Left = 8
    Top = 206
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 0
    OnClick = btnEditAsTextClick
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 699
    Height = 373
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Configuration'
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 691
        Height = 345
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 0
          Top = 133
          Width = 691
          Height = 132
          Align = alTop
          Caption = ' Terminology Servers'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          DesignSize = (
            691
            132)
          object Label1: TLabel
            Left = 12
            Top = 24
            Width = 17
            Height = 13
            Caption = 'R2:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label2: TLabel
            Left = 12
            Top = 106
            Width = 662
            Height = 23
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 
              'Each server must be a FHIR terminology server running the versio' +
              'n specified, and must not require authentication'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object Label6: TLabel
            Left = 12
            Top = 51
            Width = 17
            Height = 13
            Caption = 'R3:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object Label7: TLabel
            Left = 12
            Top = 78
            Width = 17
            Height = 13
            Caption = 'R4:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object edtServerR2: TEdit
            Left = 50
            Top = 21
            Width = 624
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object edtServerR3: TEdit
            Left = 50
            Top = 48
            Width = 624
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object edtServerR4: TEdit
            Left = 50
            Top = 75
            Width = 624
            Height = 21
            Anchors = [akLeft, akTop, akRight]
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
        object GroupBox2: TGroupBox
          Left = 0
          Top = 0
          Width = 691
          Height = 133
          Align = alTop
          Caption = '  FHIR Versions'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          object Bevel1: TBevel
            Left = 267
            Top = 6
            Width = 421
            Height = 79
          end
          object Label3: TLabel
            Left = 288
            Top = 13
            Width = 386
            Height = 61
            AutoSize = False
            Caption = 
              'You can load any of these, though at least one is required. The ' +
              'only penalty for supporting more than one version is the amount ' +
              'of memory used loading the hl7.fhir.core package for the version' +
              '. This setting only takes effect when Notepad++ is restarted'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            WordWrap = True
          end
          object Label4: TLabel
            Left = 24
            Top = 96
            Width = 273
            Height = 13
            Caption = 'These are only enabled when the packages are installed. '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblR2Status: TLabel
            Left = 103
            Top = 21
            Width = 39
            Height = 13
            Caption = 'Status...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblR3Status: TLabel
            Left = 103
            Top = 42
            Width = 39
            Height = 13
            Caption = 'Status...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object lblR4Status: TLabel
            Left = 103
            Top = 65
            Width = 39
            Height = 13
            Caption = 'Status...'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
          object cbR2: TCheckBox
            Left = 24
            Top = 19
            Width = 73
            Height = 17
            Caption = 'R2 (1.0)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object cbR3: TCheckBox
            Left = 24
            Top = 42
            Width = 73
            Height = 17
            Caption = 'R3 (3.0)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object cbR4: TCheckBox
            Left = 24
            Top = 65
            Width = 73
            Height = 17
            Caption = 'R4 (4.0)'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
          object Button3: TButton
            Left = 303
            Top = 91
            Width = 106
            Height = 25
            Caption = 'Package Manager'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 3
            OnClick = Button3Click
          end
        end
        object Panel5: TPanel
          Left = 0
          Top = 320
          Width = 691
          Height = 25
          Align = alBottom
          BevelOuter = bvLowered
          TabOrder = 2
          object Label5: TLabel
            Left = 4
            Top = 4
            Width = 337
            Height = 13
            Caption = 
              'The changes on this page only take effect when notepad++ is rest' +
              'arted'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
          end
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Settings'
      ImageIndex = 2
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 691
        Height = 345
        Align = alClient
        BevelOuter = bvNone
        ParentBackground = False
        ParentColor = True
        TabOrder = 0
        object GroupBox3: TGroupBox
          Left = 0
          Top = 115
          Width = 691
          Height = 67
          Align = alTop
          Caption = '  Path Summary Dialog  '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          DesignSize = (
            691
            67)
          object cbPathSummary: TCheckBox
            Left = 27
            Top = 27
            Width = 661
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Show Summary Dialog after evaluating a FHIR Path'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object GroupBox4: TGroupBox
          Left = 0
          Top = 0
          Width = 691
          Height = 111
          Align = alTop
          Caption = '  Validation'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Padding.Bottom = 10
          ParentFont = False
          TabOrder = 1
          DesignSize = (
            691
            111)
          object cbValidationSummary: TCheckBox
            Left = 27
            Top = 27
            Width = 661
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'Show Summary Dialog after performing validation'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object cbValidationAnnotations: TCheckBox
            Left = 27
            Top = 73
            Width = 542
            Height = 17
            Caption = 'Show Validation Messages in the Text Directly'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 1
          end
          object cbBackgroundValidation: TCheckBox
            Left = 27
            Top = 50
            Width = 377
            Height = 17
            Caption = 'Background Validation'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
          end
        end
        object GroupBox5: TGroupBox
          Left = 0
          Top = 186
          Width = 691
          Height = 67
          Align = alTop
          Caption = '  Welcome Screen'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 2
          object chkWelcome: TCheckBox
            Left = 30
            Top = 27
            Width = 658
            Height = 17
            Caption = 'Show the welcome screen'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
        end
        object Panel6: TPanel
          Left = 0
          Top = 111
          Width = 691
          Height = 4
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 3
        end
        object Panel7: TPanel
          Left = 0
          Top = 182
          Width = 691
          Height = 4
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Servers'
      ImageIndex = 1
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 691
        Height = 37
        Align = alTop
        BevelOuter = bvLowered
        ParentBackground = False
        TabOrder = 0
        object btnAdd: TButton
          Left = 3
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnEdit: TButton
          Left = 69
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Edit'
          TabOrder = 1
          OnClick = btnEditClick
        end
        object btnDelete: TButton
          Left = 135
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Delete'
          TabOrder = 2
          OnClick = btnDeleteClick
        end
        object btnUp: TButton
          Left = 201
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Up'
          TabOrder = 3
          OnClick = btnUpClick
        end
        object btnDown: TButton
          Left = 267
          Top = 6
          Width = 60
          Height = 25
          Caption = 'Down'
          TabOrder = 4
          OnClick = btnDownClick
        end
      end
      object vtServers: TVirtualStringTree
        Left = 0
        Top = 37
        Width = 691
        Height = 308
        Align = alClient
        Header.AutoSizeIndex = 1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'Tahoma'
        Header.Font.Style = []
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        TabOrder = 1
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnGetText = vtServersGetText
        Columns = <
          item
            Position = 0
            Width = 150
            WideText = 'Name'
          end
          item
            Position = 1
            Width = 237
            WideText = 'URL'
          end
          item
            Position = 2
            WideText = 'Version'
          end
          item
            Position = 3
            WideText = 'Format'
          end
          item
            Position = 4
            Width = 100
            WideText = 'Smart on FHIR'
          end
          item
            Position = 5
            Width = 100
            WideText = 'CDS-Hooks'
          end>
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 373
    Width = 699
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      699
      41)
    object Button1: TButton
      Left = 535
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Ok'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 616
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      OnClick = Button2Click
    end
    object btnEditAsText: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Edit as Text'
      ModalResult = 1
      TabOrder = 2
      OnClick = btnEditAsTextClick
    end
  end
  object od: TOpenDialog
    DefaultExt = '.zip'
    Filter = '*.zip'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Select Definitions Source'
    Left = 88
    Top = 378
  end
end
