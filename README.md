🔍 Script Description
This PowerShell script is designed to interactively manage Windows Audit Policies related to Active Directory Domain Services (ADDS). Created by Alejandro Leon (GX-OPTI), the script:

Checks whether specific audit subcategories are currently enabled or disabled.

Asks the user if they want to enable or disable each policy.

Applies the changes using auditpol.exe.

Logs all actions (including changes, unchanged settings, and any errors) to a file named AuditPolicyChanges.log.

It uses color-coded output in the console for clarity and supports manual control over critical security auditing settings.

✅ Audit Policies Reviewed by the Script

Audit Policy Name	Subcategory GUID
Audit Directory Service Changes	{0CCE923F-69AE-11D9-BED3-505054503030}
Audit Account Management	{0CCE9240-69AE-11D9-BED3-505054503030}
Audit Object Access	{0CCE923D-69AE-11D9-BED3-505054503030}
Audit Logon	{0CCE923C-69AE-11D9-BED3-505054503030}
Audit Policy Change	{0CCE9241-69AE-11D9-BED3-505054503030}
Audit Privilege Use	{0CCE9242-69AE-11D9-BED3-505054503030}
Audit Directory Service Access	{0CCE923E-69AE-11D9-BED3-505054503030}
