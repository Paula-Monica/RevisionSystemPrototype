program RevisionSystem;

uses
  Forms,
  LoginPage in 'LoginPage.pas' {LoginForm},
  CustomDialog in 'CustomDialog.pas' {CustomDialogForm},
  SignupPage in 'SignupPage.pas' {SignupForm},
  UserFillInDetails in 'UserFillInDetails.pas' {FillInDetailsFormStudent},
  UserFillInDetailsTeacher in 'UserFillInDetailsTeacher.pas' {FillInDetailsT},
  NavigationPageStudent in 'NavigationPageStudent.pas' {StudentNavigation},
  NavigationPageTeacher in 'NavigationPageTeacher.pas' {TeacherNavigation},
  ForgotPassword in 'ForgotPassword.pas' {ForgotPasswordForm},
  QuizSelection in 'QuizSelection.pas' {QuizSelect},
  QuizCompletion in 'QuizCompletion.pas' {CompleteQuiz},
  QuizResult in 'DATABASE\QuizResult.pas' {QuizOutcome},
  EditDetails in 'EditDetails.pas' {ChangeDetails},
  StudentPerformance in 'StudentPerformance.pas' {PerformanceStudent};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TPerformanceStudent, PerformanceStudent);
  Application.CreateForm(TChangeDetails, ChangeDetails);
  Application.CreateForm(TTeacherNavigation, TeacherNavigation);
  Application.CreateForm(TStudentNavigation, StudentNavigation);
  Application.CreateForm(TQuizSelect, QuizSelect);
  Application.CreateForm(TQuizOutcome, QuizOutcome);
  Application.CreateForm(TFillInDetailsT, FillInDetailsT);
  Application.CreateForm(TFillInDetailsFormStudent, FillInDetailsFormStudent);
  Application.CreateForm(TSignupForm, SignupForm);
  Application.CreateForm(TCustomDialogForm, CustomDialogForm);
  Application.CreateForm(TForgotPasswordForm, ForgotPasswordForm);
  Application.CreateForm(TCompleteQuiz, CompleteQuiz);
  Application.Run;
  end.
