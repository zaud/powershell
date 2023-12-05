# 署名用の証明書を作成
$cert = New-SelfSignedCertificate `
        -Subject "CN=PowerShellスクリプト署名用証明書" `
        -KeyAlgorithm RSA `
        -KeyLength 2048 `
        -Type CodeSigningCert `
        -CertStoreLocation Cert:\CurrentUser\My\ `
        -NotAfter ([datetime]"2050/01/01")
# 信頼済みのルートとして使用
Move-Item "Cert:\CurrentUser\My\$($cert.Thumbprint)" Cert:\CurrentUser\Root
 
# 証明書への参照を取得
$rootcert = @(Get-ChildItem cert:\CurrentUser\Root -CodeSigningCert)[0]
# スクリプトに署名
Set-AuthenticodeSignature .\gui-list.ps1 $rootcert
