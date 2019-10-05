unit LocalTypes;

interface

type
  TDayExercise = record
    Id: Cardinal;
    Name: String;
    Params: String;
    Total: String;
  end;

  TDayExercises = array of TDayExercise;

  TDayExerciseItem = record
    Id: Cardinal;
    Params: String;
    Comments: String;
  end;

  TDayExerciseItems = array of TDayExerciseItem;

  TDayFood = record
    Id: Cardinal;
    Name: String;
    Amount: String;
    Comment: String;
  end;

  TDayFoods = array of TDayFood;

  TDayFoodParameter = record
    IdPage: Cardinal;
    Id: Cardinal;
    IdParent: Cardinal;
    Name: String;
    TargetMin: Double;
    TargetMax: Double;
    Amount: Double;
    UnitM: String;
    Comment: String;
    IsMain: Boolean;
  end;

  TDayFoodParameters = array of TDayFoodParameter;

  TDayOther = record
    Id: Cardinal;
    Name: String;
    Value: String;
    Main: Boolean;
    //Comment: String;
  end;

  TDayOthers = array of TDayOther;

  TFoodParameterContent = record
    Id: Cardinal;
    Name: String;
    Value: Double;
    Unitname: String;
    Main: Boolean;
  end;

  TFoodParameterContents = array of TFoodParameterContent;

  TTagEvent = record
    Id: Cardinal;
    Name: String;
    IsAutoReset: Boolean;
    IsChecked: Boolean;
    IsChangedToday: Boolean;
    Comment: String;
  end;

  TTagEvents = array of TTagEvent;

  TVarType = (vtInteger, vtDate, vtFlag);

  TReportVar=record
    Name: String;
    DisplayName: String;
    IsNullable: Boolean;
    VarType: TVarType;
    case TVarType of
      vtInteger: (ValInt: Integer;);
      vtDate: (ValDate: TDateTime;);
      vtFlag: (ValBool: Boolean;);
  end;

  TReportVars = array of TReportVar;

  TStringArray = array of String;
  TStringMatrix = array of TStringArray;

implementation

end.
