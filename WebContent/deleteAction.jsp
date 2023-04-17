<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO"%>
<%@ page import="likey.LikeyDTO"%>
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

    request.setCharacterEncoding("UTF-8");
    String evaluationID = null;
    
    if(request.getParameter("evaluationID") != null) {
        evaluationID = request.getParameter("evaluationID");
    }
    EvaluationDAO evaluationDAO = new EvaluationDAO();
    if(userID.equals(evaluationDAO.getUserID(evaluationID))) {
        int result = evaluationDAO.delete(evaluationID);
        if(result==1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('삭제가 완료되었습니다.');");
            script.println("location.href='index.jsp';");
            script.println("</script>");
            script.close();
            return;
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('DB오류가 발생하였습니다.');");
            script.println("history.back();");
            script.println("</script>");
            script.close();
            return;
        }
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('자신이 작성한 게시물만 삭제 가능합니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
%>