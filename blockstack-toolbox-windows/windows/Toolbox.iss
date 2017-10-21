#define MyAppName "Blockstack Browser"
#define MyAppPublisher "Blockstack"
#define MyAppURL "https://blockstack.org"
#define MyAppContact "https://blockstack.org"

#define b2dIsoPath "..\bundle\boot2docker.iso"
#define dockerCli "..\bundle\docker.exe"
#define dockerMachineCli "..\bundle\docker-machine.exe"
#define dockerComposeCli "..\bundle\docker-compose.exe"
#define git "..\bundle\Git.exe"
#define virtualBoxCommon "..\bundle\common.cab"
#define virtualBoxMsi "..\bundle\VirtualBox_amd64.msi"

[Setup]
AppCopyright={#MyAppPublisher}
AppId={{3EFFB428-AFF2-4AAF-81C5-0C812995B250}
AppContact={#MyAppContact}
AppComments={#MyAppURL}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
DefaultDirName={pf}\Blockstack Toolbox
DefaultGroupName=Blockstack
DisableProgramGroupPage=yes
DisableWelcomePage=no
OutputBaseFilename=BlockstackToolbox
Compression=lzma
SolidCompression=yes
WizardImageFile=windows-installer-side.bmp
WizardSmallImageFile=windows-installer-logo.bmp
WizardImageStretch=yes
UninstallDisplayIcon={app}\unins000.exe
SetupIconFile=toolbox.ico
ChangesEnvironment=true

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Types]
Name: "full"; Description: "Full installation"

[Run]
Filename: "{win}\explorer.exe"; Parameters: "{userprograms}\Blockstack\"; Flags: postinstall skipifsilent; Description: "View Shortcuts in File Explorer"

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"
Name: modifypath; Description: "Add Blockstack and Docker binaries to &PATH"
Name: upgradevm; Description: "Upgrade Boot2Docker VM"

[Components]
Name: "BlockstackDocker"; Description: "Blockstack Launcher" ; Types: full; Flags: fixed
Name: "BlockstackD4W"; Description: "Blockstack Docker Scripts" ; Types: full; Flags: fixed
Name: "Docker"; Description: "Docker Client for Windows" ; Types: full; Flags: fixed
Name: "DockerMachine"; Description: "Docker Machine for Windows" ; Types: full; Flags: fixed
Name: "VirtualBox"; Description: "VirtualBox"; Types: full; Flags: disablenouninstallwarning
Name: "Git"; Description: "Git for Windows"; Types: full; Flags: disablenouninstallwarning

[Files]
Source: ".\blockstack.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#dockerCli}"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: ".\start.sh"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: ".\docker_shell.sh"; DestDir: "{app}"; Flags: ignoreversion; Components: "Docker"
Source: ".\start_d4w.sh"; DestDir: "{app}"; Flags: ignoreversion; Components: "BlockstackD4W"
Source: ".\docker_shell_d4w.sh"; DestDir: "{app}"; Flags: ignoreversion; Components: "BlockstackD4W"
Source: ".\blockstack.bat"; DestDir: "{app}"; Flags: ignoreversion; Components: "BlockstackDocker"
Source: ".\launcher"; DestDir: "{app}"; Flags: ignoreversion; Components: "BlockstackDocker"
Source: "{#dockerMachineCli}"; DestDir: "{app}"; Flags: ignoreversion; Components: "DockerMachine"
Source: "{#b2dIsoPath}"; DestDir: "{app}"; Flags: ignoreversion; Components: "DockerMachine"; AfterInstall: CopyBoot2DockerISO()
Source: "{#git}"; DestDir: "{app}\installers\git"; DestName: "git.exe"; AfterInstall: RunInstallGit();  Components: "Git"
Source: "{#virtualBoxCommon}"; DestDir: "{app}\installers\virtualbox"; Components: "VirtualBox"
Source: "{#virtualBoxMsi}"; DestDir: "{app}\installers\virtualbox"; DestName: "virtualbox.msi"; AfterInstall: RunInstallVirtualBox(); Components: "VirtualBox"

[Icons]
Name: "{userprograms}\Blockstack\Blockstack Browser"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\start.sh"""; IconFilename: "{app}/blockstack.ico"; Components: "Docker"
Name: "{userprograms}\Blockstack\Blockstack Docker Shell"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\docker_shell.sh"""; IconFilename: "{app}/blockstack.ico"; Components: "Docker"
Name: "{commondesktop}\Blockstack Browser"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\start.sh"""; IconFilename: "{app}/blockstack.ico"; Tasks: desktopicon; Components: "Docker"
Name: "{userprograms}\Blockstack\Blockstack Browser"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\start_d4w.sh"""; IconFilename: "{app}/blockstack.ico"; Components: "BlockstackD4W"
Name: "{userprograms}\Blockstack\Blockstack Docker Shell"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\docker_shell_d4w.sh"""; IconFilename: "{app}/blockstack.ico"; Components: "BlockstackD4W"
Name: "{commondesktop}\Blockstack Browser"; WorkingDir: "{app}"; Filename: "{pf64}\Git\bin\bash.exe"; Parameters: "--login -i ""{app}\start_d4w.sh"""; IconFilename: "{app}/blockstack.ico"; Tasks: desktopicon; Components: "BlockstackD4W"

[UninstallRun]
Filename: "{app}\docker-machine.exe"; Parameters: "rm -f default"

[Registry]
Root: HKCU; Subkey: "Environment"; ValueType:string; ValueName:"DOCKER_TOOLBOX_INSTALL_PATH"; ValueData:"{app}" ; Flags: preservestringtype uninsdeletevalue;
Root: HKCR; Subkey: "blockstack"; ValueType:string; ValueName:""; ValueData:"URL:Blockstack Browser"; Flags: uninsdeletevalue;
Root: HKCR; Subkey: "blockstack"; ValueType:string; ValueName:"URL Protocol"; ValueData:""; Flags: uninsdeletevalue;
Root: HKCR; Subkey: "blockstack\DefaultIcon"; ValueType:string; ValueName:""; ValueData:"{app}\blockstack.ico,1"; Flags: uninsdeletevalue;
Root: HKCR; Subkey: "blockstack\shell\open\command"; ValueType:string; ValueName:""; ValueData:"""{app}\blockstack.bat"" ""%1""" ; Flags: uninsdeletevalue;

[Code]
#include "base64.iss"
#include "guid.iss"

var
  TrackingDisabled: Boolean;
  TrackingCheckBox: TNewCheckBox;

function uuid(): String;
var
  dirpath: String;
  filepath: String;
  ansiresult: AnsiString;
begin
  dirpath := ExpandConstant('{userappdata}\BlockstackToolbox');
  filepath := dirpath + '\id.txt';
  ForceDirectories(dirpath);

  Result := '';
  if FileExists(filepath) then
    LoadStringFromFile(filepath, ansiresult);
    Result := String(ansiresult)

  if Length(Result) = 0 then
    Result := GetGuid('');
    StringChangeEx(Result, '{', '', True);
    StringChangeEx(Result, '}', '', True);
    SaveStringToFile(filepath, AnsiString(Result), False);
end;

function WindowsVersionString(): String;
var
  ResultCode: Integer;
  lines : TArrayOfString;
begin
  if not Exec(ExpandConstant('{cmd}'), ExpandConstant('/c wmic os get caption | more +1 > C:\windows-version.txt'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
    Result := 'N/A';
    exit;
  end;

  if LoadStringsFromFile(ExpandConstant('C:\windows-version.txt'), lines) then begin
    Result := lines[0];
  end else begin
    Result := 'N/A'
  end;
end;

procedure TrackEventWithProperties(name: String; properties: String);
var
  payload: String;
  WinHttpReq: Variant;
begin
  if TrackingDisabled or WizardSilent() then
    exit;

  if Length(properties) > 0 then
    properties := ', ' + properties;

  try
    payload := Encode64(Format(ExpandConstant('{{"event": "%s", "properties": {{"token": "{#MixpanelToken}", "distinct_id": "%s", "os": "win32", "os version": "%s", "version": "{#MyAppVersion}" %s}}'), [name, uuid(), WindowsVersionString(), properties]));
    WinHttpReq := CreateOleObject('WinHttp.WinHttpRequest.5.1');
    WinHttpReq.Open('POST', 'https://api.mixpanel.com/track/?data=' + payload, false);
    WinHttpReq.SetRequestHeader('Content-Type', 'application/json');
    WinHttpReq.Send('');
  except
  end;
end;

procedure TrackEvent(name: String);
begin
  TrackEventWithProperties(name, '');
end;

function NeedToInstallVirtualBox(): Boolean;
begin
  // TODO: Also compare versions
  Result := (
    (not HyperVInstalled())
    and
    (not DockerInstalled())
    and
    (GetEnv('VBOX_INSTALL_PATH') = '')
    and
    (GetEnv('VBOX_MSI_INSTALL_PATH') = '')
  );
end;

function VBoxPath(): String;
begin
  if GetEnv('VBOX_INSTALL_PATH') <> '' then
    Result := GetEnv('VBOX_INSTALL_PATH')
  else
    Result := GetEnv('VBOX_MSI_INSTALL_PATH')
end;

function DockerInstalled(): Boolean;
begin
  Result := not DirExists('C:\Program Files\Docker')
end;

function HyperVInstalled(): Boolean;
begin
  Result := not DirExists('C:\Program Files\Hyper-V')
end;

function NeedToInstallGit(): Boolean;
begin
  // TODO: Find a better way to see if Git is installed
  Result := not DirExists('C:\Program Files\Git') or not FileExists('C:\Program Files\Git\git-bash.exe')
end;

procedure InitializeWizard;
var
  WelcomePage: TWizardPage;
  TrackingLabel: TLabel;
begin

  WelcomePage := PageFromID(wpWelcome)

  WizardForm.WelcomeLabel2.AutoSize := True;


    if HyperVInstalled() and (not DockerInstalled()) then
        // TODO: need to error out.
        MsgBox('It looks like you have Hyper-V installed, but not Docker. In order to use Blockstack with Hyper-V, you must install Docker for Windows first.', mbCriticalError, MB_OK);
        exit;
    else
      if HyperVInstalled() and DockerInstalled() then
        Wizardform.ComponentsList.Checked[2] := False; // No Docker
        Wizardform.ComponentsList.Checked[3] := False; // No DockerMachine
        Wizardform.ComponentsList.Checked[4] := False; // No VirtualBox
      else
        Wizardform.ComponentsList.Checked[1] := False; // No Docker4Win scripts
        Wizardform.ComponentsList.Checked[4] := NeedToInstallVirtualBox();
        Wizardform.ComponentsList.ItemEnabled[4] := not NeedToInstallVirtualBox();
      end;
      Wizardform.ComponentsList.Checked[5] := NeedToInstallGit();
    end;
end;

function InitializeSetup(): boolean;
begin
  TrackEvent('Installer Started');
  Result := True;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpWelcome then begin
        TrackEventWithProperties('Continued from Overview', '"Tracking Enabled": "No"');
        TrackingDisabled := True;
        CreateDir(ExpandConstant('{userappdata}\..\.docker\machine'));
        SaveStringToFile(ExpandConstant('{userappdata}\..\.docker\machine\no-error-report'), '', False);
  end;
  Result := True
end;

procedure RunInstallVirtualBox();
var
  ResultCode: Integer;
begin
  if NeedToInstallVirtualBox() then
    WizardForm.FilenameLabel.Caption := 'installing VirtualBox'
    if not Exec(ExpandConstant('msiexec'), ExpandConstant('/qn /i "{app}\installers\virtualbox\virtualbox.msi" /norestart'), '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
      MsgBox('virtualbox install failure', mbInformation, MB_OK);
    end;
end;

procedure RunInstallGit();
var
  ResultCode: Integer;
begin
  WizardForm.FilenameLabel.Caption := 'installing Git for Windows'
  if Exec(ExpandConstant('{app}\installers\git\git.exe'), '/sp- /verysilent /norestart', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
  begin
    // handle success if necessary; ResultCode contains the exit code
    //MsgBox('git installed OK', mbInformation, MB_OK);
  end
  else begin
    // handle failure if necessary; ResultCode contains the error code
    MsgBox('git install failure', mbInformation, MB_OK);
  end;
end;

procedure CopyBoot2DockerISO();
begin
  WizardForm.FilenameLabel.Caption := 'copying boot2docker iso'
  if not ForceDirectories(ExpandConstant('{userappdata}\..\.docker\machine\cache')) then
      MsgBox('Failed to create docker machine cache dir', mbError, MB_OK);
  if not FileCopy(ExpandConstant('{app}\boot2docker.iso'), ExpandConstant('{userappdata}\..\.docker\machine\cache\boot2docker.iso'), false) then
      MsgBox('File moving failed!', mbError, MB_OK);
end;

function CanUpgradeVM(): Boolean;
var
  ResultCode: Integer;
begin
  if NeedToInstallVirtualBox() or not FileExists(ExpandConstant('{app}\docker-machine.exe')) then begin
    Result := false
    exit
  end;

  ExecAsOriginalUser(VBoxPath() + 'VBoxManage.exe', 'showvminfo default', '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  if ResultCode <> 0 then begin
    Result := false
    exit
  end;

  if not DirExists(ExpandConstant('{userappdata}\..\.docker\machine\machines\default')) then begin
    Result := false
    exit
  end;

  Result := true
end;

function UpgradeVM() : Boolean;
var
  ResultCode: Integer;
begin
  TrackEvent('VM Upgrade Started');
  WizardForm.StatusLabel.Caption := 'Upgrading Docker Toolbox VM...'
  ExecAsOriginalUser(ExpandConstant('{app}\docker-machine.exe'), 'stop default', '', SW_HIDE, ewWaitUntilTerminated, ResultCode)
  if (ResultCode = 0) or (ResultCode = 1) then
  begin
    FileCopy(ExpandConstant('{userappdata}\..\.docker\machine\cache\boot2docker.iso'), ExpandConstant('{userappdata}\..\.docker\machine\machines\default\boot2docker.iso'), false)
    TrackEvent('VM Upgrade Succeeded');
  end
  else begin
    TrackEvent('VM Upgrade Failed');
    MsgBox('VM Upgrade Failed because the VirtualBox VM could not be stopped.', mbCriticalError, MB_OK);
    Result := false
    WizardForm.Close;
    exit;
  end;
  Result := true
end;

const
  ModPathName = 'modifypath';
  ModPathType = 'user';

function ModPathDir(): TArrayOfString;
begin
  setArrayLength(Result, 1);
  Result[0] := ExpandConstant('{app}');
end;
#include "modpath.iss"

procedure CurStepChanged(CurStep: TSetupStep);
var
  Success: Boolean;
begin
  Success := True;
  if CurStep = ssPostInstall then
  begin
    trackEvent('Installing Files Succeeded');
    if IsTaskSelected(ModPathName) then
      ModPath();
    if not WizardSilent() then
    begin
      if IsTaskSelected('upgradevm') then
      begin
        if CanUpgradeVM() then begin
          Success := UpgradeVM();
        end;
      end;
    end;

    if Success then
      trackEvent('Installer Finished');
  end;
end;
