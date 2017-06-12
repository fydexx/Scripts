param
(
#default path where KeePass normally installs, change if needed
    $PathToKeePassFolder = "C:\Program Files (x86)\KeePass Password Safe 2"
)
#Load all .NET binaries in the folder
(Get-ChildItem -recurse $PathToKeePassFolder|Where-Object {($_.Extension -EQ ".dll") -or ($_.Extension -eq ".exe")} | ForEach-Object { $AssemblyName=$_.FullName; Try {[Reflection.Assembly]::LoadFile($AssemblyName) } Catch{ }} ) | out-null

<#
.Synopsis
   Gets matching EntryToFind in KeePass DB
.DESCRIPTION
   Gets matching EntryToFind in KeePass DB using Windows Integrated logon
.EXAMPLE
   Example of how to use this cmdlet
   Get-PasswordInKeePassDB -PathToDB "C:\Powershell\PowerShell.kdbx" -EntryToFind "MasterPassword"
#>

Function Get-PasswordInKeePassDB
{
    [CmdletBinding()]
    [OutputType([String[]])]

    param(

        $PathToDB = "K:\Information Technology\Accounts\SFTPAccounts.kdbx",
        $EntryToFind = "MasterPassword"
    )

    $PwDatabase = new-object KeePassLib.PwDatabase

    $m_pKey = new-object KeePassLib.Keys.CompositeKey
    $m_pKey.AddUserKey((New-Object KeePassLib.Keys.KcpUserAccount))

    $m_ioInfo = New-Object KeePassLib.Serialization.IOConnectionInfo
    $m_ioInfo.Path = $PathToDB

    $IStatusLogger = New-Object KeePassLib.Interfaces.NullStatusLogger

    $PwDatabase.Open($m_ioInfo,$m_pKey,$IStatusLogger)

    
    $pwItems = $PwDatabase.RootGroup.GetObjects($true, $true)
    foreach($pwItem in $pwItems)
    {
        if ($pwItem.Strings.ReadSafe("Title") -eq $EntryToFind)
        {
            $pwItem.Strings.ReadSafe("Password")
        }
    }
    $PwDatabase.Close()

}

<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
   GetPasswordInKeePassDBUsingPassword -EntryToFind "domain\username" -PasswordToDB myNonTopSeceretPasswordInClearText
.EXAMPLE
   Get password using Integrated logon to get master password and then use that to unlock and find the password in the big one.
   Get-PasswordInKeePassDBUsingPassword -EntryToFind "domain\username" -PasswordToDB (Get-PasswordInKeePassDB -EntryToFind "MasterPassword")
#>
function Get-PasswordInKeePassDBUsingPassword
{
    [CmdletBinding()]
    [OutputType([String[]])]
    Param
    (
        # Path To password DB
        $PathToDB = "\\unc-path\Passwords\Passwords.kdbx",
        # Entry to find in DB
        $EntryToFind = "Top Secret Password",
        # Password used to open KeePass DB        
        [Parameter(Mandatory=$true)][String]$PasswordToDB
    )

    $PwDatabase = new-object KeePassLib.PwDatabase

    $m_pKey = new-object KeePassLib.Keys.CompositeKey
    $m_pKey.AddUserKey((New-Object KeePassLib.Keys.KcpPassword($PasswordToDB)));

    $m_ioInfo = New-Object KeePassLib.Serialization.IOConnectionInfo
    $m_ioInfo.Path = $PathToDB

    $IStatusLogger = New-Object KeePassLib.Interfaces.NullStatusLogger

    $PwDatabase.Open($m_ioInfo,$m_pKey,$IStatusLogger)

    
    $pwItems = $PwDatabase.RootGroup.GetObjects($true, $true)
    foreach($pwItem in $pwItems)
    {
        if ($pwItem.Strings.ReadSafe("Title") -eq $EntryToFind)
        {
            $pwItem.Strings.ReadSafe("Password")
        }
    }
    $PwDatabase.Close()
    $PasswordToDB = $null

}