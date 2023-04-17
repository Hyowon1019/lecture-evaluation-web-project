<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
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
    request.setCharacterEncoding("UTF-8");
    String lectureDivide = "전체";
    String searchType = "최신순";
    String search = "";
    int pageNumber = 0;
    
    if(request.getParameter("lectureDivide") != null) {
        lectureDivide = request.getParameter("lectureDivide");
    }
    if(request.getParameter("searchType") != null) {
        searchType = request.getParameter("searchType");
    }
    if(request.getParameter("search") != null) {
        search = request.getParameter("search");
    }
    if(request.getParameter("pageNumber") != null) {
        try  {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        } catch (Exception e) {
            System.out.println("검색 페이지 번호 오류");
        }
    }
    
    String userID = null;
    if(session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if(userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해주십시오.')");
        script.println("location.href = 'userLogin.jsp'");
        script.println("</script>");
        script.close();
        return;
    }
    boolean emailChecked = new UserDAO().getUserEmailChecked(userID);
    if(emailChecked == false) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('이메일 인증을 진행해주십시오.')");
        script.println("location.href = 'emailSendConfirm.jsp'");
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
					<li class="nav-item"><a class="nav-link active"
						aria-current="page" href="./index.jsp">Home</a></li>
					<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
							회원관리 
					</a>
						<ul class="dropdown-menu" aria-labelledby="navbarDropdown">
							<%
    if(userID == null) {
%>
							<li><a class="dropdown-item" href="./userLogin.jsp">로그인</a></li>
							<li><a class="dropdown-item" href="./userJoin.jsp">회원가입</a></li>
							<%
    } else {
%>
							<li><a class="dropdown-item" href="./userLogout.jsp"
								style="color: red;">로그아웃</a></li>
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
	<section class="container"> <!-- section에서 container : 크기가 자동으로 조절되도록 함 -->
	   <form method="get" action="./index.jsp" class="d-flex mt-3" style="width:50%;">
	       <select name="lectureDivide" class="form-select mx-1 mt-2" style="width:30%;">
	           <option value="전체">전체</option>
	           <option value="전공" <% if(lectureDivide.equals("전공")) out.println("selected"); %>>전공</option>
	           <option value="교양" <% if(lectureDivide.equals("교양")) out.println("selected"); %>>교양</option>
	           <option value="기타" <% if(lectureDivide.equals("기타")) out.println("selected"); %>>기타</option>
	       </select>
	       <select name="searchType" class="form-select mx-1 mt-2" style="width:30%;">
	           <option value="최신순">최신순</option>
	           <option value="추천순"<% if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
	       </select>
	       <input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하시오">
	       <button type="submit" class="btn btn-outline-primary mx-1 mt-2" style="white-space: nowrap;">검색</button>
	       <a class="btn btn-outline-success mx-1 mt-2" data-bs-toggle="modal" href="#registerModal" style="white-space: nowrap;">등록</a>
	       <a class="btn btn-outline-danger mx-1 mt-2" data-bs-toggle="modal" href="#reportModal" style="white-space: nowrap;">신고</a>
	   </form>
<%
    ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
    evaluationList = new EvaluationDAO().getList(lectureDivide, searchType, search, pageNumber);
    if(evaluationList != null) {
        for(int i=0; i<evaluationList.size(); i++) {
            if(i==5) break;
            EvaluationDTO evaluation = evaluationList.get(i);
%>
		<div class="card bg-light mt-3">
			<div class="card-header bg light">
				<div class="row">
					<div class="col-8">
						<%=evaluation.getLectureName() %>&nbsp;<small><%=evaluation.getProfessorName() %></small>
					</div>
					<div class="col-4 text-end">
						종합 : <span style="color: red;"><%=evaluation.getTotalScore() %></span>
					</div>
				</div>
			</div>
			<div class="card-body">
			     <h5 class="card-title"><%=evaluation.getEvaluationTitle() %>&nbsp;<small>(<%=evaluation.getLectureYear() %>년 <%=evaluation.getSemesterDivide() %>)</small></h5>
			     <p class="card-text"><%=evaluation.getEvaluationContent() %></p>
			     <div class="row">
					<div class="col-9">
						학점비율 : <span style="color: red;"><%=evaluation.getCreditScore() %>&nbsp;&nbsp;</span> 
						강의난이도 : <span style="color: red;"><%=evaluation.getComfortableScore() %>&nbsp;&nbsp;</span> 
						강의스타일 : <span style="color: red;"><%=evaluation.getLectureScore() %>&nbsp;&nbsp;</span> 
						<span style="color: blue">(추천 : <%=evaluation.getLikeCount() %>)&nbsp;&nbsp;</span>
					</div>
					<div class="col-3 text-end">
						<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%=evaluation.getEvaluaionID() %>" style="text-decoration: none">추천&nbsp;</a> 
						<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%=evaluation.getEvaluaionID() %>" style="text-decoration: none">삭제&nbsp;</a>
					</div>
				</div>
			</div>
		</div>
<%
        }
    }
%>
	</section>
	<ul class="pagination justify-content-center mt-3">
        <li class="page-item">
<%
    if(pageNumber<=0) {
%>
            <a class="page-link disabled">이전</a>
<%
    } else {
%>       
            <a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
            <%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
            <%= pageNumber-1 %>">이전</a>
<%
    }
%>       
        </li>
        <li>
<%
    if(pageNumber<6) {
%>
            <a class="page-link disabled">다음</a>
<%
    } else {
%>       
            <a class="page-link" href="./index.jsp?lectureDivide=<%= URLEncoder.encode(lectureDivide, "UTF-8") %>&searchType=
            <%= URLEncoder.encode(searchType, "UTF-8") %>&search=<%= URLEncoder.encode(search, "UTF-8") %>&pageNumber=
            <%= pageNumber+1 %>">다음</a>
<%
    }
%>        
        </li>
	</ul>
	<div class="modal fade" id="registerModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="staticBackdropLabel">평가등록</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> <!-- data-bs-dismiss="modal" : 닫게하는 기능에 대한 속성 -->
				</div>
				<form action="./evaluationRegisterAction.jsp" method="post">
					<div class="modal-body">
						<div class="row my-3">
							<div class="form-group col-sm-6">
								<label>강의명</label> <input type="text" name="lectureName" class="form-control" maxlength="20">
							</div>
							<div class="form-group col-sm-6">
								<label>교수명</label> <input type="text" name="professorName" class="form-control" maxlength="20">
							</div>
						</div>
						<div class="row my-3">
							<div class="form-group col-sm-4">
								<label>수강연도</label> <select name="lectureYear"
									class="form-select">
									<option value="2015">2015</option>
									<option value="2016">2016</option>
									<option value="2017">2017</option>
									<option value="2018">2018</option>
									<option value="2019">2019</option>
									<option value="2020">2020</option>
									<option value="2021">2021</option>
									<option value="2022">2022</option>
									<option value="2023" selected="selected">2023</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>수강학기</label> <select name="semesterDivide"
									class="form-select">
									<option value="1학기" selected="selected">1학기</option>
									<option value="2학기">2학기</option>
									<option value="하기계절">하기계절</option>
									<option value="동기계절">동기계절</option>
								</select>
							</div>
							<div class="form-group col-sm-4">
								<label>강의구분</label> <select name="lectureDivide"
									class="form-select">
									<option value="전공" selected="selected">전공</option>
									<option value="교양">교양</option>
									<option value="일반">일반</option>
								</select>
							</div>
						</div>
						<div class="row my-3">
							<label>평가제목</label> 
							<input type="text" name="evaluationTitle" class="form-control" maxlength="30" placeholder="제목을 입력하시오.">
						</div>
						<div class="row my-3">
							<label>평가내용</label>
							<textarea name="evaluationContent" class="form-control" maxlength="2048" placeholder="내용을 입력하시오." style="height: 180px;"></textarea>
						</div>
						<div class="row my-3">
							<div class="form-group col-sm-3">
							     <label>종합</label>
							     <select name="totalScore" class="form-select">
							         <option value="A">A</option>
							         <option value="B">B</option>
							         <option value="C">C</option>
							         <option value="D">D</option>
							         <option value="F">F</option>
							     </select>
							</div>
							<div class="form-group col-sm-3">
							     <label>학점비율</label>
							     <select name="creditScore" class="form-select">
							         <option value="학점느님">학점느님</option>
							         <option value="비율맞춰서">비율맞춰서</option>
							         <option value="짜게주심">짜게주심</option>
							     </select>
							</div>
							<div class="form-group col-sm-3">
							     <label>강의난이도</label>
							     <select name="comfortableScore" class="form-select">
							         <option value="★">★</option>
							         <option value="★★">★★</option>
							         <option value="★★★">★★★</option>
							         <option value="★★★★">★★★★</option>
							         <option value="★★★★★" selected="selected">★★★★★</option>
							     </select>
							</div>
							<div class="form-group col-sm-3">
							     <label>강의스타일</label>
							     <select name="lectureScore" class="form-select">
							         <option value="과제없음">과제없음</option>
							         <option value="과제적당">과제적당</option>
							         <option value="과제많음">과제많음</option>
							     </select>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<input type="reset" class="btn btn-success">
						<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
						<button type="submit" class="btn btn-primary">평가제출</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<div class="modal fade" id="reportModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="staticBackdropLabel">신고하기</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button> <!-- data-bs-dismiss="modal" : 닫게하는 기능에 대한 속성 -->
                </div>
                <form action="./reportAction.jsp" method="post">
                    <div class="modal-body">
                        <div class="row my-3">
                            <label>신고제목</label> 
                            <input type="text" name="reportTitle" class="form-control" maxlength="30" placeholder="제목을 입력하시오.">
                        </div>
                        <div class="row my-3">
                            <label>신고내용</label>
                            <textarea name="reportContent" class="form-control" maxlength="2048" placeholder="내용을 입력하시오." style="height: 180px;"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="reset" class="btn btn-success">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-danger">신고제출</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
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