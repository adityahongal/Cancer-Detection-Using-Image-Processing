function recipient = matlabmail(recipient, message, subject, sender, psswd)
% MATLABMAIL Send an email from a predefined gmail account.

%% Importent
%% Go to this link and change the setting
% https://www.google.com/settings/security/lesssecureapps

    sender = 'cancercentrejit@gmail.com';
    psswd = 'cancercentre@jit';


setpref('Internet','E_mail',sender);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',sender);
setpref('Internet','SMTP_Password',psswd);

props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');
% props.attachments.Add('text.tx');
sendmail(recipient, subject, message,'PatientData.txt');
end