package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator {
    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication("4llll1019", "ickpbmazpuaavxue");
    }

}
