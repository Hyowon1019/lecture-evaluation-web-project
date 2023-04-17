<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.*"%>
<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>
<%
    UserDAO userDAO = new UserDAO();
    String userID = null;
    if(session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if(userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해주십시오.');");
        script.println("location.href='userLogin.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    boolean emailChecked = userDAO.getUserEmailChecked(userID);
    if(emailChecked == true){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이미 인증된 회원입니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
        script.close();
        return;
    }
    
    String host = "http://localhost:8005/Lecture_Evaluation/";
    String from = "4llll1019@gmail.com";
    String to = userDAO.getUserEmail(userID);
    String subject = "강의평가사이트 회원가입을 위한 인증 메일입니다.";
    String code = new SHA256().getSHA256(to);
    String content = "해당 링크에 접속하여 이메일 인증을 진행하십시오." + "<a href='" + host+ "emailCheckAction.jsp?code="+code+"'>이메일 인증하기</a>";
    session.setAttribute("code", code);
    
    Properties p = new Properties();
    p.put("mail.smtp.user", from);
    p.put("mail.smtp.host", "smtp.googlemail.com");
    p.put("mail.smtp.port", "465");
    p.put("mail.smtp.starttls.enable", "true");
    p.put("mail.smtp.auth", "true");
    p.put("mail.smtp.debug", "true");
    p.put("mail.smtp.socketFactory.port", "465");
    p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
    p.put("mail.smtp.socketFactory.fallback", "false");
    
    try {
        Authenticator auth = new Gmail();
        Session ses = Session.getInstance(p, auth);
        ses.setDebug(true);
        MimeMessage msg = new MimeMessage(ses);
        msg.setSubject(subject);
        Address fromAddr = new InternetAddress(from);
        msg.setFrom(fromAddr);
        Address toAddr = new InternetAddress(to);
        msg.addRecipient(Message.RecipientType.TO, toAddr);
        msg.setContent(content, "text/html;charset=UTF8");
        Transport.send(msg);
    }catch (Exception e) {
        e.printStackTrace();
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('오류가 발생했습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
    
%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>강의평가사이트</title>
<link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
    rel="stylesheet"
    integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65"
    crossorigin="anonymous">
    <style>
      html,
      body {
        height: 100%;
      }

      body {
        display: flex;
        flex-direction: column;
        margin: 0;
      }

      section {
        flex: 1;
      }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar bg-light">
        <div class="container-fluid">
            <a class="navbar-brand" href="./index.jsp" style="font-size: 30px;">강의평가사이트</a>
            <button class="navbar-toggler" type="button"
                data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false"
                aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link active"
                        aria-current="page" href="./index.jsp">Home</a></li>
                    <li class="nav-item dropdown"><a
                        class="nav-link dropdown-toggle" href="#" id="navbarDropdown"
                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            회원관리 </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
<%
    if(userID == null) {
%>
                            <li><a class="dropdown-item" href="./userLogin.jsp">로그인</a></li>
                            <li><a class="dropdown-item" href="./userJoin.jsp">회원가입</a></li>
<%
    } else {
%>
                            <li><a class="dropdown-item" href="./userLogout.jsp" style="color:red;">로그아웃</a></li>
<%
    }
%>
                        </ul>
                    </li>
                </ul>
                <form action="./index.jsp" method="get" class="d-flex me-2">
                    <input class="form-control me-2" type="text" name="search" placeholder="검색내용입력" aria-label="Search">
                    <button type="submit" class="btn btn-outline-primary" style="white-space: nowrap;">검색</button><!-- white-space:nowrap;은 검색 글씨를 가로로 보이도록 해줌 -->
                </form>
            </div>
        </div>
    </nav>
    <section class="container mt-5" style="max-width: 560px;"> <!-- section에서 container : 크기가 자동으로 조절되도록 함 -->
        <div class="alert alert-success mt-4" role="alert">
                    이메일 주소인증 메일이 전송되었습니다. 회원가입시 입력하였던 이메일에 로그인하셔서 인증을 진행해 주십시오.
        </div>
    </section>
    <footer class="bg-dark mt-4 p-5 text-center" style="color:#FFFFFF;">Copyright @ 2023 HWS All right reserved.</footer>
    <script
        src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
        integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
        crossorigin="anonymous"></script>
    <script
        src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.min.js"
        integrity="sha384-cuYeSxntonz0PPNlHhBs68uyIAVpIIOZZ5JqeqvYYIcEL727kskC66kF92t6Xl2V"
        crossorigin="anonymous"></script>
</body>
</html>