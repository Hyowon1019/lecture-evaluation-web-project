<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
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
<%
    String userID = null;
    if(session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if(userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해주십시오')");
        script.println("location.href = 'userLogin.jsp'");
        script.println("</script>");
        script.close();
        return;
    }
%>
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
					<li class="nav-item"><a class="nav-link"
						aria-current="page" href="./index.jsp">Home</a></li><!-- 수정한부분임 -->
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
				<form class="d-flex me-2">
					<input class="form-control me-2" type="search" placeholder="검색내용입력"
						aria-label="Search">
					<button type="submit" class="btn btn-outline-primary"
						style="white-space: nowrap;">검색</button>
					<!-- white-space:nowrap;은 검색 글씨를 가로로 보이도록 해줌 -->
				</form>
			</div>
		</div>
	</nav>
	<section class="container mt-5" style="max-width: 560px;"> <!-- section에서 container : 크기가 자동으로 조절되도록 함 -->
	   <div class="alert alert-warning mt-4" role="alert">
	           이메일 주소 인증을 하셔야 이용 가능합니다. 인증 메일을 받지 못하셨습니까?
	   </div>
	   <a href="./emailSendAction.jsp" class="btn btn-outline-primary" style="width:100%;"> 인증 메일 재전송 </a>
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