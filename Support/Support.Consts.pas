unit Support.Consts;

interface
uses Messages;
const
  wm_CloseClient = wm_User + 1001;
  wm_ShowClientWindow = wm_User + 1002;

type
  TBrowseFormCommand = (efcmdNone,
                        efcmdNext, efcmdPrev, efcmdFirst, efcmdLast, efcmdAdd, efcmdEdit,
                        efcmdDelete, efcmdUndelete, efcmdViewDetail, efcmdPost,
                        efcmdClose, efcmdRefresh, efcmdSaveAsTemplate,
                        efcmdFind, efcmdPrint, efcmdActivateFilter, efcmdBuildFilter, efcmdDeactivateFilter
                       );


resourcestring
  SNoRecordFound = 'SNoRecordFound';

  SUsernameAndOrPasswordExpected = 'SUsernameAndOrPasswordExpected';
  SUsernameOrPasswordIsInvalid = 'SUsernameOrPasswordIsInvalid';
  SDatabaseNotFoundCreate = 'SDatabaseNotFoundCreate';
implementation

end.
