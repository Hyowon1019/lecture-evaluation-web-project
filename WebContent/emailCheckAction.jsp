<%@page import="javax.swing.text.Document"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>
<%
    request.setCharacterEncoding("UTF-8");
    String code = null;
    if(session.getAttribute("code") != null) {
        code = (String) session.getAttribute("code"); // 기본적으로 Object 객체를 반환하므로 (String)으로 타입캐스팅을 진행하여야함.
    }
    
    UserDAO userDAO = new UserDAO();
    String userID = null;
    
    if(session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID"); // 기본적으로 Object 객체를 반환하므로 (String)으로 타입캐스팅을 진행하여야함.
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
    
    String userEmail = userDAO.getUserEmail(userID);
    boolean isRight = (new SHA256().getSHA256(userEmail).equals(code)) ? true : false;
    
    if(isRight == true) {
        userDAO.setUserEmailChecked(userID);
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('인증에 성공하였습니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
        script.close();
        return;
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 코드입니다.');");
        script.println("location.href='index.jsp'");
        script.println("</script>");
        script.close();
        return;
    }
%>